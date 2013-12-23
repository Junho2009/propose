package commons.vo
{
    /**
     * 一条祝福数据
     * @author junho
     * <br/>Create: 2013.12.23
     */    
    public class BlessVO
    {
        private var _authorName:String;
        private var _msg:String;
        private var _time:uint;
        
        
        public function BlessVO(authorName:String, msg:String, time:uint)
        {
            _authorName = authorName;
            _msg = msg;
            _time = time;
        }
        
        public function get authorName():String
        {
            return _authorName;
        }
        
        public function get msg():String
        {
            return _msg;
        }
        
        public function get time():uint
        {
            return _time;
        }
    }
}