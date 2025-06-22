using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace EduLab_Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class Add_Models_To_Database : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Enrollments_Courses_CourseId",
                table: "Enrollments");

            migrationBuilder.DropForeignKey(
                name: "FK_Lectures_Sections_SectionId",
                table: "Lectures");

            migrationBuilder.DropForeignKey(
                name: "FK_Reviews_Courses_CourseId1",
                table: "Reviews");

            migrationBuilder.DropForeignKey(
                name: "FK_Sections_Courses_CourseId",
                table: "Sections");

            migrationBuilder.DropIndex(
                name: "IX_Reviews_CourseId1",
                table: "Reviews");

            migrationBuilder.DropColumn(
                name: "CourseId1",
                table: "Reviews");

            migrationBuilder.AddColumn<int>(
                name: "Order",
                table: "Sections",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AlterColumn<string>(
                name: "VideoUrl",
                table: "Lectures",
                type: "nvarchar(max)",
                nullable: true,
                oldClrType: typeof(string),
                oldType: "nvarchar(max)");

            migrationBuilder.AddColumn<string>(
                name: "ArticleContent",
                table: "Lectures",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<int>(
                name: "ContentType",
                table: "Lectures",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<bool>(
                name: "IsFreePreview",
                table: "Lectures",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<int>(
                name: "Order",
                table: "Lectures",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<int>(
                name: "QuizId",
                table: "Lectures",
                type: "int",
                nullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "ThumbnailUrl",
                table: "Courses",
                type: "nvarchar(max)",
                nullable: true,
                oldClrType: typeof(string),
                oldType: "nvarchar(max)");

            migrationBuilder.AddColumn<int>(
                name: "CategoryId",
                table: "Courses",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<decimal>(
                name: "Discount",
                table: "Courses",
                type: "decimal(18,2)",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "Duration",
                table: "Courses",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<bool>(
                name: "HasCertificate",
                table: "Courses",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<string>(
                name: "Language",
                table: "Courses",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "Learnings",
                table: "Courses",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "[]");

            migrationBuilder.AddColumn<string>(
                name: "Level",
                table: "Courses",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "Requirements",
                table: "Courses",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "[]");

            migrationBuilder.AddColumn<string>(
                name: "ShortDescription",
                table: "Courses",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "TargetAudience",
                table: "Courses",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");

            migrationBuilder.CreateTable(
                name: "Categories",
                columns: table => new
                {
                    Category_Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Category_Name = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Categories", x => x.Category_Id);
                });

            migrationBuilder.CreateIndex(
                name: "IX_Courses_CategoryId",
                table: "Courses",
                column: "CategoryId");

            migrationBuilder.AddForeignKey(
                name: "FK_Courses_Categories_CategoryId",
                table: "Courses",
                column: "CategoryId",
                principalTable: "Categories",
                principalColumn: "Category_Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_Enrollments_Courses_CourseId",
                table: "Enrollments",
                column: "CourseId",
                principalTable: "Courses",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_Lectures_Sections_SectionId",
                table: "Lectures",
                column: "SectionId",
                principalTable: "Sections",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_Sections_Courses_CourseId",
                table: "Sections",
                column: "CourseId",
                principalTable: "Courses",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Courses_Categories_CategoryId",
                table: "Courses");

            migrationBuilder.DropForeignKey(
                name: "FK_Enrollments_Courses_CourseId",
                table: "Enrollments");

            migrationBuilder.DropForeignKey(
                name: "FK_Lectures_Sections_SectionId",
                table: "Lectures");

            migrationBuilder.DropForeignKey(
                name: "FK_Sections_Courses_CourseId",
                table: "Sections");

            migrationBuilder.DropTable(
                name: "Categories");

            migrationBuilder.DropIndex(
                name: "IX_Courses_CategoryId",
                table: "Courses");

            migrationBuilder.DropColumn(
                name: "Order",
                table: "Sections");

            migrationBuilder.DropColumn(
                name: "ArticleContent",
                table: "Lectures");

            migrationBuilder.DropColumn(
                name: "ContentType",
                table: "Lectures");

            migrationBuilder.DropColumn(
                name: "IsFreePreview",
                table: "Lectures");

            migrationBuilder.DropColumn(
                name: "Order",
                table: "Lectures");

            migrationBuilder.DropColumn(
                name: "QuizId",
                table: "Lectures");

            migrationBuilder.DropColumn(
                name: "CategoryId",
                table: "Courses");

            migrationBuilder.DropColumn(
                name: "Discount",
                table: "Courses");

            migrationBuilder.DropColumn(
                name: "Duration",
                table: "Courses");

            migrationBuilder.DropColumn(
                name: "HasCertificate",
                table: "Courses");

            migrationBuilder.DropColumn(
                name: "Language",
                table: "Courses");

            migrationBuilder.DropColumn(
                name: "Learnings",
                table: "Courses");

            migrationBuilder.DropColumn(
                name: "Level",
                table: "Courses");

            migrationBuilder.DropColumn(
                name: "Requirements",
                table: "Courses");

            migrationBuilder.DropColumn(
                name: "ShortDescription",
                table: "Courses");

            migrationBuilder.DropColumn(
                name: "TargetAudience",
                table: "Courses");

            migrationBuilder.AddColumn<int>(
                name: "CourseId1",
                table: "Reviews",
                type: "int",
                nullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "VideoUrl",
                table: "Lectures",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "",
                oldClrType: typeof(string),
                oldType: "nvarchar(max)",
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "ThumbnailUrl",
                table: "Courses",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "",
                oldClrType: typeof(string),
                oldType: "nvarchar(max)",
                oldNullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_Reviews_CourseId1",
                table: "Reviews",
                column: "CourseId1");

            migrationBuilder.AddForeignKey(
                name: "FK_Enrollments_Courses_CourseId",
                table: "Enrollments",
                column: "CourseId",
                principalTable: "Courses",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_Lectures_Sections_SectionId",
                table: "Lectures",
                column: "SectionId",
                principalTable: "Sections",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_Reviews_Courses_CourseId1",
                table: "Reviews",
                column: "CourseId1",
                principalTable: "Courses",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_Sections_Courses_CourseId",
                table: "Sections",
                column: "CourseId",
                principalTable: "Courses",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);
        }
    }
}
