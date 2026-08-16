using EduLab_Domain.IRepository;
using System.Linq.Expressions;

namespace EduLab.Tests.Fakes;

/// <summary>
/// In-memory implementation of IRepository{T} for unit tests.
/// Mutations persist because the same object instances live in the list.
/// </summary>
public class FakeRepository<T> : IRepository<T> where T : class
{
    public List<T> Items { get; } = new();

    public FakeRepository() { }

    public FakeRepository(IEnumerable<T>? seed)
    {
        if (seed != null)
            Items.AddRange(seed);
    }

    public Task<List<T>> GetAllAsync(
        Expression<Func<T, bool>>? filter = null,
        string? includeProperties = null,
        bool isTracking = false,
        Func<IQueryable<T>, IOrderedQueryable<T>>? orderBy = null,
        int? take = null,
        CancellationToken cancellationToken = default)
    {
        IQueryable<T> query = Items.AsQueryable();

        if (filter != null)
            query = query.Where(filter);
        if (orderBy != null)
            query = orderBy(query);
        if (take.HasValue)
            query = query.Take(take.Value);

        return Task.FromResult(query.ToList());
    }

    public Task<T> GetAsync(
        Expression<Func<T, bool>> filter,
        string? includeProperties = null,
        bool isTracking = false,
        CancellationToken cancellationToken = default)
    {
        return Task.FromResult(Items.AsQueryable().FirstOrDefault(filter)!);
    }

    public Task<bool> AnyAsync(Expression<Func<T, bool>> predicate, CancellationToken cancellationToken = default)
        => Task.FromResult(Items.AsQueryable().Any(predicate));

    public Task CreateAsync(T entity, CancellationToken cancellationToken = default)
    {
        Items.Add(entity);
        return Task.CompletedTask;
    }

    public Task DeleteAsync(T entity, CancellationToken cancellationToken = default)
    {
        Items.Remove(entity);
        return Task.CompletedTask;
    }

    public Task DeleteRangeAsync(IEnumerable<T> entities, CancellationToken cancellationToken = default)
    {
        foreach (var entity in entities.ToList())
            Items.Remove(entity);
        return Task.CompletedTask;
    }

    public Task SaveAsync(CancellationToken cancellationToken = default)
        => Task.CompletedTask;
}
