package ui
{
    import flash.events.Event;
    import flash.events.FocusEvent;
    
    import mx.utils.StringUtil;
    
    import webgame.ui.GixInput;
    
    /**
     * 带提示功能的文本控件
     * @author junho
     * <br/>Create: 2013.12.26
     */    
    public class GixTipsInput extends GixInput
    {
        private var _bHasContent:Boolean = false;
        private var _content:String = "";
        private var _tips:String = "";
        
        
        public function GixTipsInput()
        {
            super();
        }
        
        override public function init():void
        {
            addEventListener(Event.CHANGE, onTextChanged);
        }
        
        override public function get text():String
        {
            if ("" != _content)
                return textField.text;
            else
                return "";
        }
        
        override public function get htmlText():String
        {
            if ("" != _content)
                return textField.htmlText;
            else
                return "";
        }
        
        public function set tips(value:String):void
        {
            if (null != value)
                _tips = value;
            else
                _tips = "";
            
            try2UpdateTextByTips();
        }
        
        public function set content(value:String):void
        {
            _content = value;
            textField.text = value;
            _bHasContent = true;
            updateStatus();
        }
        
        
        
        override protected function onFocusIn(e:FocusEvent):void
        {
            if (!_bHasContent)
                textField.htmlText = "";
        }
        
        override protected function onFocusOut(e:FocusEvent):void
        {
            try2UpdateTextByTips();
        }
        
        
        
        private function onTextChanged(e:Event):void
        {
            _content = textField.text;
            _bHasContent = ("" != _content);
            if (_bHasContent)
                updateStatus();
        }
        
        private function try2UpdateTextByTips():void
        {
            if (!_bHasContent)
                textField.htmlText = StringUtil.substitute("<font color='#767676'>{0}</font>", _tips);
        }
    }
}