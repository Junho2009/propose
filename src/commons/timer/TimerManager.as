package commons.timer
{
    import flash.events.TimerEvent;
    import flash.utils.Dictionary;
    import flash.utils.Timer;
    import commons.manager.ITimerManager;

    /**
     * 定时器管理器
     * @author junho
     * <br/>Create: 2013.12.15
     */    
    public class TimerManager implements ITimerManager
    {
        private var _timerDic:Dictionary = new Dictionary();
        private var _taskDic:Dictionary = new Dictionary();
        private var _tdListDic:Dictionary = new Dictionary();
        private var _delListDic:Dictionary = new Dictionary();
        
        
        public function TimerManager()
        {
        }
        
        public function setTask(task:Function, delay:uint, isLoop:Boolean=false):void
        {
            if (null != _taskDic[task])
                return;
            
            var newTimer:Timer = null;
            
            var tdList:Array = _tdListDic[delay] as Array;
            if (null == tdList)
            {
                newTimer = createTimer(delay);
                _timerDic[delay] = newTimer;
                
                tdList = new Array();
                _tdListDic[delay] = tdList;
            }
            var td:TimerTaskInfo = new TimerTaskInfo(task, delay, isLoop);
            tdList.push(td);
            
            _taskDic[task] = delay;
            
            if (null != newTimer)
                newTimer.start();
        }
        
        public function clearTask(task:Function):void
        {
            if (null == _taskDic[task])
                return;
            
            const delay:uint = uint(_taskDic[task]);
            delete _taskDic[task];
            
            var i:int = 0;
            var td:TimerTaskInfo = null;
            
            var delIdxList:Array = new Array();
            
            var tdList:Array = _tdListDic[delay] as Array;
            const tdListLen:uint = tdList.length;
            for (i = 0; i < tdListLen; ++i)
            {
                td = tdList[i] as TimerTaskInfo;
                if (td.task != task)
                    continue;
                
                if (!td.isRunning)
                    delIdxList.push(i);
                else
                    addToDelList(td);
            }
            
            var idx:int = 0;
            const delIdxListLen:uint = delIdxList.length;
            for (i = delIdxListLen - 1; i >= 0; --i)
            {
                idx = delIdxList[i];
                
                td = tdList[idx] as TimerTaskInfo;
                td.dispose();
                tdList.splice(idx, 1);
            }
            
            if (0 == tdList.length)
                delTimer(delay);
        }
        
        
        
        private function onTimer(e:TimerEvent):void
        {
            var timer:Timer = e.target as Timer;
            const delay:uint = timer.delay;
            
            var i:int = 0;
            var td:TimerTaskInfo = null;
            
            var tdList:Array = _tdListDic[delay] as Array;
            for (i = 0; i < tdList.length; ++i) // tdList.length在循环过程中可能会被改变，例如：在正被调用的taskA中移除了另一个相同频率的taskB，由于taskB没被正在调用，所以移除操作会马上进行，而不是放入删除列表中
            {
                td = tdList[i] as TimerTaskInfo;
                td.isRunning = true;
                td.task();
                td.isRunning = false;
                
                if (!td.isLoop)
                {
                    /*
                    handleDelList()中不负责清理_taskDic中的键值，因为task()执行过程中可能会
                    通过clearTask()、重新setTask()的方式来修改自身的调用频率，如果在handleDelList()中
                    清理了_taskDic中的键值——当次的task()调用完毕后发生，之前调用setTask()时设好的键值
                    就被清理了，导致_taskDic的内容和实际定时器的情况不一致，下一次调用clearTask()就不能
                    按预期的效果那样清掉原来的定时器了。
                    */
                    delete _taskDic[td.task];
                    
                    addToDelList(td);
                }
            }
            
            handleDelList();
        }
        
        private function addToDelList(td:TimerTaskInfo):void
        {
            var delList:Array = _delListDic[td.delay];
            if (null == delList)
            {
                delList = new Array();
                _delListDic[td.delay] = delList;
                delList.push(td);
            }
            else
            {
                // 如果task不是循环执行的、且在task调用过程中会调用TimeManager的clearTask的话
                // ，就可能出现调用两次addToDelList的情况。
                if (-1 == delList.indexOf(td))
                    delList.push(td);
            }
        }
        
        /**
         * 处理删除列表
         * <br/>负责：1、清除在tdList中的引用；2、若tdList变为空，清除定时器
         * <br/>注：本处理函数不会对_taskDic做任何操作
         *
         */
        private function handleDelList():void
        {
            var i:int = 0;
            var td:TimerTaskInfo = null;
            
            for (var key:* in _delListDic)
            {
                const delay:uint = uint(key);
                
                var tdList:Array = _tdListDic[delay] as Array;
                
                var delList:Array = _delListDic[delay] as Array;
                const delListLen:uint = delList.length;
                for (i = 0; i < delListLen; ++i)
                {
                    td = delList[i] as TimerTaskInfo;
                    td.dispose();
                    tdList.splice(tdList.indexOf(td), 1);
                }
                
                if (0 == tdList.length)
                    delTimer(delay);
            }
            
            _delListDic = new Dictionary();
        }
        
        
        
        private function createTimer(delay:uint):Timer
        {
            var timer:Timer = new Timer(delay);
            timer.addEventListener(TimerEvent.TIMER, onTimer);
            return timer;
        }
        
        private function delTimer(delay:uint):void
        {
            var timer:Timer = _timerDic[delay];
            
            if (timer != null)
            {
                timer.stop();
                timer.removeEventListener(TimerEvent.TIMER, onTimer);
            }
            
            delete _timerDic[delay];
            delete _tdListDic[delay];
        }
    }
}