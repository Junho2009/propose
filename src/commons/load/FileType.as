package commons.load
{
    /**
     * 文件类型
     * @author junho
     * <br/>Create: 2013.12.14
     */    
    public final class FileType
    {
        /**
         * 获取url中的文件类型
         * @param url:String
         * @return String
         * 
         */        
        public static function getFileType(url:String):String
        {
            var idx:int = url.lastIndexOf(".");
            if (idx >= 0)
                return url.substr(idx+1).toLowerCase();
            else
                return UNDEF;
        }
        
        
        /**
         * 未定义的文件类型
         */        
        public static const UNDEF:String = "undefined";
        
        /**
         * PNG
         */        
        public static const PNG:String = "png";
        
        /**
         * JPG
         */        
        public static const JPG:String = "jpg";
        
        /**
         * SWF
         */        
        public static const SWF:String = "swf";
    }
}