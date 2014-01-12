package notice
{
    import commons.manager.INotifyManager;
    
    import ui.NoticeView;
    
    /**
     * 通知管理器
     * @author junho
     * <br/>Create: 2014.01.11
     */    
    public class NotifyManager implements INotifyManager
    {
        private var _noticeView:NoticeView;
        private var _noticeList:Array;
        
        
        public function NotifyManager()
        {
            _noticeList = new Array;
        }
        
        public function showNotice(content:String, callback:Function = null):void
        {
            _noticeList.push({content: content, callback: callback});
            
            if (null == _noticeView)
            {
                _noticeView = new NoticeView();
                _noticeView.init();
            }
            
            if (1 == _noticeList.length)
                handleShowNotice();
        }
        
        
        
        private function handleShowNotice():void
        {
            if (0 == _noticeList.length)
                return;
            
            var data:Object = _noticeList[0];
            var content:String = data.content;
            var callback:Function = data.callback;
            
            _noticeView.showNotice(content, 3000
                , function():void
                {
                    _noticeList.shift();
                    handleShowNotice();
                });
            
            if (null != callback)
                callback();
        }
    }
}