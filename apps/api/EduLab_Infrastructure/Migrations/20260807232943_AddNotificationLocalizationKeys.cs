using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace EduLab_Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class AddNotificationLocalizationKeys : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "MessageKey",
                table: "Notifications",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "Parameters",
                table: "Notifications",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "TitleKey",
                table: "Notifications",
                type: "nvarchar(max)",
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "MessageKey",
                table: "Notifications");

            migrationBuilder.DropColumn(
                name: "Parameters",
                table: "Notifications");

            migrationBuilder.DropColumn(
                name: "TitleKey",
                table: "Notifications");
        }
    }
}
