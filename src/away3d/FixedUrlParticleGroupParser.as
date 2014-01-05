package away3d
{
    import flash.utils.ByteArray;
    
    import mx.utils.StringUtil;
    
    import away3d.loaders.parsers.Parsers;
    import away3d.loaders.parsers.ParticleGroupParser;
    
    import commons.load.FilePath;
    
    /**
     * 指定url的ParticleGroupParser
     * @author junho
     * <br/>Create: 2014.01.05
     */    
    internal class FixedUrlParticleGroupParser extends ParticleGroupParser
    {
        public function FixedUrlParticleGroupParser()
        {
            Parsers.enableAllBundled();
            super();
        }
        
        override public function parseAsync(data:*, frameLimit:Number=15):void
        {
            if (data is String || data is ByteArray)
            {
                data = JSON.parse(data);
            }
            
            var animationDatas:Array = data.animationDatas;
            var urlInfo:Array = null;
            for (var index:int = 0; index < animationDatas.length; index++)
            {
                var animationData:Object = animationDatas[index];
                var propertyData:Object = animationData.property;
                var texturePath:String = null;
                if (animationData.hasOwnProperty("data") && animationData.data.hasOwnProperty("material"))
                {
                    var material:Object = animationData.data.material;
                    if (material.hasOwnProperty("data") && material.data.hasOwnProperty("url"))
                    {
                        urlInfo = String(material.data.url).split("/");
                        texturePath = urlInfo[urlInfo.length - 1];
                        material.data.url = StringUtil.substitute("{0}{1}"
                            , FilePath.effect3dTexPath, texturePath);
                    }
                }
                if (animationData.hasOwnProperty("data") && animationData.data.hasOwnProperty("geometry"))
                {
                    var geometry:Object = animationData.data.geometry;
                    if (geometry.hasOwnProperty("data")
                        && geometry.data.hasOwnProperty("assembler")
                        && geometry.data.assembler.hasOwnProperty("data")
                        && geometry.data.assembler.data.hasOwnProperty("shape")
                        && geometry.data.assembler.data.shape.hasOwnProperty("data")
                        && geometry.data.assembler.data.shape.data.hasOwnProperty("url"))
                    {
                        urlInfo = String(geometry.data.assembler.data.shape.data.url).split("/");
                        texturePath = urlInfo[urlInfo.length - 1];
                        geometry.data.assembler.data.shape.data.url = StringUtil.substitute("{0}{1}"
                            , FilePath.effect3dTexPath, texturePath);
                    }
                }
            }
            
            super.parseAsync(data, frameLimit);
        }
    }
}