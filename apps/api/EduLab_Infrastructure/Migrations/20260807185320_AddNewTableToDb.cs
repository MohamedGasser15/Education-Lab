using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace EduLab_Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class AddNewTableToDb : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "OperationKeyId",
                table: "Histories",
                type: "int",
                nullable: true);

            migrationBuilder.CreateTable(
                name: "OperationKeys",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false),
                    Key = table.Column<string>(type: "nvarchar(max)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_OperationKeys", x => x.Id);
                });

            migrationBuilder.CreateIndex(
                name: "IX_Histories_OperationKeyId",
                table: "Histories",
                column: "OperationKeyId");

            migrationBuilder.AddForeignKey(
                name: "FK_Histories_OperationKeys_OperationKeyId",
                table: "Histories",
                column: "OperationKeyId",
                principalTable: "OperationKeys",
                principalColumn: "Id",
                onDelete: ReferentialAction.SetNull);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Histories_OperationKeys_OperationKeyId",
                table: "Histories");

            migrationBuilder.DropTable(
                name: "OperationKeys");

            migrationBuilder.DropIndex(
                name: "IX_Histories_OperationKeyId",
                table: "Histories");

            migrationBuilder.DropColumn(
                name: "OperationKeyId",
                table: "Histories");
        }
    }
}
