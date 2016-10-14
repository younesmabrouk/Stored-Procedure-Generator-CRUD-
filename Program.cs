using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;

namespace StoredProcedureGenerator
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("--------------WELCOME TO STORED PROCEDURE GENERATOR--------------");
            Console.WriteLine("-----------------------ENTER YOUR TABLE--------------------------");
            string baseName = Console.ReadLine();


            string connectionString = "Data Source=" + ConfigurationManager.AppSettings["PC_NAME"] + ";Initial Catalog=" + baseName + ";Integrated Security=True";

            MSSQL_GenerateCrudStoredProcedures ms = new MSSQL_GenerateCrudStoredProcedures(connectionString);
            ms.CrudSpTemplateFile = @"Templates\CrudSpTemplate.spt";
            ms.OutputFilesPath = @"Crud"+baseName+"Database";


            try
            {
                //generate SPs
                ms.GenerateStoredProcedures();
            }
            catch (Exception ex)
            {
                Console.WriteLine("\nERROR: " + ex.Message);
            }
            //stop :)
            Console.Read();
        }

    }

}
