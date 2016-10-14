using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace StoredProcedureGenerator
{
    /// <summary>
    /// Prefabricated Querys
    /// </summary>
    public static class QueryHelper
    {
        /// <summary>
        /// query: Get all tables, collumns, and some collumns datas
        /// </summary>
        public static string SelectTablesQuery =
            "select c.TABLE_NAME, c.COLUMN_NAME, c.DATA_TYPE, c.CHARACTER_MAXIMUM_LENGTH, COLUMNPROPERTY(OBJECT_ID(t.TABLE_SCHEMA + '.' + t.TABLE_NAME), c.COLUMN_NAME, 'isIdentity') as IsIdentity " +  //IS_NULLABLE
            "from INFORMATION_SCHEMA.COLUMNS AS c " + 
                "INNER JOIN INFORMATION_SCHEMA.TABLES AS t " +
		        "ON c.TABLE_SCHEMA = t.TABLE_SCHEMA AND c.TABLE_NAME = t.TABLE_NAME " + 
            "order by TABLE_NAME";

        /// <summary>
        /// query: Get primary keys
        /// </summary>
        /// <param name="tableName"></param>
        /// <returns></returns>
        public static string GetPrimaryKeyByTableNameQuery(string tableName)
        {
            string result =
            @"SELECT [name], [id]
                    FROM syscolumns 
                    WHERE [id] IN (SELECT [id] 
                                        FROM sysobjects 
                                        WHERE [name] = '" + tableName + @"')
                    AND colid IN (SELECT SIK.colid 
                                        FROM sysindexkeys SIK 
                                        JOIN sysobjects SO ON SIK.[id] = SO.[id]
                                        WHERE SIK.indid = 1
                                        AND SO.[name] = '" + tableName + "')";

            return result;
        }

    }
}
