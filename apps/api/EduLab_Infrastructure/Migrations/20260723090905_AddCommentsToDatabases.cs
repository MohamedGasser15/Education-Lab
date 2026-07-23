using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace EduLab_Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class AddCommentsToDatabases : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "ParentCommentId",
                table: "LectureComments",
                type: "int",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_LectureComments_ParentCommentId",
                table: "LectureComments",
                column: "ParentCommentId");

            migrationBuilder.AddForeignKey(
                name: "FK_LectureComments_LectureComments_ParentCommentId",
                table: "LectureComments",
                column: "ParentCommentId",
                principalTable: "LectureComments",
                principalColumn: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_LectureComments_LectureComments_ParentCommentId",
                table: "LectureComments");

            migrationBuilder.DropIndex(
                name: "IX_LectureComments_ParentCommentId",
                table: "LectureComments");

            migrationBuilder.DropColumn(
                name: "ParentCommentId",
                table: "LectureComments");
        }
    }
}
