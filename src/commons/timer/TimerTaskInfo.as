package commons.timer
{
    /**
     * 定时器任务信息
     * @author junho
     * <br/>Create: 2013.12.15
     */    
    internal class TimerTaskInfo
    {
        private var _task:Function = null;
        private var _delay:uint = 0;
        private var _bLoop:Boolean = false;
        
        /**
         * 是否处于运行状态
         */
        public var isRunning:Boolean = false;
        
        /**
         * 是否处于可回收（清除）状态
         */
        public var recyclable:Boolean = false;
        
        
        public function TimerTaskInfo(task:Function, delay:uint, isLoop:Boolean)
        {
            _task = task;
            _delay = delay;
            _bLoop = isLoop;
        }
        
        public function dispose():void
        {
            _task = null;
        }
        
        public function get task():Function
        {
            return _task;
        }
        
        public function get delay():uint
        {
            return _delay;
        }
        
        public function get isLoop():Boolean
        {
            return _bLoop;
        }
    }
}