package sound
{
    import flash.events.Event;
    import flash.media.Sound;
    import flash.media.SoundChannel;
    import flash.net.URLRequest;
    
    import commons.debug.Debug;
    import commons.manager.ISoundManager;
    import commons.manager.ITimerManager;
    import commons.manager.base.ManagerGlobalName;
    import commons.manager.base.ManagerHub;

    /**
     * 声音管理器
     * <br/>（声音可能会分到另一个模块中）
     * @author junho
     * <br/>Create: 2013.12.15
     */    
    public class SoundManager implements ISoundManager
    {
        private var _timer:ITimerManager;
        
        private var _sound:Sound = null;
        private var _channel:SoundChannel = null;
        
        private var _playUrlList:Vector.<String>;
        private var _curPlayingIdx:int = -1;
        private var _delay:uint;
        private var _bLoop:Boolean = false;
        
        
        public function SoundManager()
        {
            _timer = ManagerHub.getInstance().getManager(ManagerGlobalName.TimerManager) as ITimerManager;
            _playUrlList = new Vector.<String>();
        }
        
        public function playList(urlList:Vector.<String>, delay:uint = 0, isLoop:Boolean = false):void
        {
            if (null == urlList || 0 == urlList.length)
                return;
            
            _playUrlList = urlList;
            _delay = delay;
            _bLoop = isLoop;
            
            if (null != _channel)
                _channel.stop();
            
            if (null != _sound)
                _sound.close();
            
            _curPlayingIdx = -1;
            playNextSound();
        }
        
        
        
        private function playNextSound():void
        {
            if (!_bLoop && _curPlayingIdx >= _playUrlList.length)
                return;
            
            if (_curPlayingIdx >= _playUrlList.length - 1)
                _curPlayingIdx = -1;
            
            ++_curPlayingIdx;
            
            try
            {
                _sound = new Sound(new URLRequest(_playUrlList[_curPlayingIdx]));
                _channel = _sound.play();
                _channel.addEventListener(Event.SOUND_COMPLETE, function(e:Event):void
                {
                    _timer.setTask(playNextSound, _delay);
                });
            } 
            catch(error:Error) 
            {
                Debug.log(error.message);
            }
        }
    }
}