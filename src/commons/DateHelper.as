package commons
{
    /**
     * 时间显示助手
     * @author junho
     * <br/>Create: 2013.12.25
     */    
    public final class DateHelper
    {
        public static const ShowYear:uint = 1;
        public static const ShowMonth:uint = 1 << 1;
        public static const ShowDay:uint = 1 << 2;
        public static const ShowHour:uint = 1 << 3;
        public static const ShowMinute:uint = 1 << 4;
        public static const ShowSecond:uint = 1 << 5;
        
        
        
        /**
         * 将毫秒数转换为表示日期和时间的字符串（无文字）。格式：1970-01-31 00:59:03
         * @param millSec:Number 基于自 GMT 时间 1970 年 1 月 1 日 0:00:000 以来的毫秒数
         * @param showFormat:uint 显示格式，默认显示完整的年月日时分秒，也可以指定只显示其中哪些部分（参见ShowXXX静态成员变量）。
         * @param dateDelim:String 日期字符串的分隔符，默认是“-”
         * @return String
         *
         */
        public static function toDateAndTimeNumStr(millSec:Number
            , showFormat:uint = 0, dateDelim:String = "-"):String
        {
            var dateStr:String = toDateNumStr_YYYY_MM_DD(millSec, showFormat, dateDelim);
            
            var date:Date = new Date(millSec);
            
            var hourStr:String = toTimeNumStr(date.getHours()).substr(-2, 2);
            var minuteStr:String = toTimeNumStr(date.getMinutes()).substr(-2
                , 2);
            var secStr:String = toTimeNumStr(date.getSeconds()).substr(-2, 2);
            
            const showHour:Boolean = (0 != (showFormat & ShowHour));
            const showMinute:Boolean = (0 != (showFormat & ShowMinute));
            const showSecond:Boolean = (0 != (showFormat & ShowSecond));
            
            var res:String = dateStr;
            if ("" != res)
                res += " ";
            
            if (0 == showFormat || showHour)
                res += hourStr;
            if (0 == showFormat || showMinute)
                res += ("" == res ? minuteStr : (":" + minuteStr));
            if (0 == showFormat || showSecond)
                res += ("" == res ? secStr : (":" + secStr));
            
            return res;
        }
        
        /**
         * 将毫秒数转换为表示日期的字符串（无文字）。格式：1970-01-31
         * @param millSec:Number 基于自 GMT 时间 1970 年 1 月 1 日 0:00:000 以来的毫秒数
         * @param showFormat:uint 显示格式，默认显示完整的年月日，也可以指定只显示其中哪些部分（参见ShowXXX静态成员变量）。
         * @param dateDelim:String 日期字符串的分隔符，默认是“-”
         * @return String
         *
         */
        public static function toDateNumStr_YYYY_MM_DD(millSec:Number
            , showFormat:uint = 0, dateDelim:String = "-"):String
        {
            var date:Date = new Date(millSec);
            
            const showYear:Boolean = (0 != (showFormat & ShowYear));
            const showMonth:Boolean = (0 != (showFormat & ShowMonth));
            const showDay:Boolean = (0 != (showFormat & ShowDay));
            
//            if (0 != showFormat && !(showYear || showMonth || showDay))
//                throw new IllegalOperationError("无效的显示格式");
            
            const year:uint = date.getFullYear();
            const month:uint = date.getMonth() + 1;
            const day:uint = date.getDate();
            
            var res:String = "";
            
            if (0 == showFormat || showYear)
                res += toTimeNumStr(year);
            if (0 == showFormat || showMonth)
                res += ("" == res ? toTimeNumStr(month) : (dateDelim + toTimeNumStr(month)));
            if (0 == showFormat || showDay)
                res += ("" == res ? toTimeNumStr(day) : (dateDelim + toTimeNumStr(day)));
            
            return res;
        }
        
        /**
         * 将数字转换为表示时间的字符串。例如 1:1 转换为 01:01
         * @param num:uint 数字
         * @return String
         *
         */
        public static function toTimeNumStr(num:uint):String
        {
            return (num < 10 ? "0" + num.toString() : num.toString());
        }
    }
}