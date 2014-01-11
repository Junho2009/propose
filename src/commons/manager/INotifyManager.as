package commons.manager
{
    import commons.manager.base.IManager;
    
    /**
     * 通知管理器
     * @author junho
     * <br/>Create: 2014.01.11
     */    
    public interface INotifyManager extends IManager
    {
        /**
         * 显示一条公告
         * <br/>如果当前有正在显示的公告，则等待这些公告都显示完毕后，再显示本公告
         * @param content:String 公告内容
         * @param callback:Function 当本公告内容真正显示时回调此函数
         * 
         */        
        function showNotice(content:String, callback:Function = null):void;
    }
}