package sound
{
    import flash.media.Sound;
    import flash.media.SoundChannel;
    import flash.net.URLRequest;
    import commons.sound.ISoundManager;

    /**
     * 声音管理器
     * <br/>（声音可能会分到另一个模块中）
     * @author junho
     * <br/>Create: 2013.12.15
     */    
    public class SoundManager implements ISoundManager
    {
        private var _sound:Sound;
        private var _channel:SoundChannel;
        
        
        public function SoundManager()
        {
            _sound = new Sound();
        }
        
        public function play(url:String, isLoop:Boolean):void
        {
            if (null != _channel)
                _channel.stop();
            
            _sound.load(new URLRequest(url));
            _channel = _sound.play();
        }
    }
}