package flowersend
{
    import flash.display.Shape;
    import flash.events.Event;
    import flash.filters.GlowFilter;
    import flash.text.TextFormatAlign;
    
    import mx.utils.StringUtil;
    
    import commons.GlobalContext;
    import commons.buses.InnerEventBus;
    import commons.manager.IFlowerSendManager;
    import commons.manager.base.ManagerGlobalName;
    import commons.manager.base.ManagerHub;
    
    import webgame.ui.GixText;
    import webgame.ui.View;
    
    /**
     * 鲜花赠送信息界面
     * @author junho
     * <br/>Create: 2014.01.05
     */    
    public class FlowerSendInfoView extends View
    {
        private static const _W:Number = 300;
        private static const _H:Number = 60;
        
        private var _flowerSendMgr:IFlowerSendManager;
        
        private var _selfSentNum:GixText;
        private var _sentTotal:GixText;
        
        
        public function FlowerSendInfoView()
        {
            super("FlowerSendInfoView", _W, _H);
            
            var shape:Shape = new Shape();
            shape.graphics.beginFill(0, 0.6);
            shape.graphics.drawRoundRect(0, 0, _W, _H, 8);
            shape.graphics.endFill();
            backgroundImage = shape;
            
            _flowerSendMgr = ManagerHub.getInstance().getManager(ManagerGlobalName.FlowerSendManager) as IFlowerSendManager;
            
            _selfSentNum = new GixText();
            _sentTotal = new GixText();
            
            init();
            
            addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
            addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
        }
        
        override public function init():void
        {
            _selfSentNum.init();
            _selfSentNum.size = 14;
            _selfSentNum.color = 0xffea00;
            _selfSentNum.align = TextFormatAlign.CENTER;
//            _selfSentNum.filters = [new GlowFilter(0xa78829, 1.0, 6.0, 6.0, 6)];
            _selfSentNum.width = 200;
            _selfSentNum.height = 25;
            _selfSentNum.y = 5;
            addChild(_selfSentNum);
            
            _sentTotal.init();
            _sentTotal.size = 14;
            _sentTotal.color = 0xffea00;
            _sentTotal.align = TextFormatAlign.CENTER;
//            _sentTotal.filters = [new GlowFilter(0xa78829, 1.0, 6.0, 6.0, 6)];
            _sentTotal.width = 200;
            _sentTotal.height = 25;
            _sentTotal.y = _selfSentNum.y + _selfSentNum.height;
            addChild(_sentTotal);
            
            _selfSentNum.x = this.width - _selfSentNum.width >> 1;
            _sentTotal.x = this.width - _sentTotal.width >> 1;
        }
        
        
        
        private function onAddedToStage(e:Event):void
        {
            GlobalContext.getInstance().stage.addEventListener(Event.RESIZE, onStageResized);
            onStageResized();
            
            InnerEventBus.getInstance().addEventListener(FlowerSendEvent.SentInfoUpdated, onSentInfoUpdated);
            updateSentInfo(_flowerSendMgr.selfSentNum, _flowerSendMgr.totalSentNum);
        }
        
        private function onRemovedFromStage(e:Event):void
        {
            GlobalContext.getInstance().stage.removeEventListener(Event.RESIZE, onStageResized);
            InnerEventBus.getInstance().removeEventListener(FlowerSendEvent.SentInfoUpdated, onSentInfoUpdated);
        }
        
        private function onStageResized(e:Event = null):void
        {
            this.x = GlobalContext.getInstance().stage.stageWidth - this.width >> 1;
            this.y = GlobalContext.getInstance().stage.stageHeight - this.height - 10;
        }
        
        private function updateSentInfo(self:uint, total:uint):void
        {
            _selfSentNum.text = StringUtil.substitute("您已赠送{0}朵鲜花", self);
            _sentTotal.text = StringUtil.substitute("所有朋友合计已赠送{0}朵鲜花", total);
        }
        
        private function onSentInfoUpdated(inc:FlowerSendEvent):void
        {
            updateSentInfo(_flowerSendMgr.selfSentNum, _flowerSendMgr.totalSentNum);
        }
    }
}