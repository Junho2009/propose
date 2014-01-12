package ui
{
    
    import flash.display.Bitmap;
    import flash.events.Event;
    import flash.events.MouseEvent;
    
    import commons.buses.InnerEventBus;
    import commons.load.FilePath;
    import commons.load.LoadRequestInfo;
    import commons.manager.ILoadManager;
    import commons.manager.base.ManagerGlobalName;
    import commons.manager.base.ManagerHub;
    
    import webgame.ui.FlowLayoutPanel;
    import webgame.ui.ScrollableView;
    import webgame.ui.Widget;
    
    /**
     * 特别鸣谢窗体
     * @author junho
     * <br/>Create: 2013.01.12
     */    
    public class ThankfulWin extends WindowBase implements IWindow
    {
        private var _loadMgr:ILoadManager;
        
        private var _sview:ScrollableView;
        private var _flowLayoutPanel:FlowLayoutPanel;
        private var _closeBtn:Widget;
        
        
        public function ThankfulWin()
        {
            super("ThankfulWin", 769, 547);
            
            _loadMgr = ManagerHub.getInstance().getManager(ManagerGlobalName.LoadManager) as ILoadManager;
            
            _sview = new ScrollableView("", 649, 393);
            
            _flowLayoutPanel = new FlowLayoutPanel("");
            
            _closeBtn = new Widget("");
        }
        
        override public function init():void
        {
            super.init();
            
            var bgReq:LoadRequestInfo = new LoadRequestInfo();
            bgReq.url = FilePath.thankfulPath + "winbg.png";
            bgReq.completedCallback = function(img:Bitmap):void
            {
                backgroundImage = img;
            };
            _loadMgr.load(bgReq);
            
            _sview.init();
            _sview.x = 60;
            _sview.y = 109;
            addChild(_sview);
            
            _flowLayoutPanel.init();
            _flowLayoutPanel.spaceY = 30;
            _sview.addChild(_flowLayoutPanel);
            
            _closeBtn.init();
            _closeBtn.backgroundImage = CommonRes.getInstance().getBitmap("closeBtn");
            _closeBtn.x = width - _closeBtn.width - 60;
            _closeBtn.y = 85;
            _closeBtn.buttonMode = true;
            addChild(_closeBtn);
        }
        
        override public function set params(value:Object):void
        {
            _flowLayoutPanel.clearChildren();
            
            var dataList:Array = value as Array;
            const dataListLen:uint = dataList.length;
            for (var i:int = 0; i < dataListLen; ++i)
            {
                addThankfulOne(dataList[i]);
            }
        }
        
        
        
        override protected function onWindowOpened(e:Event):void
        {
            _closeBtn.addEventListener(MouseEvent.CLICK, close);
            InnerEventBus.getInstance().addEventListener(ThankfulOne.READY_EVENT, onThankfulOneReady);
        }
        
        override protected function onWindowClosed(e:Event):void
        {
            _closeBtn.removeEventListener(MouseEvent.CLICK, close);
            InnerEventBus.getInstance().removeEventListener(ThankfulOne.READY_EVENT, onThankfulOneReady);
        }
        
        
        
        private function addThankfulOne(data:Object):void
        {
            var one:ThankfulOne = new ThankfulOne();
            one.init();
            one.setContent(data.title, data.content, data.res);
            _flowLayoutPanel.addChild(one);
            _sview.update();
        }
        
        private function onThankfulOneReady(e:Event):void
        {
            _flowLayoutPanel.update();
            _sview.update();
        }
    }
}



import flash.display.Bitmap;
import flash.events.Event;
import flash.text.TextFieldAutoSize;

import commons.buses.InnerEventBus;
import commons.load.FilePath;
import commons.load.LoadRequestInfo;
import commons.manager.ILoadManager;
import commons.manager.base.ManagerGlobalName;
import commons.manager.base.ManagerHub;

import webgame.ui.GixText;
import webgame.ui.View;
import webgame.ui.Widget;


class ThankfulOne extends View
{
    public static const READY_EVENT:String = "ThankfulOne.READY_EVENT";
    
    private var _loadMgr:ILoadManager;
    
    private var _title:GixText;
    private var _img:Widget;
    private var _content:GixText;
    
    
    public function ThankfulOne()
    {
        super("ThankfulOne");
        
        _loadMgr = ManagerHub.getInstance().getManager(ManagerGlobalName.LoadManager) as ILoadManager;
        
        _title = new GixText();
        _content = new GixText();
    }
    
    override public function init():void
    {
        super.init();
        
        _title.init();
        _title.size = 28;
        _title.autoSize = TextFieldAutoSize.LEFT;
        _title.color = 0xffea00;
        addChild(_title);
        
        _content.init();
        _content.size = 16;
        _content.wordWrap = true;
        _content.multiline = true;
        _content.autoSize = TextFieldAutoSize.LEFT;
        _content.width = 600;
        addChild(_content);
    }
    
    public function setContent(title:String, content:String, res:String = null):void
    {
        _title.text = title;
        _content.text = content;
        
        if (null != res && "" != res)
        {
            _img = new Widget("");
            _img.init();
            addChild(_img);
            
            var imgReq:LoadRequestInfo = new LoadRequestInfo();
            imgReq.url = FilePath.thankfulPath + res;
            imgReq.completedCallback = function(img:Bitmap):void
            {
                _img.backgroundImage = img;
                adjustCtrlsPos();
                
                InnerEventBus.getInstance().dispatchEvent(new Event(READY_EVENT));
            };
            _loadMgr.load(imgReq);
        }
        else
        {
            adjustCtrlsPos();
        }
    }
    
    
    
    private function adjustCtrlsPos():void
    {
        var posY:Number = 0;
        var spaceY:Number = 7;
        
        _title.x = 0;
        _title.y = 0;
        posY = _title.y + _title.height + spaceY;
        
        if (null != _img)
        {
            _img.x = 0;
            _img.y = posY;
            posY = _img.y + _img.height + spaceY;
        }
        
        _content.x = 0;
        _content.y = posY;
    }
}