package ui
{
    import commons.WindowGlobalName;
    import commons.manager.base.ManagerGlobalName;
    import commons.manager.base.ManagerHub;
    import commons.module.IModule;
    
    public class UIModule implements IModule
    {
        private var _winMgr:WindowManager;
        
        
        public function UIModule()
        {
            _winMgr = new WindowManager();
            ManagerHub.getInstance().register(ManagerGlobalName.WindowManager
                , _winMgr);
            
            registerWindows();
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
        }
    }
}