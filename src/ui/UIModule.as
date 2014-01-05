package ui
{
    import commons.WindowGlobalName;
    import commons.buses.NetBus;
    import commons.manager.base.ManagerGlobalName;
    import commons.manager.base.ManagerHub;
    import commons.module.IModule;
    import commons.protos.ProtoInList;
    
    import mud.protos.MsgProtoIn_Nofify;
    
    public class UIModule implements IModule
    {
        private var _winMgr:WindowManager;
        
        
        public function UIModule()
        {
            _winMgr = new WindowManager();
            ManagerHub.getInstance().register(ManagerGlobalName.WindowManager
                , _winMgr);
            
            registerWindows();
            
            ProtoInList.getInstance().bind(MsgProtoIn_Nofify.HEAD, MsgProtoIn_Nofify);
            NetBus.getInstance().addCallback(MsgProtoIn_Nofify.HEAD, onNofity);
        }
        
        public function get name():String
        {
            return "UIModule";
        }
        
        private function registerWindows():void
        {
            _winMgr.register(WindowGlobalName.MSG_BOX, MessageBox);
            _winMgr.register(WindowGlobalName.BLESS_SEND, BlessSendWin);
            _winMgr.register(WindowGlobalName.HOME_PAGE, HomePageWin);
            _winMgr.register(WindowGlobalName.LOGIN_WIN, LoginWin);
        }
        
        private function onNofity(inc:MsgProtoIn_Nofify):void
        {
            _winMgr.open(WindowGlobalName.MSG_BOX, null, inc.msg);
        }
    }
}