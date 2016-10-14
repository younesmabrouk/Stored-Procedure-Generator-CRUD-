using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;

namespace StoredProcedureGenerator
{
    /// <summary>
    /// 
    /// </summary>
    public static class StringHelper
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="templateFile"></param>
        /// <param name="replaceInTemplate"></param>
        /// <returns></returns>
        public static string ReplaceString(string templateFile, Dictionary<string, string> replaceInTemplate)
        {
            string newFileContent = "";

            if (!File.Exists(templateFile))
            {
                throw new Exception("Nem letezo file");
            }
            StreamReader sr = File.OpenText(templateFile);

            string oldFileContent = sr.ReadToEnd();
            newFileContent = oldFileContent;

            foreach (KeyValuePair<string, string> kvp in replaceInTemplate)
            {
                newFileContent = newFileContent.Replace("<%" + kvp.Key + "%>", kvp.Value);
            }

            return newFileContent;

        }

        public static string toLowerFirstCharacter(string word)
        {
            return Char.ToLowerInvariant(word[0]) + word.Substring(1);
        }

        public static string getSelectWhereItem(string tableAlias, string field, string type)
        {
            string result = "";
            if (type.Equals("int"))
            {
                result = "(" + tableAlias + "." + field + "=@" + toLowerFirstCharacter(field) + " OR @" + toLowerFirstCharacter(field) + " IS NULL)";
            }
            else
            {
                result = "(COALESCE(" + tableAlias + "." + field + ",'') LIKE '%' + COALESCE(@" + toLowerFirstCharacter(field) +", COALESCE(" + tableAlias + "." + field + ",'')) + '%')";
            }
            return result;
        }


        public static string getOrderByItem(string tableAlias, string field, int order)
        {
            order = order - 2;
            string result = "";
            result += "CASE WHEN @iSortCol = " + order + " AND @sSortDir='asc' THEN " + tableAlias + "." + field + " END asc,\n\t\t";
            result += "CASE WHEN @iSortCol = " + order + " AND @sSortDir='desc' THEN " + tableAlias + "." + field + " END desc";
            return result;
        }

    }
}
