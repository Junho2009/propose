package ui
{
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Rectangle;
    import flash.text.TextFormatAlign;
    
    import mx.utils.StringUtil;
    
    import commons.DateHelper;
    import commons.GlobalContext;
    import commons.vo.BlessVO;
    
    import webgame.ui.GixText;
    import webgame.ui.View;
    
    /**
     * 祝福纸
     * @author junho
     * <br/>Create: 2013.12.25
     */    
    internal class BlessPaper extends View
    {
        private var _content:GixText;
        private var _authorName:GixText;
        private var _time:GixText;
        
        private var _paperType:uint = 0;
        private var _blessVO:BlessVO = null;
        
        private var _bDragging:Boolean = false;
        
        
        public function BlessPaper()
        {
            super("BlessPaper");
            
            _content = new GixText();
            _content.init();
            _content.color = 0x000000;
            _content.leading = 7;
            _content.multiline = true;
            _content.wordWrap = true;
            _content.selectable = true;
            addChild(_content);
            
            _authorName = new GixText();
            _authorName.init();
            _authorName.color = 0x000000;
            _authorName.align = TextFormatAlign.RIGHT;
            addChild(_authorName);
            
            _time = new GixText();
            _time.init();
            _time.color = 0x000000;
            _time.align = TextFormatAlign.RIGHT;
            addChild(_time);
            
            mouseChildren = false;
            
            addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
            addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
        }
        
        public function set paperType(value:uint):void
        {
            _paperType = value;
            backgroundImage = CommonRes.getInstance().getBitmap(StringUtil.substitute("blessPaper{0}", _paperType));
            updateContent();
        }
        
        public function set content(blessVO:BlessVO):void
        {
            _blessVO = blessVO;
            
            _content.text = _blessVO.msg;
            _authorName.text = _blessVO.authorName;
            _time.text = DateHelper.toDateAndTimeNumStr(_blessVO.time*1000
                , DateHelper.ShowYear | DateHelper.ShowMonth | DateHelper.ShowDay | DateHelper.ShowHour | DateHelper.ShowMinute);
        }
        
        
        
        private function onAddedToStage(e:Event):void
        {
            addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
        }
        
        private function onRemovedFromStage(e:Event):void
        {
            removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
        }
        
        private function updateContent():void
        {
            _content.x = 15;
            _content.y = 50;
            _content.width = width - _content.x*2;
            _content.height = 80;
            
            _authorName.x = 20;
            _authorName.y = _content.y + _content.height;
            _authorName.width = width - _authorName.x*2;
            _authorName.height = 22;
            
            _time.x = 30;
            _time.y = _authorName.y + _authorName.height;
            _time.width = width - _time.x*2;
            _time.height = 22;
        }
        
        private function onMouseDown(e:MouseEvent):void
        {
            if (_bDragging)
                return;
            
            commons.GlobalContext.getInstance().stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
            startDrag(false, new Rectangle(0, 0, parent.width - width, parent.height - height));
            _bDragging = true;
        }
        
        private function onMouseUp(e:MouseEvent):void
        {
            if (!_bDragging)
                return;
            
            commons.GlobalContext.getInstance().stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
            stopDrag();
            _bDragging = false;
        }
    }
}