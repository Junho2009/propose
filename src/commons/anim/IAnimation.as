package commons.anim
{
    import commons.IDispose;

    /**
     * 动画接口
     * <br/>注：帧数从1开始
     * @author junho
     * <br/>Create: 2013.12.21
     */    
    public interface IAnimation extends IDispose
    {
        function init(rawData:Object):void;
        
        function get fps():uint;
        function set fps(value:uint):void;
        
        function get isLoop():Boolean;
        function set isLoop(value:Boolean):void;
        
        function get curFrame():int;
        function get totalFrame():uint;
        
        function get beginFrame():int;
        function set beginFrame(value:int):void;
        
        function get endFrame():int;
        function set endFrame(value:int):void;
        
        function get isRunning():Boolean;
        
        function preFrame():void;
        function nextFrame():void;
        
        function tickFrame():void;
    }
}