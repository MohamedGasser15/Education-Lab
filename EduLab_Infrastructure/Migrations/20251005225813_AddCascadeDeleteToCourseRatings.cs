using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace EduLab_Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class AddCascadeDeleteToCourseRatings : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Ratings_Courses_CourseId",
                table: "Ratings");

            migrationBuilder.DropForeignKey(
                name: "FK_Ratings_Courses_CourseId1",
                table: "Ratings");

            migrationBuilder.DropIndex(
                name: "IX_Ratings_CourseId1",
                table: "Ratings");

            migrationBuilder.DropColumn(
                name: "CourseId1",
                table: "Ratings");

            migrationBuilder.AddForeignKey(
                name: "FK_Ratings_Courses_CourseId",
                table: "Ratings",
                column: "CourseId",
                principalTable: "Courses",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Ratings_Courses_CourseId",
                table: "Ratings");

            migrationBuilder.AddColumn<int>(
                name: "CourseId1",
                table: "Ratings",
                type: "int",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_Ratings_CourseId1",
                table: "Ratings",
                column: "CourseId1");

            migrationBuilder.AddForeignKey(
                name: "FK_Ratings_Courses_CourseId",
                table: "Ratings",
                column: "CourseId",
                principalTable: "Courses",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_Ratings_Courses_CourseId1",
                table: "Ratings",
                column: "CourseId1",
                principalTable: "Courses",
                principalColumn: "Id");
        }
    }
}
