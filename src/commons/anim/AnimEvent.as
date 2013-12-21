package commons.anim
{
    import flash.events.Event;
    
    /**
     * 动画事件
     * @author junho
     * <br/>Create: 2013.12.21
     */    
    public class AnimEvent extends Event
    {
        /**
         * 单次循环播放完成
         */        
        public static const CycleCompleted:String = "AnimEvent.CycleCompleted";
        
        
        public function AnimEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super(type, bubbles, cancelable);
        }
    }
}