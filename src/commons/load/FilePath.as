package commons.load
{
    import commons.GlobalContext;
    import commons.ScreenResolutionLV;

    /**
     * 文件路径定义
     * @author junho
     * <br/>Create: 2013.12.15
     */    
    public final class FilePath
    {
        private static var _root:String = "./";
        
        private static var _flowerPath:String = _root + "flower/";
        
        
        
        public static function redirect(root:String):void
        {
            _root = root;
            _flowerPath = _root + "flower/";
        }
        
        public static function trimRoot(url:String):String
        {
            return url.replace(root, "");
        }
        
        
        
        public static function get root():String
        {
            return _root;
        }
        
        public static function get adapt():String
        {
            const screenResolutionLV:uint = GlobalContext.getInstance().screenResolutionLV;
            switch (screenResolutionLV)
            {
                case ScreenResolutionLV.LOW:
                    return root+"adapt/low/";
                case ScreenResolutionLV.MID:
                    return root+"adapt/mid/";
                case ScreenResolutionLV.HIGH:
                    return root+"adapt/high/";
                
                default:
                    return root+"adapt/low/";
            }
        }
        
        public static function get flowerPath():String
        {
            return _flowerPath;
        }
    }
}