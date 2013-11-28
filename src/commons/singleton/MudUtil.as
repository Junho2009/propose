package commons.singleton
{
    /**
     * 与文字mud相关的工具类
     * @author Junho
     * <br/>Create: 2013.11.28
     */    
    public class MudUtil
    {
        public static function client2MudStr(clientStr:String):String
        {
            return clientStr.replace(/\n/g, "%=n%");
        }
        
        public static function mud2ClientStr(mudStr:String):String
        {
            return mudStr.replace(/%=n%/ig, "\n");
        }
    }
}