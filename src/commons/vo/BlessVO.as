package commons.vo
{
    /**
     * 一条祝福数据
     * @author junho
     * <br/>Create: 2013.12.23
     */    
    public class BlessVO
    {
        private var _rawData:Object = null;
        
        
        public function BlessVO(rawData:Object)
        {
            _rawData = rawData;
        }
        
        public function get authorName():String
        {
            if (null != _rawData && _rawData.hasOwnProperty("author_name"))
                return _rawData["author_name"];
            else
                return "";
        }
        
        public function get msg():String
        {
            if (null != _rawData && _rawData.hasOwnProperty("msg"))
                return _rawData["msg"];
            else
                return "";
        }
        
        public function get time():uint
        {
            if (null != _rawData && _rawData.hasOwnProperty("time"))
                return _rawData["time"];
            else
                return 0;
        }
    }
}