using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace EduLab_Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class Add_Prop_To_CourseModel : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "Duration",
                table: "Lectures",
                newName: "OldDuration");

            migrationBuilder.AddColumn<int>(
                name: "Duration",
                table: "Lectures",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.DropColumn(
                name: "OldDuration",
                table: "Lectures");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<TimeSpan>(
                name: "OldDuration",
                table: "Lectures",
                type: "time",
                nullable: false,
                defaultValue: new TimeSpan(0, 0, 0));

            migrationBuilder.DropColumn(
                name: "Duration",
                table: "Lectures");

            migrationBuilder.RenameColumn(
                name: "OldDuration",
                table: "Lectures",
                newName: "Duration");
        }
    }
}
