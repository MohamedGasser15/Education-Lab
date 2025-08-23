using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace EduLab_Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class Add_PropsToUser_To_Db : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Certificates_Enrollments_EnrollmentId",
                table: "Certificates");

            migrationBuilder.DropIndex(
                name: "IX_Certificates_EnrollmentId",
                table: "Certificates");

            migrationBuilder.DropColumn(
                name: "IssuedAt",
                table: "Certificates");

            migrationBuilder.RenameColumn(
                name: "EnrollmentId",
                table: "Certificates",
                newName: "Year");

            migrationBuilder.RenameColumn(
                name: "CertificateUrl",
                table: "Certificates",
                newName: "Name");

            migrationBuilder.AddColumn<string>(
                name: "Issuer",
                table: "Certificates",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "UserId",
                table: "Certificates",
                type: "nvarchar(450)",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "Subjects",
                table: "AspNetUsers",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "[]");

            migrationBuilder.CreateIndex(
                name: "IX_Certificates_UserId",
                table: "Certificates",
                column: "UserId");

            migrationBuilder.AddForeignKey(
                name: "FK_Certificates_AspNetUsers_UserId",
                table: "Certificates",
                column: "UserId",
                principalTable: "AspNetUsers",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Certificates_AspNetUsers_UserId",
                table: "Certificates");

            migrationBuilder.DropIndex(
                name: "IX_Certificates_UserId",
                table: "Certificates");

            migrationBuilder.DropColumn(
                name: "Issuer",
                table: "Certificates");

            migrationBuilder.DropColumn(
                name: "UserId",
                table: "Certificates");

            migrationBuilder.DropColumn(
                name: "Subjects",
                table: "AspNetUsers");

            migrationBuilder.RenameColumn(
                name: "Year",
                table: "Certificates",
                newName: "EnrollmentId");

            migrationBuilder.RenameColumn(
                name: "Name",
                table: "Certificates",
                newName: "CertificateUrl");

            migrationBuilder.AddColumn<DateTime>(
                name: "IssuedAt",
                table: "Certificates",
                type: "datetime2",
                nullable: false,
                defaultValue: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.CreateIndex(
                name: "IX_Certificates_EnrollmentId",
                table: "Certificates",
                column: "EnrollmentId");

            migrationBuilder.AddForeignKey(
                name: "FK_Certificates_Enrollments_EnrollmentId",
                table: "Certificates",
                column: "EnrollmentId",
                principalTable: "Enrollments",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);
        }
    }
}
