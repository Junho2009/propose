package
{
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.external.ExternalInterface;
    import flash.system.Security;
    
    import mx.utils.StringUtil;
    
    import commons.GlobalContext;
    import commons.MySocket;
    import commons.WindowGlobalName;
    import commons.anim.AnimManager;
    import commons.buses.InnerEventBus;
    import commons.buses.NetBus;
    import commons.cache.CacheManager;
    import commons.load.FilePath;
    import commons.load.LoadManager;
    import commons.manager.IWindowManager;
    import commons.manager.base.ManagerGlobalName;
    import commons.manager.base.ManagerHub;
    import commons.module.ModuleManager;
    import commons.timer.TimerManager;
    
    import flowersend.FlowerSendModule;
    
    import login.LoginModule;
    
    import mud.MudModule;
    
    import sound.SoundModule;
    
    import ui.UIModule;
    
    import webgame.core.GlobalContext;

    /**
     * 启动器
     * @author Junho
     * <br/>Create: 2013.07.07
     */
    [SWF(width = "1000", height = "600", frameRate = 30
        , backgroundColor = "0x666666")]
    public class Launcher extends Sprite
    {
        private var _context:commons.GlobalContext = commons.GlobalContext.getInstance();
        private var _socket:MySocket;
        private var _moduleMgr:ModuleManager;


        public function Launcher()
        {
            initConfig();
            addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        }
        
        
        
        private function initConfig():void
        {
            var hasExternalCfg:Boolean = false;
            
            if (ExternalInterface.available)
            {
                var cfgInfo:Object = ExternalInterface.call("config");
                if (null != cfgInfo)
                {
                    FilePath.redirect(cfgInfo.root_path);
                    _context.config.serverAddr = cfgInfo.ip;
                    _context.config.serverPort = cfgInfo.port;
                    
                    hasExternalCfg = true;
                }
            }
            
            if (!hasExternalCfg)
            {
                FilePath.redirect("./res/");
                _context.config.serverAddr = "127.0.0.1";
                _context.config.serverPort = 8360;
            }
        }

        private function onAddedToStage(e:Event):void
        {
            initLauncher();
        }
        
        private function initLauncher():void
        {
            initExternalModules();
            initCommonMgrs();
            initSocket();
            initBuses();
        }
        
        private function initExternalModules():void
        {
            commons.GlobalContext.init(this);
        }
        
        private function initCommonMgrs():void
        {
            _moduleMgr = new ModuleManager();
            ManagerHub.getInstance().register(ManagerGlobalName.ModuleManager, _moduleMgr);
            
            _moduleMgr.addModule(new MudModule());
            
            var timerMgr:TimerManager = new TimerManager();
            ManagerHub.getInstance().register(ManagerGlobalName.TimerManager, timerMgr);
            
            var cacheMgr:CacheManager = new CacheManager();
            ManagerHub.getInstance().register(ManagerGlobalName.CacheManager, cacheMgr);
            
            var loadMgr:LoadManager = new LoadManager();
            ManagerHub.getInstance().register(ManagerGlobalName.LoadManager, loadMgr);
            
            var animMgr:AnimManager = new AnimManager();
            ManagerHub.getInstance().register(ManagerGlobalName.AnimManager, animMgr);
        }
        
        private function initSocket():void
        {
            Security.loadPolicyFile(StringUtil.substitute("xmlsocket://{0}:2525", _context.config.serverAddr));
            
            _socket = MySocket.getInstance();
            _socket.addEventListener(Event.CONNECT, onConnect);
            _socket.addEventListener(Event.CLOSE, onClose);
            _socket.addEventListener(IOErrorEvent.IO_ERROR, onSocketIOError);
            _socket.connect(_context.config.serverAddr, _context.config.serverPort);
        }
        
        private function initBuses():void
        {
            InnerEventBus.getInstance();
            NetBus.getInstance();
        }
        
        private function onConnect(e:Event):void
        {
            trace("socket连接成功");
            
            launcherSupportsLib();
            initModules();
            
            var winMgr:IWindowManager = ManagerHub.getInstance().getManager(ManagerGlobalName.WindowManager) as IWindowManager;
            winMgr.open(WindowGlobalName.LOGIN_WIN);
            
            // testing
//            var soundMgr:ISoundManager = ManagerHub.getInstance().getManager(ManagerGlobalName.SoundManager) as ISoundManager;
//            soundMgr.play(FilePath.root+"music/1.mp3", true);
        }
        
        private function launcherSupportsLib():void
        {
            webgame.core.GlobalContext.init(this);
        }
        
        private function initModules():void
        {
            _moduleMgr.addModule(new UIModule());
            _moduleMgr.addModule(new LoginModule());
            _moduleMgr.addModule(new SoundModule());
            _moduleMgr.addModule(new FlowerSendModule());
        }
        
        private function onClose(e:Event):void
        {
            trace("socket已关闭");
        }
        
        private function onSocketIOError(e:IOErrorEvent):void
        {
            trace("socket发生IO错误");
        }
    }
}