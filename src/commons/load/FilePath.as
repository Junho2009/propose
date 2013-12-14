package commons.load
{
    /**
     * 文件路径定义
     * @author junho
     * <br/>Create: 2013.12.15
     */    
    public final class FilePath
    {
        private static var _root:String = "./";
        
        
        public static function get root():String
        {
            return _root;
        }
        
        public static function redirect(root:String):void
        {
            _root = root;
        }
        
        public static function trimRoot(url:String):String
        {
            return url.replace(root, "");
        }
    }
}