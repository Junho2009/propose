package flowersend
{
    import flash.events.Event;
    
    /**
     * 鲜花赠送相关事件
     * @author junho
     * <br/>Create: 2014.01.05
     */    
    public class FlowerSendEvent extends Event
    {
        public static const ShowFlowerSendInfoView:String = "FlowerSendEvent.ShowFlowerSendInfoView";
        
        public static const SentInfoUpdated:String = "FlowerSendEvent.SentInfoUpdated";
        
        
        public function FlowerSendEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super(type, bubbles, cancelable);
        }
    }
}