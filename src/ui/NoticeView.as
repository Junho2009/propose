package ui
{
    import flash.filters.GlowFilter;
    import flash.text.TextFormatAlign;
    
    import caurina.transitions.Tweener;
    
    import commons.GlobalContext;
    import commons.GlobalLayers;
    import commons.manager.ITimerManager;
    import commons.manager.base.ManagerGlobalName;
    import commons.manager.base.ManagerHub;
    
    import webgame.ui.GixText;
    import webgame.ui.View;
    
    /**
     * 公告
     * @author junho
     * <br/>Create: 2014.01.11
     */    
    public class NoticeView extends View
    {
        private var _timerMgr:ITimerManager;
        private var _notice:GixText;
        private var _content:String;
        private var _duration:uint = 0;
        private var _callback:Function = null;
        
        
        public function NoticeView()
        {
            super("NoticeView");
            
            _timerMgr = ManagerHub.getInstance().getManager(ManagerGlobalName.TimerManager) as ITimerManager;
            _notice = new GixText();
        }
        
        override public function init():void
        {
            super.init();
            
            _notice.init();
            _notice.size = 26;
            _notice.bold = true;
            _notice.filters = [new GlowFilter(0xffff00, 1.0, 6.0, 6.0, 8)];
            _notice.color = 0xff0000;
            _notice.align = TextFormatAlign.CENTER;
            _notice.width = 1000;
            _notice.height = 40;
            addChild(_notice);
            
            GlobalLayers.getInstance().msgLayer.addChild(this);
        }
        
        public function showNotice(content:String, duration:uint, callback:Function = null):void
        {
            _content = content;
            _duration = duration;
            _callback = callback;
            
            beginFadeIn();
        }
        
        
        
        private function beginFadeIn():void
        {
            alpha = 0;
            _notice.text = _content;
            
            x = GlobalContext.getInstance().stage.stageWidth - realityWidth >> 1;
            y = (GlobalContext.getInstance().stage.stageHeight - realityHeight >> 1) + realityHeight*2;
            
            var fadeInParams:Object = new Object();
            fadeInParams.alpha = 1;
            fadeInParams.time = 0.5;
            fadeInParams.y = GlobalContext.getInstance().stage.stageHeight - realityHeight >> 1;
            fadeInParams.transition = "linear";
            fadeInParams.onComplete = onFadeInCompleted;
            
            Tweener.removeTweens(this);
            Tweener.addTween(this, fadeInParams);
        }
        
        private function onFadeInCompleted():void
        {
            _timerMgr.setTask(beginFadeOut, _duration);
        }
        
        private function beginFadeOut():void
        {
            var fadeOutParams:Object = new Object();
            fadeOutParams.alpha = 0;
            fadeOutParams.time = 0.5;
            fadeOutParams.y = (GlobalContext.getInstance().stage.stageHeight - realityHeight >> 1) - realityHeight*2;
            fadeOutParams.transition = "linear";
            fadeOutParams.onComplete = _callback;
            
            Tweener.removeTweens(this);
            Tweener.addTween(this, fadeOutParams);
        }
    }
}