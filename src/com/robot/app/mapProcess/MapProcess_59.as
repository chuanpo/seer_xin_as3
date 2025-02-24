package com.robot.app.mapProcess
{
   import com.robot.app.energy.ore.DayOreCount;
   import com.robot.app.petUpdate.PetUpdatePropController;
   import com.robot.app.task.taskUtils.taskDialog.DynamicNpcTipDialog;
   import com.robot.app.task.taskUtils.taskDialog.NpcTipDialog;
   import com.robot.app.vipSession.VipSession;
   import com.robot.core.CommandID;
   import com.robot.core.config.ClientConfig;
   import com.robot.core.config.xml.PetXMLInfo;
   import com.robot.core.info.pet.PetInfo;
   import com.robot.core.info.pet.PetShowInfo;
   import com.robot.core.manager.GamePlatformManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.NonoManager;
   import com.robot.core.manager.PetManager;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.utils.TextFormatUtil;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.ByteArray;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.ResourceManager;
   import org.taomee.manager.ToolTipManager;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_59 extends BaseMapProcess
   {
      private static var dayOre:DayOreCount;
      
      public static var numberOfDoor:Number = 1;
      
      MainManager.actorInfo.nonoColor;
      
      private var bigWater:MovieClip;
      
      private var numDoor:MovieClip;
      
      private var mc:MovieClip;
      
      private var timeNum:uint;
      
      private var _petName:String;
      
      private var _petInfo:PetShowInfo;
      
      private var petLevel:Number;
      
      private var _petMc:MovieClip;
      
      private var timeNum_2:uint;
      
      private var _isShow:Boolean;
      
      public function MapProcess_59()
      {
         super();
      }
      
      override protected function init() : void
      {
         if(numberOfDoor < 1)
         {
            numberOfDoor = 1;
         }
         this.numDoor = btnLevel["specielDoor"];
         this.numDoor.buttonMode = true;
         if(this.numDoor.currentFrame == 1)
         {
            this.numDoor["mc1"].stop();
            this.numDoor["mc1"].addEventListener(MouseEvent.MOUSE_OVER,this.overHanderMC);
            this.numDoor["mc1"].addEventListener(MouseEvent.MOUSE_OUT,this.outHandleMC);
         }
         this.numDoor.gotoAndStop(numberOfDoor);
         this.numDoor.addEventListener(MouseEvent.CLICK,this.doorAddNumber);
         btnLevel["WaterRunGame"].buttonMode = true;
         this.btnLevel["minerHave"].buttonMode = true;
         btnLevel["river"].buttonMode = true;
         ToolTipManager.add(btnLevel["gameMc"],"水帘穿梭游戏");
         btnLevel["gameMc"].addEventListener(MouseEvent.CLICK,this.gameStart);
         this.bigWater = this.conLevel["bigWater"] as MovieClip;
         this.bigWater.gotoAndStop(1);
         this.bigWater.buttonMode = true;
         this.bigWater.addEventListener(MouseEvent.MOUSE_OVER,this.overHander);
         this.bigWater.addEventListener(MouseEvent.MOUSE_OUT,this.outHander);
         ToolTipManager.add(btnLevel["river"],"尼古拉斯湾");
         btnLevel["WaterRunGame"].addEventListener(MouseEvent.CLICK,this.gameStart);
         btnLevel["minerHave"].addEventListener(MouseEvent.CLICK,this.moneyHave);
         ToolTipManager.add(btnLevel["minerHave"],"滴露源泉");
         btnLevel["waterOut"].gotoAndStop(1);
         btnLevel["river"].addEventListener(MouseEvent.CLICK,this.onRiverClickHandler);
         SocketConnection.addCmdListener(CommandID.NOTE_UPDATE_PROP,this.onUpdateProp);
         SocketConnection.addCmdListener(CommandID.NONO_IS_INFO,this.onGetExpHandler);
      }
      
      private function overHanderMC(e:MouseEvent) : void
      {
         if(Boolean(this.numDoor["mc1"]))
         {
            this.numDoor["mc1"].play();
         }
      }
      
      private function outHandleMC(e:MouseEvent) : void
      {
         if(Boolean(this.numDoor["mc1"]))
         {
            this.numDoor["mc1"].stop();
         }
      }
      
      private function doorAddNumber(e:MouseEvent) : void
      {
         if(numberOfDoor >= 3)
         {
            numberOfDoor = 3;
            return;
         }
         ++numberOfDoor;
         this.numDoor.gotoAndStop(numberOfDoor);
      }
      
      private function overHander(e:MouseEvent) : void
      {
         this.bigWater.gotoAndPlay(1);
      }
      
      private function outHander(e:MouseEvent) : void
      {
         this.bigWater.gotoAndStop(1);
      }
      
      private function gameStart(e:MouseEvent) : void
      {
         if(MainManager.actorInfo.superNono)
         {
            NpcTipDialog.showAnswer("NoNo……我好激动哦！你准备好了吗？马上我们就要进入到飞流直上的尼古尔瀑布中咯！",function():void
            {
               GamePlatformManager.join("ThruTimeSpaceGame");
            },null,NpcTipDialog.NONO);
         }
         else
         {
            DynamicNpcTipDialog.show("再聪明的NoNo也不能应对这么强大的水力冲击，这实在太危险了！快开通超能NoNo，让它带你体验飞流直上的快感吧！你说水帘巅峰到底是什么样子呢？",function():void
            {
               var r:VipSession = new VipSession();
               r.addEventListener(VipSession.GET_SESSION,function(event:Event):void
               {
               });
               r.getSession();
            },NpcTipDialog.NONO);
         }
      }
      
      private function moneyHave(e:MouseEvent) : void
      {
         btnLevel["minerHave"].removeEventListener(MouseEvent.CLICK,this.moneyHave);
         if(!MainManager.actorModel.nono)
         {
            NpcTipDialog.show("哎呀呀！！！快召唤你的超能NoNo进入到滴露内部吧…哇哦！晶莹剔透( ⊙ o ⊙ )啊！",null,NpcTipDialog.NONO);
            return;
         }
         if(!MainManager.actorInfo.superNono)
         {
            if(MainManager.actorModel.nono.info.ai < 25)
            {
               DynamicNpcTipDialog.show("你可以选择将你的NoNo升级到 " + TextFormatUtil.getRedTxt("AI25") + " 级之后再来挑战，或者立刻为你的NoNo充能让它成为" + TextFormatUtil.getRedTxt("超能NoNo") + "！",this.url,NpcTipDialog.NONO);
            }
            else
            {
               NpcTipDialog.show("嘿咻嘿咻！NoNo也要进入水泡泡内部……忽闪忽闪！NoNo……",this.normalNoNo,NpcTipDialog.NONO_2,-60,this.normalNoNo);
            }
         }
         else
         {
            dayOre = new DayOreCount();
            dayOre.addEventListener(DayOreCount.countOK,this.onCountOK);
            dayOre.sendToServer(2055);
         }
      }
      
      private function normalNoNo() : void
      {
         dayOre = new DayOreCount();
         dayOre.addEventListener(DayOreCount.countOK,this.onCountOK);
         dayOre.sendToServer(2055);
      }
      
      private function onCountOK(e:Event) : void
      {
         dayOre.removeEventListener(DayOreCount.countOK,this.onCountOK);
         trace(DayOreCount.oreCount.toString() + "次");
         this.nonoActive();
      }
      
      private function nonoActive(e:MouseEvent = null) : void
      {
         if(Boolean(MainManager.actorModel.nono))
         {
            if(DayOreCount.oreCount < 5)
            {
               btnLevel["minerHave"].gotoAndStop(2);
               MainManager.actorModel.hideNono();
               btnLevel["minerHave"].addEventListener(Event.ENTER_FRAME,this.onMainComp);
            }
            else
            {
               NpcTipDialog.show("滴露源泉，一天玩不够！嘿，我们明天再来吧……NoNo今天好高兴哦！",null,NpcTipDialog.NONO);
               btnLevel["minerHave"].addEventListener(MouseEvent.CLICK,this.moneyHave);
            }
         }
         else
         {
            trace("NONO不见了，找回来 ");
         }
      }
      
      private function onMainComp(e:Event) : void
      {
         if(Boolean(btnLevel["minerHave"]["mc2"]))
         {
            btnLevel["minerHave"].removeEventListener(Event.ENTER_FRAME,this.onMainComp);
            setTimeout(function():void
            {
               DisplayUtil.FillColor(btnLevel["minerHave"]["mc2"]["mc1"]["nonoInfo"]["mc"],MainManager.actorInfo.nonoColor);
               btnLevel["minerHave"]["mc2"]["mc1"].visible = true;
               btnLevel["minerHave"]["mc2"]["mc1"].gotoAndPlay(2);
               timeNum = setTimeout(function():void
               {
                  if(MainManager.actorInfo.superNono)
                  {
                     SocketConnection.send(CommandID.TALK_CATE,2055);
                  }
                  else
                  {
                     SocketConnection.send(CommandID.TALK_CATE,19);
                  }
                  MainManager.actorModel.showNono(NonoManager.info,MainManager.actorInfo.actionType);
                  btnLevel["minerHave"].gotoAndStop(1);
                  btnLevel["minerHave"].addEventListener(MouseEvent.CLICK,moneyHave);
               },7000);
            },300);
         }
      }
      
      private function onSuccess(e:SocketEvent) : void
      {
         var str:String = null;
         SocketConnection.removeCmdListener(CommandID.TALK_CATE,this.onSuccess);
         if(MainManager.actorInfo.superNono)
         {
            str = "2块";
            NpcTipDialog.show("飘呀飘呀！主人，我感觉我的头像电灯泡，你看我帅吗……嘿嘿！" + TextFormatUtil.getRedTxt(str + "尼古滴露") + "到手咯！",null,NpcTipDialog.NONO);
         }
         else
         {
            str = "1块";
            NpcTipDialog.show("铛铛铛……我拿到了" + TextFormatUtil.getRedTxt(str + "尼古滴露") + "哦！主人，你说我厉害不厉害呀！",null,NpcTipDialog.NONO);
         }
      }
      
      private function onRiverClickHandler(e:MouseEvent) : void
      {
         var ty:String = null;
         if(!MainManager.actorInfo.superNono)
         {
            DynamicNpcTipDialog.show("尼古拉斯湾曾经孕育很多奇幻的精灵，在这里也有着各式各样的精灵传说！不过只有在" + TextFormatUtil.getRedTxt("超能NoNo") + "的超能力帮助下，我们才能够触碰河流中的水哦！",this.url,NpcTipDialog.NONO);
            return;
         }
         if(MainManager.actorInfo.vip != 1)
         {
            DynamicNpcTipDialog.show("只有超能NONO才能带你体验尼古拉斯湾的神奇力量哦！",this.url,NpcTipDialog.NONO);
            return;
         }
         if(!MainManager.actorModel.pet)
         {
            NpcTipDialog.show("这里可是" + TextFormatUtil.getRedTxt("水系精灵") + "的天堂，快让你的水系伙伴体验一下尼古拉斯湾的神奇所在吧！",null,NpcTipDialog.NONO);
            return;
         }
         if(Boolean(MainManager.actorInfo.superNono) && PetXMLInfo.getTypeCN(MainManager.actorModel.pet.info.petID) == "水")
         {
            this._petInfo = MainManager.actorModel.pet.info;
            this._petName = PetXMLInfo.getName(this._petInfo.petID);
            ty = PetXMLInfo.getType(this._petInfo.petID);
            if(ty == "2")
            {
               NpcTipDialog.showAnswer("这里曾经孕育出一个又一个的传奇水系精灵，档案中也有记载，这里的水对于水系精灵来说有着奇特的功效，快带着你的" + TextFormatUtil.getRedTxt("水系精灵") + "过来泡一泡吧！瞧！它是不是容光焕发呀？",function():void
               {
                  ResourceManager.getResource(ClientConfig.getPetSwfPath(_petInfo.petID),onLoadPetHandler);
               },null,NpcTipDialog.NONO);
            }
            else
            {
               NpcTipDialog.show("这里可是" + TextFormatUtil.getRedTxt("水系精灵") + "的天堂，你怎么带了其他属性的精灵呢？快让你的水系伙伴体验一下尼古拉斯湾的神奇所在吧！",null,NpcTipDialog.NONO);
            }
         }
         else if(PetXMLInfo.getTypeCN(MainManager.actorModel.pet.info.petID) != "水")
         {
            NpcTipDialog.show("这里可是" + TextFormatUtil.getRedTxt("水系精灵") + "的天堂，快让你的水系伙伴体验一下尼古拉斯湾的神奇所在吧！",null,NpcTipDialog.NONO);
         }
      }
      
      private function onLoadPetHandler(mc:DisplayObject) : void
      {
         if(Boolean(MainManager.actorModel.pet))
         {
            PetManager.storageUpDate(MainManager.actorModel.pet.info.catchTime,function(info:PetInfo):void
            {
               petLevel = info.level;
               trace(info.level);
            });
         }
         if(Boolean(mc))
         {
            MainManager.actorModel.hidePet();
            this._petMc = mc as MovieClip;
            this.btnLevel.addChild(this._petMc);
            this._petMc.x = 580;
            this._petMc.y = 430;
            btnLevel["waterOut"].gotoAndPlay(1);
            this.timeNum_2 = setTimeout(function():void
            {
               var na:* = undefined;
               MainManager.actorModel.showPet(_petInfo);
               DisplayUtil.removeForParent(_petMc);
               _isShow = false;
               btnLevel["waterOut"].gotoAndStop(1);
               if(petLevel < 100)
               {
                  SocketConnection.send(CommandID.NONO_IS_INFO,1);
               }
               else
               {
                  na = TextFormatUtil.getRedTxt(_petName);
                  NpcTipDialog.show(na + "是100级的精灵哟，没法再吸收能量长大了！",showUp,NpcTipDialog.NONO,0,showUp);
               }
            },3000);
         }
      }
      
      private function onGetExpHandler(e:SocketEvent) : void
      {
         var by:ByteArray = e.data as ByteArray;
         var exp:int = int(by.readUnsignedInt());
         var str:String = TextFormatUtil.getRedTxt(String(exp));
         var na:String = TextFormatUtil.getRedTxt(this._petName);
         if(exp < 1000)
         {
            NpcTipDialog.show("嘿!这泉水果然与众不同呢，有点甜？有点酸？" + na + "增长了" + str + "点经验。",this.showUp,NpcTipDialog.NONO,0,this.showUp);
         }
         if(exp >= 1000 && exp < 2000)
         {
            NpcTipDialog.show("啦啦啦！继续淋浴尼古拉斯的泉水吧，" + na + "这可对你有好处呐！你已经吸收了" + str + "点经验。",this.showUp,NpcTipDialog.NONO,0,this.showUp);
         }
         if(exp >= 2000 && exp < 3000)
         {
            NpcTipDialog.show(" ( ⊙o⊙ )哇~~~  " + na + "增长了" + str + "点经验。",this.showUp,NpcTipDialog.NONO,0,this.showUp);
         }
         if(exp >= 3000)
         {
            NpcTipDialog.show("尼古拉斯湾的泉水果然与众不同，" + na + "经过了泉水的孕育，增长了" + str + "点经验。",this.showUp,NpcTipDialog.NONO,0,this.showUp);
         }
      }
      
      private function onUpdateProp(e:SocketEvent) : void
      {
         this._isShow = true;
      }
      
      private function showUp() : void
      {
         if(this._isShow)
         {
            PetUpdatePropController.owner.show(true);
            this._isShow = false;
         }
      }
      
      public function url() : void
      {
         var r:VipSession = new VipSession();
         r.addEventListener(VipSession.GET_SESSION,function(event:Event):void
         {
         });
         r.getSession();
      }
      
      override public function destroy() : void
      {
         if(Boolean(this.numDoor["mc1"]))
         {
            this.numDoor["mc1"].removeEventListener(MouseEvent.MOUSE_OVER,this.overHanderMC);
            this.numDoor["mc1"].removeEventListener(MouseEvent.MOUSE_OUT,this.outHandleMC);
         }
         SocketConnection.removeCmdListener(CommandID.NOTE_UPDATE_PROP,this.onUpdateProp);
         SocketConnection.removeCmdListener(CommandID.NONO_IS_INFO,this.onGetExpHandler);
         SocketConnection.removeCmdListener(CommandID.TALK_CATE,this.onSuccess);
         this.bigWater.removeEventListener(MouseEvent.MOUSE_OVER,this.overHander);
         this.bigWater.removeEventListener(MouseEvent.MOUSE_OUT,this.outHander);
         this.bigWater.removeEventListener(MouseEvent.CLICK,this.gameStart);
         ToolTipManager.remove(btnLevel["gameMc"]);
         btnLevel["gameMc"].removeEventListener(MouseEvent.CLICK,this.gameStart);
         btnLevel["minerHave"].removeEventListener(Event.ENTER_FRAME,this.onMainComp);
         clearTimeout(this.timeNum);
         clearTimeout(this.timeNum_2);
      }
   }
}

