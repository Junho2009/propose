package commons.manager
{
    import commons.manager.base.IManager;

    /**
     * 定时器管理器
     * @author junho
     * <br/>Create: 2013.12.15
     */    
    public interface ITimerManager extends IManager
    {
        function setTask(task:Function, delay:uint, isLoop:Boolean = false):void;
        
        function clearTask(task:Function):void;
    }
}