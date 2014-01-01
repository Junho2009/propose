package ui
{
    import flash.events.Event;
    
    /**
     * 祝福相关事件
     * @author junho
     * <br/>Create: 2014.01.01
     */    
    public class BlessEvent extends Event
    {
        /**
         * 请求把当前自己的祝福放上祝福墙
         */        
        public static const ReqAddSelfBlessToWall:String = "ReqAddSelfBlessToWall";
        
        /**
         * 将当前自己的祝福放入祝福墙
         */        
        public static const AddSelfBlessToWall:String = "AddSelfBlessToWall";
        
        
        
        private var _param:Object = null;
        
        
        public function BlessEvent(type:String, param:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super(type, bubbles, cancelable);
            _param = param;
        }
        
        public function get param():Object
        {
            return _param;
        }
    }
}