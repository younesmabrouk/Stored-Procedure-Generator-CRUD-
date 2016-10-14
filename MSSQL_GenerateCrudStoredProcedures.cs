using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.SqlClient;
using System.IO;

namespace StoredProcedureGenerator
{
    /// <summary>
    /// Stored Procedure generator class to MSSQL database
    /// </summary>
    public class MSSQL_GenerateCrudStoredProcedures
    {
        #region private fields
        private string _ConnectionString;

        private string _CrudSpTemplateFile;

        private string _OutputFilesPath;
        #endregion

        #region public properties
        public string ConnectionString
        {
            get { return _ConnectionString; }
            set { _ConnectionString = value; }
        }

        public string CrudSpTemplateFile
        {
            get { return _CrudSpTemplateFile; }
            set { _CrudSpTemplateFile = value; }
        }


        public string OutputFilesPath
        {
            get { return _OutputFilesPath; }
            set { _OutputFilesPath = value; }
        }
        #endregion

        #region konstruktorok
    
        public MSSQL_GenerateCrudStoredProcedures()
        {
        }

        public MSSQL_GenerateCrudStoredProcedures(string connectionString)
        {
            _ConnectionString = connectionString;
        }

        /// <summary>
        /// Constructor
        /// </summary>
        /// <param name="connectionString"></param>
        /// <param name="insertTemplateFile"></param>
        /// <param name="updateTemplateFile"></param>
        /// <param name="deleteTemplateFile"></param>
        public MSSQL_GenerateCrudStoredProcedures(string connectionString,
            string crudTemplateFile)
        {
            this._ConnectionString = connectionString;

            this._CrudSpTemplateFile = crudTemplateFile;
            
        }

        /// <summary>
        /// Constructor
        /// </summary>
        /// <param name="connectionString"></param>
        /// <param name="insertTemplateFile"></param>
        /// <param name="updateTemplateFile"></param>
        /// <param name="deleteTemplateFile"></param>
        /// <param name="outputFilePath">path for Output files</param>
        public MSSQL_GenerateCrudStoredProcedures(string connectionString,
            string crudTemplateFile,
            string outputFilePath)
        {
            this._ConnectionString = connectionString;

            this._CrudSpTemplateFile = crudTemplateFile;
            this._OutputFilesPath = outputFilePath;

        }

        #endregion

        /// <summary>
        /// Call the all sp generate method
        /// </summary>
        public void GenerateStoredProcedures()
        {
            if (String.IsNullOrEmpty(_ConnectionString))
                throw new Exception("The ConnectionString is NULL or EMPTY!");

            if (String.IsNullOrEmpty(_OutputFilesPath))
            {
                _OutputFilesPath = @"storedProcedures";
            }


            CrudSp();

            //InsertSP();
            //UpdateSP();
            //DeleteSP();
        }

        #region first work to SP generate
        private void CrudSp()
        {
            if (String.IsNullOrEmpty(_ConnectionString))
                return;
            if (String.IsNullOrEmpty(_CrudSpTemplateFile))
                return;
            if (!File.Exists(_CrudSpTemplateFile))
            {
                string message = "\nThe Insert template file is not exist!";
                //throw new Exception(message);
                Console.WriteLine(message);
                return;
            }

            SqlConnection sqlConn = new SqlConnection(_ConnectionString);
            SqlDataReader sdr = null;
            try
            {
                sqlConn.Open();

                
                SqlCommand command = new SqlCommand(QueryHelper.SelectTablesQuery, sqlConn);
                sdr = command.ExecuteReader();

                Dictionary<string, string> template = new Dictionary<string, string>();
                string tableName = "";
                string parameterList = "";
                string collumnList = "";
                string valueList = "";
                string whereList = "";
                string setList = "";
                string deleteParameterList = "";
                string prKeyList = "";
                string selectList = "";
                string selectWhereList = "";
                string orderByList = "";
                int compteur = 0;

                while (sdr.Read())
                {

                    if (sdr[0].ToString() != tableName && tableName != "")
                    {
                        generateCrudSp(tableName, parameterList, collumnList, valueList, whereList, setList, deleteParameterList, prKeyList, selectList, selectWhereList, orderByList);
                        tableName = "";
                        parameterList = "";
                        collumnList = "";
                        valueList = "";
                        whereList = "";
                        setList = "";
                        deleteParameterList = "";
                        prKeyList = "";
                        selectList = "";
                        selectWhereList = "";
                        orderByList = "";
                    }

                    tableName = sdr[0].ToString();

                    //sdr[0] - TableName.
                    //sdr[1] - CollumnName
                    //sdr[2] - collumn type
                    //sdr[3] - length
                    //sdr[4] - IsIdentity (0||1)
                    //Get the primary key
                    List<string> primaryKeyList = getPrimaryKey(sdr[0].ToString());

                    if (selectList != "")
                    {
                        selectList += ",\n\t";
                    }
                    selectList += "\t" + Char.ToLowerInvariant(tableName[0]) + "." + sdr[1].ToString();  //collumnName
                    //-----------------------

                    if (!primaryKeyList.Contains(sdr[1].ToString()) && Convert.ToInt32(sdr[4].ToString()) != 1)
                    {
                        if (collumnList != "")
                        {
                            collumnList += ", ";
                        }
                        collumnList += "" + sdr[1].ToString();  //collumnName
                        //--------------------




                        if (orderByList != "")
                        {
                            orderByList += ",\n\t\t";
                        }
                        orderByList +=  StringHelper.getOrderByItem("" + Char.ToLowerInvariant(tableName[0]), sdr[1].ToString(), compteur);
                        compteur++;
                        //-----------------------


                        if (parameterList != "")
                        {
                            parameterList += ",\n";
                        }
                        parameterList += "\t" + "@" + StringHelper.toLowerFirstCharacter(sdr[1].ToString()) + " " + (sdr[2].ToString()).ToUpper() +
                            ((sdr[3].ToString() != "") ? (" (" + sdr[3].ToString() + ")") : "");

                        //------------------

                        if (selectWhereList != "")
                        {
                            selectWhereList += "\n\tAND";
                        }
                        selectWhereList += " " + StringHelper.getSelectWhereItem(""+Char.ToLowerInvariant(tableName[0]), sdr[1].ToString(), sdr[2].ToString());
                        
                        //--------------------

                        if (valueList != "")
                        {
                            valueList += ", ";
                        }
                        valueList += "" + "@" + StringHelper.toLowerFirstCharacter(sdr[1].ToString());
                        //---------------------
                    }
                    if (!primaryKeyList.Contains(sdr[1].ToString()))
                    {

                        if (setList != "")
                        {
                            setList += ", ";
                        }
                        setList += "" + sdr[1].ToString() + "=" + "@" + StringHelper.toLowerFirstCharacter(sdr[1].ToString());

                    }
                    else
                    {
                        if (whereList != "")
                        {
                            whereList += " AND\n";
                        }
                        else
                        {
                            whereList += "WHERE ";
                        }
                        whereList += sdr[1].ToString() + "=@" + StringHelper.toLowerFirstCharacter(sdr[1].ToString());

                    }
                    if (primaryKeyList.Contains(sdr[1].ToString()))
                    {

                        if (deleteParameterList != "")
                        {
                            deleteParameterList += ",\n";
                        }
                        deleteParameterList += "\t" + "@" + StringHelper.toLowerFirstCharacter(sdr[1].ToString()) + " " + (sdr[2].ToString()).ToUpper() +
                            ((sdr[3].ToString() != "") ? (" (" + sdr[3].ToString() + ")") : "")
                            ;

                        if (prKeyList != "")
                        {
                            prKeyList += " AND\n";
                        }
                        prKeyList += "\t" + sdr[1].ToString() + " = @" + StringHelper.toLowerFirstCharacter(sdr[1].ToString());
                    }

                    for (int i = 0; i < sdr.FieldCount; i++)
                    {
                        
                        Console.Write(sdr[i] + " ");

                        if (primaryKeyList.Contains(sdr[i].ToString()))
                            Console.Write("Primary_Key ");
                    }
                    Console.Write("\n");
                }

                generateCrudSp(tableName, parameterList, collumnList, valueList, whereList, setList, deleteParameterList, prKeyList, selectList, selectWhereList, orderByList);
              
            }
            catch (Exception ex)
            {
                throw ex;
            }
            #region finally
            finally
            {
                // close the reader
                if (sdr != null)
                {
                    sdr.Close();
                }

                // Close the connection
                if (sqlConn != null)
                {
                    sqlConn.Close();
                }
            }
            #endregion

        }

        #endregion

        #region generate SP
        private void generateCrudSp(string tableName, string parameterList, string collumnList, string valueList, string whereList, string setList, string deleteParameterList, string prKeyList, string selectList,string selectWhereList,string orderByList)
        {
            if (String.IsNullOrEmpty(_CrudSpTemplateFile))
                return;
            if (!File.Exists(_CrudSpTemplateFile))
            {
                string message = "The Insert template file is not exists";
                //throw new Exception(message);
                Console.WriteLine(message);
                return;
            }

            Dictionary<string, string> template = new Dictionary<string,string>();

            template.Add("parameterList", parameterList);
            template.Add("columnList", collumnList);
            template.Add("valueList", valueList);
            template.Add("tableName", tableName);
            template.Add("whereList", whereList);
            template.Add("setList", setList);
            template.Add("deleteParameterList", deleteParameterList);
            template.Add("primaryKeyList", prKeyList);
            template.Add("tableAlias", " " + Char.ToLowerInvariant(tableName[0]));
            template.Add("selectList", " " + selectList);
            template.Add("selectWhereList", " " + selectWhereList);
            template.Add("orderByList", " " + orderByList);
            
            try
            {
                string sp = StringHelper.ReplaceString(_CrudSpTemplateFile, template);
                WriteSp(sp, tableName);
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        #endregion

        /// <summary>
        /// Write the generated sp to File
        /// </summary>
        /// <param name="sp"></param>
        /// <param name="fileName"></param>
        private void WriteSp(string sp, string fileName)
        {
            Console.Write("\n\n");
            Console.WriteLine(sp);

            try
            {
                if (!Directory.Exists(_OutputFilesPath))
                {
                    Directory.CreateDirectory(_OutputFilesPath);
                }

                // create a writer and open the file
                TextWriter tw = new StreamWriter(this._OutputFilesPath + @"\" + fileName + ".storedProcedures.sql",false);

                // write a line of text to the file
                tw.WriteLine(sp);

                // close the stream
                tw.Close();
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        /// <summary>
        /// Get the Primary keys from table
        /// </summary>
        /// <param name="tableName"></param>
        /// <returns></returns>
        private List<string> getPrimaryKey(string tableName)
        {
            SqlConnection sqlConn = new SqlConnection(_ConnectionString);
            SqlDataReader sdr = null;
            List<string> resultList = new List<string>();
            try
            {
                sqlConn.Open();

                SqlCommand command = new SqlCommand(QueryHelper.GetPrimaryKeyByTableNameQuery(tableName), sqlConn);
                sdr = command.ExecuteReader();

                while (sdr.Read())
                {
                    resultList.Add(sdr[0].ToString());
                }          
            }
            finally
            {
                if (sdr != null)
                {
                    sdr.Close();
                }

                if (sqlConn != null)
                {
                    sqlConn.Close();
                }
            }
            return resultList;
        }
    }
}
