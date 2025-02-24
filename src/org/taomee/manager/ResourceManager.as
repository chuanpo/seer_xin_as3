package org.taomee.manager
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.LoaderInfo;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.utils.getQualifiedClassName;
   import org.taomee.ds.HashMap;
   import org.taomee.resource.ResInfo;
   import org.taomee.resource.ResLoader;
   import org.taomee.utils.ArrayUtil;
   
   public class ResourceManager
   {
      public static const RESOUCE_ERROR:String = "resourceError";
      
      public static const RESOUCE_REFLECT_ERROR:String = "resourceReflectError";
      
      public static const HIGHEST:int = 0;
      
      public static const HIGH:int = 1;
      
      public static const STANDARD:int = 2;
      
      public static const LOW:int = 3;
      
      public static const LOWEST:int = 4;
      
      public static var maxLpt:uint = 2;
      
      public static var maxCache:uint = 300;
      
      private static var _dataList:Array = [];
      
      private static var _loaderList:Array = [];
      
      private static var _cacheList:Array = [];
      
      private static var _cacheMultiList:Array = [];
      
      private static var _isStop:Boolean = false;
      
      public function ResourceManager()
      {
         super();
      }
      
      public static function play() : void
      {
         _isStop = false;
         nextLoad();
      }
      
      private static function cancelEmpl(url:String, event:Function = null) : void
      {
         var resLoader:ResLoader = null;
         var len:int = 0;
         var i:int = 0;
         var eindex:int = 0;
         for each(resLoader in _loaderList)
         {
            if(resLoader.resInfo.url == url)
            {
               if(event != null)
               {
                  eindex = int(resLoader.resInfo.eventList.indexOf(event));
                  if(eindex == -1)
                  {
                     return;
                  }
                  resLoader.resInfo.eventList.splice(eindex,1);
                  if(resLoader.resInfo.eventList.length > 0)
                  {
                     return;
                  }
               }
               removeLoader(resLoader);
               len = int(_dataList.length);
               for(i = 0; i < len; i++)
               {
                  if(_dataList[i].url == url)
                  {
                     _dataList.splice(i,1);
                     break;
                  }
               }
               nextLoad();
               return;
            }
         }
      }
      
      public static function getResourceList(url:String, event:Function, nameList:Array, level:int = 3, isCache:Boolean = true) : void
      {
         var outArr:Array = null;
         var n:Object = null;
         var cmap:HashMap = null;
         var name:String = null;
         var res:Class = null;
         var rn:ResInfo = null;
         var resInfo:ResInfo = null;
         var resLoader:ResLoader = null;
         if(_cacheMultiList.length > 0)
         {
            outArr = [];
            for each(n in _cacheMultiList)
            {
               if(n.url == url)
               {
                  cmap = n.map;
                  for(name in nameList)
                  {
                     res = cmap.getValue(name);
                     if(Boolean(res))
                     {
                        if(res is BitmapData)
                        {
                           outArr.push(new Bitmap(res as BitmapData));
                        }
                        else
                        {
                           outArr.push(new res());
                        }
                     }
                  }
                  break;
               }
            }
            if(outArr.length == nameList.length)
            {
               event(outArr);
               return;
            }
         }
         var isHas:Boolean = false;
         var dLen:int = int(_dataList.length);
         if(dLen > 0)
         {
            for each(rn in _dataList)
            {
               if(rn.url == url)
               {
                  if(rn.name == "")
                  {
                     rn.eventList.push(event);
                     isHas = true;
                  }
                  break;
               }
            }
         }
         if(!isHas)
         {
            resInfo = new ResInfo();
            resInfo.eventList.push(event);
            resInfo.isCache = isCache;
            resInfo.level = level;
            resInfo.url = url;
            nameList.sort();
            resInfo.nameList = nameList;
            _dataList.push(resInfo);
            _dataList.sortOn("level",Array.NUMERIC);
            resLoader = getEmptyLoader(level);
            if(Boolean(resLoader))
            {
               resLoader.load(resInfo);
            }
         }
      }
      
      private static function getEmptyLoader(level:int = 3) : ResLoader
      {
         var resLoader:ResLoader = null;
         var len:int = int(_loaderList.length);
         if(len < maxLpt)
         {
            resLoader = new ResLoader();
            resLoader.addEventListener(Event.COMPLETE,onLoadComplete);
            resLoader.addEventListener(IOErrorEvent.IO_ERROR,onIOError);
            _loaderList.push(resLoader);
            return resLoader;
         }
         _loaderList.sortOn("level",Array.NUMERIC | Array.DESCENDING);
         resLoader = _loaderList[0] as ResLoader;
         if(level == HIGHEST)
         {
            resLoader.close();
            return resLoader;
         }
         if(level != LOWEST)
         {
            if(resLoader.level == LOWEST)
            {
               resLoader.close();
               return resLoader;
            }
         }
         return null;
      }
      
      private static function onLoadComplete(e:Event) : void
      {
         var resInfo:ResInfo = null;
         var bd:BitmapData = null;
         var d:Function = null;
         var cla:Class = null;
         var nlen:int = 0;
         var dd:Function = null;
         var outArr:Array = null;
         var cacheMap:HashMap = null;
         var nameList:Array = null;
         var resName:String = null;
         var hasURL:Boolean = false;
         var nl:Function = null;
         var n:Function = null;
         var resLoader:ResLoader = e.target as ResLoader;
         var loaderInfo:LoaderInfo = resLoader.loaderInfo;
         resInfo = resLoader.resInfo;
         var eventList:Array = resInfo.eventList;
         if(loaderInfo.content is Bitmap)
         {
            bd = (loaderInfo.content as Bitmap).bitmapData.clone();
            if(resInfo.isCache)
            {
               _cacheList.push({
                  "url":resInfo.url,
                  "res":bd
               });
            }
            for each(d in eventList)
            {
               d(new Bitmap(bd));
            }
         }
         else if(resInfo.name == "")
         {
            nlen = int(resInfo.nameList.length);
            if(nlen == 0)
            {
               cla = loaderInfo.applicationDomain.getDefinition(getQualifiedClassName(loaderInfo.content)) as Class;
               if(resInfo.isCache)
               {
                  _cacheList.push({
                     "url":resInfo.url,
                     "res":cla
                  });
               }
               for each(dd in eventList)
               {
                  dd(new cla());
               }
            }
            else
            {
               outArr = [];
               cacheMap = new HashMap();
               nameList = resInfo.nameList;
               for each(resName in nameList)
               {
                  if(loaderInfo.applicationDomain.hasDefinition(resName))
                  {
                     cla = loaderInfo.applicationDomain.getDefinition(resName) as Class;
                     if(Boolean(cla))
                     {
                        cacheMap.add(resName,cla);
                        if(cla is BitmapData)
                        {
                           outArr.push(new Bitmap(cla as BitmapData));
                        }
                        else
                        {
                           outArr.push(new cla());
                        }
                     }
                  }
                  else
                  {
                     EventManager.dispatchEvent(new Event(RESOUCE_REFLECT_ERROR));
                  }
               }
               if(resInfo.isCache)
               {
                  hasURL = Boolean(_cacheMultiList.some(function(item:Object, index:int, array:Array):Boolean
                  {
                     var cmap:* = undefined;
                     if(item.url == resInfo.url)
                     {
                        cmap = item.map;
                        cacheMap.each2(function(key:*, value:*):void
                        {
                           cmap.add(key,value);
                        });
                        return true;
                     }
                     return false;
                  }));
                  if(!hasURL)
                  {
                     _cacheMultiList.push({
                        "url":resInfo.url,
                        "map":cacheMap
                     });
                  }
               }
               else
               {
                  cacheMap = null;
               }
               if(outArr.length > 0)
               {
                  for each(nl in eventList)
                  {
                     nl(outArr);
                  }
               }
               if(_cacheMultiList.length > maxCache)
               {
                  _cacheMultiList.shift();
               }
            }
         }
         else
         {
            if(loaderInfo.applicationDomain.hasDefinition(resInfo.name))
            {
               cla = loaderInfo.applicationDomain.getDefinition(resInfo.name) as Class;
            }
            else
            {
               EventManager.dispatchEvent(new Event(RESOUCE_REFLECT_ERROR));
            }
            if(Boolean(cla))
            {
               if(resInfo.isCache)
               {
                  _cacheList.push({
                     "url":resInfo.url,
                     "res":cla
                  });
               }
               for each(n in eventList)
               {
                  n(new cla());
               }
            }
         }
         removeLoader(resLoader);
         if(_cacheList.length > maxCache)
         {
            _cacheList.shift();
         }
         ArrayUtil.removeValueFromArray(_dataList,resInfo);
         nextLoad();
      }
      
      public static function stop() : void
      {
         var resLoader:ResLoader = null;
         _isStop = true;
         for each(resLoader in _loaderList)
         {
            if(resLoader.level == LOWEST)
            {
               removeLoader(resLoader);
            }
         }
      }
      
      public static function cancel(url:String, event:Function) : void
      {
         cancelEmpl(url,event);
      }
      
      public static function getResource(url:String, event:Function, name:String = "item", level:int = 3, isCache:Boolean = true) : void
      {
         var isHas:Boolean;
         var n:Object = null;
         var resInfo:ResInfo = null;
         var resLoader:ResLoader = null;
         if(_cacheList.length > 0)
         {
            for each(n in _cacheList)
            {
               if(n.url == url)
               {
                  if(n.res is BitmapData)
                  {
                     event(new Bitmap(n.res as BitmapData));
                  }
                  else
                  {
                     event(new n.res());
                  }
                  return;
               }
            }
         }
         isHas = Boolean(_dataList.some(function(item:ResInfo, index:int, array:Array):Boolean
         {
            if(item.url == url)
            {
               item.eventList.push(event);
               return true;
            }
            return false;
         }));
         if(!isHas)
         {
            resInfo = new ResInfo();
            resInfo.eventList.push(event);
            resInfo.isCache = isCache;
            resInfo.level = level;
            resInfo.url = url;
            resInfo.name = name;
            _dataList.push(resInfo);
            _dataList.sortOn("level",Array.NUMERIC);
            resLoader = getEmptyLoader(level);
            if(Boolean(resLoader))
            {
               resLoader.load(resInfo);
            }
         }
      }
      
      public static function cancelURL(url:String) : void
      {
         cancelEmpl(url);
      }
      
      public static function cancelAll() : void
      {
         var o:ResLoader = null;
         for each(o in _loaderList)
         {
            removeLoader(o);
         }
         _loaderList = [];
         _dataList = [];
      }
      
      private static function onIOError(e:IOErrorEvent) : void
      {
         var resLoader:ResLoader = e.target as ResLoader;
         var resInfo:ResInfo = resLoader.resInfo;
         removeLoader(resLoader);
         ArrayUtil.removeValueFromArray(_dataList,resInfo);
         nextLoad();
         EventManager.dispatchEvent(new Event(RESOUCE_ERROR));
         trace("资源加载路径不正确:" + resInfo.url);
      }
      
      public static function addBef(url:String, name:String = "item", isCache:Boolean = true) : void
      {
         var rn:ResInfo = null;
         var resInfo:ResInfo = null;
         var isHas:Boolean = false;
         var dLen:int = int(_dataList.length);
         if(dLen > 0)
         {
            for each(rn in _dataList)
            {
               if(rn.url == url)
               {
                  isHas = true;
                  break;
               }
            }
         }
         if(!isHas)
         {
            resInfo = new ResInfo();
            resInfo.isCache = isCache;
            resInfo.level = LOWEST;
            resInfo.url = url;
            resInfo.name = name;
            _dataList.push(resInfo);
         }
      }
      
      private static function removeLoader(resLosder:ResLoader) : void
      {
         ArrayUtil.removeValueFromArray(_loaderList,resLosder);
         if(resLosder.isLoading)
         {
            resLosder.close();
         }
         resLosder.removeEventListener(Event.COMPLETE,onLoadComplete);
         resLosder.removeEventListener(IOErrorEvent.IO_ERROR,onIOError);
         resLosder.destroy();
         resLosder = null;
      }
      
      private static function nextLoad() : void
      {
         var k:int = 0;
         var resInfo:ResInfo = null;
         var resLoader:ResLoader = null;
         if(_isStop)
         {
            return;
         }
         var len:int = int(_dataList.length);
         if(len > 0)
         {
            for(k = 0; k < len; k++)
            {
               resInfo = _dataList[k] as ResInfo;
               if(!resInfo.isLoading)
               {
                  resLoader = getEmptyLoader();
                  if(Boolean(resLoader))
                  {
                     resLoader.load(resInfo);
                  }
                  break;
               }
            }
         }
      }
   }
}

