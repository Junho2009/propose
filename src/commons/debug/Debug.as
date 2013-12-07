package commons.debug
{
    import mx.utils.StringUtil;
    
    import commons.GlobalContext;

    public final class Debug
    {
        public static function log(str:String, ...args):void
        {
            if (GlobalContext.getInstance().isRecordLog)
            {
                //...
            }
            else
            {
                trace(StringUtil.substitute(str, args));
            }
        }
    }
}