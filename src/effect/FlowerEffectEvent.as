package effect
{
    import flash.events.Event;
    
    /**
     * 鲜花特效相关事件
     * @author junho
     * <br/>Create: 2013.12.21
     */    
    public class FlowerEffectEvent extends Event
    {
        public static const FlowerClicked:String = "FlowerEffectEvent.FlowerClicked";
        
        public static const FlowerTouchDown:String = "FlowerEffectEvent.FlowerTouchDown";
        
        
        private var _data:Object;
        
        
        public function FlowerEffectEvent(type:String, data:Object, bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super(type, bubbles, cancelable);
            _data = data;
        }
        
        public function get data():Object
        {
            return _data;
        }
    }
}