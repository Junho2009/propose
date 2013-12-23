package mud
{
    /**
     * 与文字mud相关的工具类
     * @author Junho
     * <br/>Create: 2013.11.28
     */    
    public class MudUtil
    {
        /**
         * 协议之间的分隔符
         */        
        public static const ProtoDelimiter:String = "\n";
        
        /**
         * 协议中各段数据之间的分隔符
         */
        public static const DataDelimiter:String = "|";
        
        /**
         * 协议中数组元素分隔符
         */
        public static const ArrayElementDelimiter:String = "$";
        
        /**
         * 协议中各段数据之间的分隔符
         */
        public static const ElementPropDelimiter:String = "^";
        
        
        
        /**
         * 将换行符编码为指定的特殊字符串
         * @param str:String
         * @return String
         * 
         */        
        public static function encodeLineBreaks(str:String):String
        {
            return str.replace(/\n/g, "@=n@");
        }
        
        /**
         * 将指定的特殊字符串转换为换行符
         * @param str:String
         * @return String
         * 
         */
        public static function decodeLineBreaks(str:String):String
        {
            return str.replace(/@=n@/ig, "\n");
        }
        
        /**
         * 将数据分隔符转换为指定的特殊字符串
         * @param str:String
         * @return String
         * 
         */        
        public static function encodeParamDelimiter(str:String):String
        {
            return str.replace(/\|/g, "@=D@");
        }
        
        /**
         * 将指定的特殊字符串转换为数据分隔符
         * @param str:String
         * @return String
         * 
         */        
        public static function decodeParamDelimiter(str:String):String
        {
            return str.replace(/@=D@/ig, "|");
        }
        
        /**
         * 将数组元素分隔符转换为指定的特殊字符串
         * @param str:String
         * @return String
         * 
         */        
        public static function encodeArrayElementDelimiter(str:String):String
        {
            return str.replace(/\$/g, "@=a@");
        }
        
        /**
         * 将指定的特殊字符串转换为数组元素分隔符
         * @param str:String
         * @return String
         * 
         */        
        public static function decodeArrayElementDelimiter(str:String):String
        {
            return str.replace(/@=a@/ig, "$");
        }
        
        /**
         * 将数组元素属性分隔符转换为指定的特殊字符串
         * @param str:String
         * @return String
         * 
         */        
        public static function encodeElementPropDelimiter(str:String):String
        {
            return str.replace(/\^/g, "@=,@");
        }
        
        /**
         * 将指定的特殊字符串转换为数组元素分隔符
         * @param str:String
         * @return String
         * 
         */        
        public static function decodeElementPropDelimiter(str:String):String
        {
            return str.replace(/@=,@/ig, "^");
        }
    }
}