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
        private static const _ProtoDelimiter:String = "\n";
        /**
         * 协议之间的分隔符的编码字符串
         */        
        private static const _ProtoDelimiterEncode:String = "@=n@";
        /**
         * 匹配“协议之间的分隔符”的正则表达式
         */        
        private static const _ProtoDelimiterRegExp:RegExp = new RegExp(_ProtoDelimiter, "g");
        /**
         * 匹配“协议之间的分隔符的编码字符串”的正则表达式
         */        
        private static const _ProtoDelimiterEncodeRegExp:RegExp = new RegExp(_ProtoDelimiterEncode, "g");
        
        
        
        /**
         * 协议中各段数据之间的分隔符
         */
        private static const _ParamDelimiter:String = ";";
        /**
         * 协议中各段数据之间的分隔符的编码字符串
         */        
        private static const _ParamDelimiterEncode:String = "@=s@";
        /**
         * 匹配“协议中各段数据之间的分隔符”的正则表达式
         */        
        private static const _ParamDelimiterRegExp:RegExp = new RegExp(_ParamDelimiter, "g");
        /**
         * 匹配“协议中各段数据之间的分隔符的编码字符串”的正则表达式
         */        
        private static const _ParamDelimiterEncodeRegExp:RegExp = new RegExp(_ParamDelimiterEncode, "g");
        
        
        
        /**
         * 协议中数组元素分隔符
         */
        private static const _ArrayElementDelimiter:String = "#";
        /**
         * 协议中数组元素分隔符的编码字符串
         */        
        private static const _ArrayElementDelimiterEncode:String = "@=p@";
        /**
         * 匹配“协议中数组元素分隔符”的正则表达式
         */        
        private static const _ArrayElementDelimiterRegExp:RegExp = new RegExp(_ArrayElementDelimiter, "g");
        /**
         * 匹配“协议中数组元素分隔符的编码字符串”的正则表达式
         */        
        private static const _ArrayElementDelimiterEncodeRegExp:RegExp = new RegExp(_ArrayElementDelimiterEncode, "g");
        
        
        
        /**
         * 数组元素中各属性之间的分隔符
         */
        public static const _ElementPropDelimiter:String = ",";
        /**
         * 数组元素中各属性之间的分隔符的编码字符串
         */        
        public static const _ElementPropDelimiterEncode:String = "@=d@";
        /**
         * 匹配“数组元素中各属性之间的分隔符”的正则表达式
         */        
        private static const _ElementPropDelimiterRegExp:RegExp = new RegExp(_ElementPropDelimiter, "g");
        /**
         * 匹配“数组元素中各属性之间的分隔符的编码字符串”的正则表达式
         */        
        private static const _ElementPropDelimiterEncodeRegExp:RegExp = new RegExp(_ElementPropDelimiterEncode, "g");
        
        
        /**
         * 数组元素属性的键/值之间的分隔符
         */        
        private static const _ElementPropKVDelimiter:String = ":";
        /**
         * 数组元素属性的键/值之间的分隔符的编码字符串
         */        
        private static const _ElementPropKVDelimiterEncode:String = "@=c@";
        /**
         * 匹配“数组元素属性的键/值之间的分隔符”的正则表达式
         */        
        private static const _ElementPropKVDelimiterRegExp:RegExp = new RegExp(_ElementPropKVDelimiter, "g");
        /**
         * 匹配“数组元素属性的键/值之间的分隔符的编码字符串”的正则表达式
         */        
        private static const _ElementPropKVDelimiterEncodeRegExp:RegExp = new RegExp(_ElementPropKVDelimiterEncode, "g");
        
        
        
        
        
        /**
         * 将输出内容编码为适合发送的格式
         * @param orgStr:String
         * @return String
         * 
         */        
        public static function toEncode_ProtoOutStr(orgStr:String):String
        {
            var res:String = "";
            
            res = orgStr.replace(_ProtoDelimiterRegExp, _ProtoDelimiterEncode); // 编码了协议分隔符
            res = res.replace(_ParamDelimiterRegExp, _ParamDelimiterEncode); // 编码了字段分隔符
            res = res.replace(_ArrayElementDelimiterRegExp, _ArrayElementDelimiterEncode); // 编码了数组元素分隔符
            res = res.replace(_ElementPropDelimiterRegExp, _ElementPropDelimiterEncode); // 编码了数组元素属性分隔符
            res = res.replace(_ElementPropKVDelimiterRegExp, _ElementPropKVDelimiterEncode); // 编码了数组元素属性键值分隔符
            
            return res;
        }
        
        /**
         * 将数据列表转换为服务端的数据字段描述串
         * @param paramList:Array
         * @return String
         * 
         */        
        public static function toEncode_ProtoParamsStr(paramList:Array):String
        {
            var res:String = "";
            
            if (null == paramList || 0 == paramList.length)
                return res;
            
            const paramListLen:uint = paramList.length;
            for (var i:int = 0; i < paramListLen; ++i)
            {
                if (0 != i)
                    res += _ParamDelimiter;
                
                var obj:Object = paramList[i];
                res += toEncode_ProtoOutStr(String(obj)); // 目前并不支持嵌套的数据结构，客户端发给服务端的数据统一是简单类型的
            }
            
            return res;
        }
        
        
        
        
        
        /**
         * 将原生字符串转换为输入协议（字符串）列表
         * @param rawStr:String
         * @return Array
         * 
         */        
        public static function toDecode_ProtoInStrList(rawStr:String):Array
        {
            var protoInStrList:Array = rawStr.split(_ProtoDelimiter);
            
            const protoInStrListLen:uint = protoInStrList.length;
            for (var i:int = 0; i < protoInStrListLen; ++i)
            {
                protoInStrList[i] = String(protoInStrList[i]).replace(_ProtoDelimiterEncodeRegExp, _ProtoDelimiter);
            }
            
            return protoInStrList;
        }
        
        /**
         * 将输入协议（字符串）转换为字段（字符串）列表
         * @param protoInStr:String
         * @return Array
         * 
         */        
        public static function toDecode_ProtoParamStrList(protoInStr:String):Array
        {
            var paramStrList:Array = protoInStr.split(_ParamDelimiter);
            
            const paramStrListLen:uint = paramStrList.length;
            for (var i:int = 0; i < paramStrListLen; ++i)
            {
                paramStrList[i] = String(paramStrList[i]).replace(_ParamDelimiterEncodeRegExp, _ParamDelimiter);
            }
            
            return paramStrList;
        }
        
        /**
         * 将数组描述串转换为数组对象
         * @param arrayStr:String
         * @return Array
         * 
         */        
        public static function toDecode_Array(arrayStr:String):Array
        {
            var array:Array = new Array();
            
            var elementStrList:Array = arrayStr.split(_ArrayElementDelimiter);
            const elementStrListLen:uint = elementStrList.length;
            for (var i:int = 0; i < elementStrListLen; ++i)
            {
                elementStrList[i] = String(elementStrList[i]).replace(_ArrayElementDelimiterEncodeRegExp, _ArrayElementDelimiter);
                var element:Object = toDecode_Element(String(elementStrList[i]));
                array.push(element);
            }
            
            return array;
        }
        
        /**
         * 将数组元素描述串转换为元素对象
         * @param elementStr:String
         * @return Object
         * 
         */        
        private static function toDecode_Element(elementStr:String):Object
        {
            var obj:Object = new Object();
            
            var propList:Array = elementStr.split(_ElementPropDelimiter);
            const propListLen:uint = propList.length;
            for (var i:int = 0; i < propListLen; ++i)
            {
                propList[i] = String(propList[i]).replace(_ElementPropDelimiterEncodeRegExp, _ElementPropDelimiter);
                
                var propKVList:Array = String(propList[i]).split(_ElementPropKVDelimiter);
                var propKey:String = String(propKVList[0]).replace(_ElementPropKVDelimiterEncodeRegExp, _ElementPropKVDelimiter);
                var propValue:String = String(propKVList[1]).replace(_ElementPropKVDelimiterEncodeRegExp, _ElementPropKVDelimiter);
                obj[propKey] = propValue;
            }
            
            return obj;
        }
    }
}