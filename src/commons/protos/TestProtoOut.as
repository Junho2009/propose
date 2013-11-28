package commons.protos
{
    import commons.protos.base.MudProtoOut;
    
    public class TestProtoOut extends MudProtoOut
    {
        public var msg:String;
        
        public function TestProtoOut()
        {
            super("test");
        }
        
        override protected function readyPropList():void
        {
            _propList.push(msg);
        }
    }
}