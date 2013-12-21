package commons.anim
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.errors.IllegalOperationError;
    import flash.geom.Matrix;
    import flash.geom.Rectangle;
    
    import mx.utils.StringUtil;
    
    import commons.manager.ICacheManager;
    import commons.manager.base.ManagerGlobalName;
    import commons.manager.base.ManagerHub;
    
    /**
     * 位图动画
     * @author junho
     * <br/>Create: 2013.12.21
     */    
    public class BitmapMC extends Sprite implements IAnimation
    {
        private var _rawData:Object = null;
        
        private var _frameList:Vector.<BitmapFrame>;
        
        private var _beginFrame:int = 0;
        private var _endFrame:int = 0;
        
        private var _curFrame:int = 0;
        private var _fps:uint = 30;
        private var _bLoop:Boolean;
        private var _bRunning:Boolean;
        
        private var _frameOffsetX:Number = 200;
        private var _frameOffsetY:Number = 240;
        
        private var _tickFlag:Boolean = true;
        
        private var _curBmp:Bitmap = null;
        
        
        public function BitmapMC()
        {
            super();
            
            _frameList = new Vector.<BitmapFrame>();
            
            _curBmp = new Bitmap();
            addChild(_curBmp);
        }
        
        public function init(rawData:Object):void
        {
            _rawData = rawData;
            
            if (rawData is MovieClip)
                createEmptyFramesByMC(rawData as MovieClip);
            
            if (0 == _beginFrame)
                _beginFrame = 1;
            if (0 == _endFrame)
                _endFrame = totalFrame;
            
            _curFrame = _beginFrame;
        }
        
        public function get fps():uint
        {
            return _fps;
        }
        
        public function set fps(value:uint):void
        {
            _fps = value;
        }
        
        public function get isLoop():Boolean
        {
            return _bLoop;
        }
        
        public function set isLoop(value:Boolean):void
        {
            _bLoop = value;
        }
        
        public function get curFrame():int
        {
            return _curFrame;
        }
        
        public function get totalFrame():uint
        {
            return _frameList.length;
        }
        
        public function get beginFrame():int
        {
            return _beginFrame;
        }
        
        public function set beginFrame(value:int):void
        {
            if (value < 1 || value > totalFrame)
                throw new IllegalOperationError("起始帧范围不合法");
            _beginFrame = value;
        }
        
        public function get endFrame():int
        {
            return _endFrame;
        }
        
        public function set endFrame(value:int):void
        {
            if (value < 1 || value > totalFrame)
                throw new IllegalOperationError("结束帧范围不合法");
            _endFrame = value;
        }
        
        public function get isRunning():Boolean
        {
            return _bRunning;
        }
        
        public function preFrame():void
        {
            if (_curFrame <= _beginFrame)
                return;
            
            --_curFrame;
            update();
        }
        
        public function nextFrame():void
        {
            if (_curFrame > _endFrame)
                return;
            
            ++_curFrame;
            update();
        }
        
        public function tickFrame():void
        {
            if (!_tickFlag)
                return;
            
            var bCycleCompleted:Boolean = (_curFrame >= _endFrame);
            
            if (_curFrame > _endFrame)
            {
                if (_bLoop)
                {
                    _curFrame = _beginFrame;
                }
                else
                {
                    _curFrame = _endFrame;
                    _tickFlag = false;
                }
                
                bCycleCompleted = true;
            }
            
            update();
            
            if (bCycleCompleted)
                dispatchEvent(new AnimEvent(AnimEvent.CycleCompleted));
            
            ++_curFrame;
        }
        
        public function dispose():void
        {
            if (null != _curBmp)
            {
                _curBmp.bitmapData = null;
                _curBmp = null;
            }
            
            for each (var frame:BitmapFrame in _frameList)
            {
                frame.dispose();
            }
            _frameList.length = 0;
        }
        
        
        
        private function createEmptyFramesByMC(mc:MovieClip):void
        {
            _frameList.length = 0;
            
            const total:int = mc.totalFrames;
            for (var i:int = 1; i <= total; ++i)
            {
                mc.gotoAndStop(i);
                var rect:Rectangle = mc.getBounds(mc);
                var frame:BitmapFrame = new BitmapFrame(rect.x, rect.y, rect.width, rect.height);
                _frameList.push(frame);
            }
        }
        
        private function getBDFromMC(mc:MovieClip, frameNo:int):BitmapData
        {
            var bd:BitmapData = null;
            
            var createMCFrameFunc:Function = function():void
            {
                var frame:BitmapFrame = getFrame(frameNo);
                mc.gotoAndStop(frameNo);
                bd = new BitmapData(frame.width, frame.height, true, 0);
                bd.draw(mc, new Matrix(1, 0, 0, 1, -frame.x, -frame.y));
            };
            
            var cacheMgr:ICacheManager = ManagerHub.getInstance().getManager(ManagerGlobalName.CacheManager) as ICacheManager;
            if (null != cacheMgr)
            {
                var mcFrameResKey:String = StringUtil.substitute("{0}-{1}", mc.name, frameNo);
                bd = cacheMgr.getData(mcFrameResKey);
                if (null == bd)
                {
                    createMCFrameFunc();
                    cacheMgr.addData(bd, mcFrameResKey);
                }
            }
            else
            {
                createMCFrameFunc();
            }
            
            return bd;
        }
        
        private function getFrame(frameNo:int):BitmapFrame
        {
            return _frameList[frameNo-1];
        }
        
        private function update():void
        {
            var frame:BitmapFrame = getFrame(_curFrame);
            if (frame.hasData)
            {
                _curBmp.bitmapData = frame.bitmapData;
                _curBmp.x = frame.x - _frameOffsetX;
                _curBmp.y = frame.y - _frameOffsetY;
                _curBmp.width = frame.width;
                _curBmp.height = frame.height;
            }
            else
            {
                if (_rawData is MovieClip)
                    frame.bitmapData = getBDFromMC(_rawData as MovieClip, _curFrame);
                
                if (frame.hasData)
                {
                    _curBmp.bitmapData = frame.bitmapData;
                    _curBmp.x = frame.x - _frameOffsetX;
                    _curBmp.y = frame.y - _frameOffsetY;
                    _curBmp.width = frame.width;
                    _curBmp.height = frame.height;
                }
            }
        }
    }
}



import flash.display.BitmapData;

class BitmapFrame
{
    private var _x:Number;
    private var _y:Number;
    private var _width:Number;
    private var _height:Number;
    
    private var _bd:BitmapData = null;
    
    
    public function BitmapFrame(x:Number, y:Number, w:Number, h:Number)
    {
        _x = x;
        _y = y;
        _width = w;
        _height = h;
    }
    
    public function dispose():void
    {
        _bd = null;
    }
    
    public function get hasData():Boolean
    {
        return (null != _bd);
    }
    
    public function get x():Number
    {
        return _x;
    }
    
    public function get y():Number
    {
        return _y;
    }
    
    public function get width():Number
    {
        return _width;
    }
    
    public function get height():Number
    {
        return _height;
    }
    
    public function get bitmapData():BitmapData
    {
        return _bd;
    }
    
    public function set bitmapData(bd:BitmapData):void
    {
        _bd = bd;
    }
}