model GamaToUnityUDP_Multi_model_VR

import "scp.gaml"

species unity_linker parent: abstract_unity_linker {
	//list<point> init_locations <- [{50.0, 50.0}];
	string player_species <- string(unity_player);
	int max_num_players  <- 4;
	int min_num_players  <- 1;
	
	
	
	unity_property up_map_agent;
	//unity_property up_default;


	list<point> init_locations <- define_init_locations();

	list<point> define_init_locations {
		return [{22.5,22.5,0.0},{22.5,22.5,0.0},{50.0,50.0,0.0},{50.0,50.0,0.0}];
	}
 
 
// list<point> init_locations <- [{22.5, 22.5}];


	init {
		do define_properties;
		//player_unity_properties <- [nil,nil,nil,nil];
		do add_background_geometries(map_agent,up_map_agent);
	}
	action define_properties {
		unity_aspect map_agent_aspect <- prefab_aspect("Prefabs/Visual Prefabs/City/Vehicles/Map",1.0,-1.0,1.0,0.0,precision);
		up_map_agent <- geometry_properties("map_agent","",map_agent_aspect,#no_interaction,false);
		unity_properties << up_map_agent;
	}
	
	reflex send_geometries {


		do add_geometries_to_send(map_agent,up_map_agent);
	}
	
	
	
	
	
	// ไม่ส่งข้อมูล world ไป Unity ทุก step (ช่วยลดโหลด)
	//bool do_send_world <- false;
	bool do_send_world <- true;
	
	// 🔁 ทำงานทุก 100 cycle และต้องมี player อยู่
	reflex send_message when: every(100 #cycle) and not empty(unity_player){
		
		// แสดงข้อความใน console
		//write "Send message: "  + cycle;
		
		// 📤 ส่ง message ไปยัง player ทุกคนใน Unity
		// รูปแบบเป็น map: "ชื่อข้อมูล"::ค่า
		//do send_message players: unity_player as list mes: ["cycle":: cycle];
	}
	










//action receive_message (string id, string mes, int hp, float x, int score_val, string name_val) {
//    string clean_id <- lower_case(id);
//    
//    // 1. ฝากค่า score ที่รับมาจาก Unity ไว้ในตัวแปรชั่วคราวชื่อ temp_score
//    int temp_score <- score_val; 
//    string temp_name <- name_val;
//    unity_player target_p <- first(unity_player where (lower_case(each.name) = clean_id));
//    
//    if (target_p != nil) {
//        ask target_p {
//            // 2. นำค่าจากตัวแปรชั่วคราวมาใส่ให้ตัวผู้เล่น
//            self.score <- temp_score; 
//            self.name <- temp_name; 
//            
//            write "SUCCESS! Updated " + self.name + " to: " + self.score;
//        }
//    } else {
//        write "Looking for: " + clean_id + " but not found.";
//    }
//}	




//action receive_message1 (string id, string mes, int score_val, string name_val) {
//    // 1. ใช้ replace แทน trim ในการตัดช่องว่าง (กรณี GAMA ไม่รองรับ trim)
//    // แทนที่ช่องว่าง (space) ด้วย "" (ว่างเปล่า)
//    string clean_id <- replace(id, " ", "");
//     
//    clean_id <- lower_case(clean_id);
//    
//    // 2. ปรับการหา Agent ให้ถูกต้องตามโครงสร้างภาษา GAML
//    // ใช้ (unity_player) เพื่อระบุว่าเป็น List ของ Agent
//    unity_player target_p <- first(unity_player where (lower_case(replace(each.name, " ", "")) = clean_id));
//    
//    if (target_p != nil) {
//        ask target_p {
//            self.score <- score; 
//            self.name <- name; 
//            write "SUCCESS! Updated " + self.name + " to: " + self.score;
//        }
//    } else {
//        write "Looking for ID: '" + clean_id + "' but not found.";
//        // ให้แสดงรายการที่มีอยู่ทั้งหมดในระบบเพื่อตรวจสอบ
//        write "Available players: " + (unity_player collect each.name);
//    }
//}





// เพิ่ม float x_val, float y_val เข้าไปใน parameter
//action receive_message (string id, string mes, string score_val, string name_val, float x_val, float y_val) {
//    
//    unity_player target_p <- first(unity_player where (lower_case(replace(each.name, " ", "")) = lower_case(replace(id, " ", ""))));
//    
//    if (target_p != nil) {
//        ask target_p {
//            self.score <- int(score_val);
////            self.name <- string(name_val);
//            // สั่งย้ายตำแหน่งตรงนี้
//            self.location <- {x_val, y_val}; 
//            
//            write "Moved " + self.name + " to " + self.location;
//        }
//    }
//}






//action receive_message (string id, string mes, string score_val, string name_val, float x_val, float y_val) {
//    
//    // ค้นหาโดยใช้ ID ดั้งเดิม (เช่น Unity_0, Unity_1)
//    unity_player target_p <- first(unity_player where (lower_case(replace(each.name, " ", "")) = lower_case(replace(id, " ", ""))));
//    
//    if (target_p != nil) {
//        ask target_p {
//        	
//        	self.last_update <- gama.machine_time; // ✅ สำคัญ: อัปเดตเวลาทุกครั้งที่ Unity ส่งพิกัดมา
//        	// ถ้าก่อนหน้านี้เป็นสีฟ้า (Offline) ให้กลับมาเป็นสีแดง (Online)
//            if (!self.is_online) {
//                self.is_online <- true;
//                self.color <- #red; // 🔴 กลับมาเป็นสีแดง
//                write "🌐 [ONLINE] " + self.name + " กลับมาเชื่อมต่อแล้ว!";
//            }
//            self.score <- int(score_val);
//            
//            // ใช้ display_name แทนการใช้ self.name เพื่อป้องกัน ID หาย
//            self.display_name <- name_val; 
//            
//            // สั่งย้ายตำแหน่ง
//            self.location <- {x_val, y_val}; 
//            
//            write "SUCCESS! Moved " + self.name + " (Display as: " + self.display_name + ") to " + self.location;
//        }
//    } else {
//        write "ERROR: ID '" + id + "' not found. Available: " + (unity_player collect each.name);
//    }
//}





action receive_message (string id, string mes, string score_val, string name_val, string bb, string gb, string rb, string yb) {
    string clean_id <- lower_case(replace(id, " ", ""));
    
    // พยายามหาตัวที่ ID ตรงกันก่อน
    unity_player target_p <- first(unity_player where (lower_case(replace(each.name, " ", "")) = clean_id));
    
    // ถ้าหาไม่เจอ (เช่นในเคส Player_85 ของคุณ) ให้เลือกเอเจนท์ตัวแรกที่มีในระบบมาใช้แทน
    if (target_p = nil and not empty(unity_player)) {
        target_p <- first(unity_player);
    }
//    action receive_message (string id, string mes) {
//		write "Player " + id + " send the message: " + mes + " hp: " + mes;
//	}
    if (target_p != nil) {
        ask target_p {
            self.last_update <- gama.machine_time;
            self.is_online <- true;
            
            // อัปเดตตำแหน่ง (ระบุพิกัด Z ให้ชัดเจนเพื่อให้ลอยเหนือพื้น)
//            self.location <- {x_val, y_val, 2.0}; 
            
            self.score <- int(score_val);
            self.display_name <- name_val;
            
          //  write "MATCHED: " + self.name + " moved to " + self.location;
        }
    }
}



//action receive_message (string id, string mes, string score_val, string name_val, float x_val, float y_val) {
//    
//    unity_player target_p <- first(unity_player where (lower_case(replace(each.name, " ", "")) = lower_case(replace(id, " ", ""))));
//    
//    if (target_p != nil) {
//        ask target_p {
//            self.last_update <- gama.machine_time; 
//            
//            if (!self.is_online) {
//                self.is_online <- true;
//                self.color <- #red;
//                write "🌐 [ONLINE] " + self.name + " กลับมาเชื่อมต่อแล้ว!";
//            }
//            
//            self.score <- int(score_val);
//            self.display_name <- name_val; 
//            
//            // --- แก้ไขการย้ายตำแหน่งตรงนี้ ---
//            // 1. ตรวจสอบว่า x_val และ y_val ไม่ใช่ 0 (เพื่อป้องกันการวาร์ปไปมุมแผนที่)
//            // 2. เพิ่มค่า z เพื่อให้เอเจนท์ลอยเหนือพื้นเสมอ
//            float final_z <- 2.0; // หรือใช้ z_offset ที่คุณตั้งไว้
//            self.location <- {x_val, y_val, final_z}; 
//            
//            // ใช้เพื่อ Debug: ถ้าตำแหน่งไม่ขยับ ให้ดูว่า x_val, y_val ที่ส่งมาคือเลขอะไร
//            // write "Moving to: " + self.location;
//        }
//    } else {
//        write "ERROR: ID '" + id + "' not found.";
//    }
//}








}


species unity_player parent: abstract_unity_player{
	float player_size <- 1.0;
	rgb color <- #red;
	//float cone_distance <- 5.0 * player_size;
	float cone_distance <- 4.0;
	float cone_amplitude <- 90.0;
	float player_rotation <- 90.0;
	
//	bool to_display <- false;
bool to_display <- true;
	// --- ระบบเช็คสถานะการเชื่อมต่อ ---
    float last_update <- gama.machine_time; // เก็บเวลาที่ได้รับข้อมูลล่าสุด
    bool is_online <- true;
//	float z_offset <- 2.0;
	
	int score <- 0; // <--- เพิ่มบรรทัดนี้
	string ip <- ""; // <--- เพิ่มบรรทัดนี้เพื่อเก็บค่า IP ของผู้เล่นแต่ละคน
	string display_name <- ""; // <--- เพิ่มบรรทัดนี้เพื่อเก็บชื่อที่จะแสดงผล
	aspect default {
		if to_display {
			if selected {
				 draw circle(player_size) at: location + {0, 0, z_offset} color: rgb(#blue, 0.5);
			}
			draw circle(player_size/2.0) at: location + {0, 0, z_offset} color: color ;
			draw player_perception_cone() color: rgb(color, 0.5);
		}
	}
	
	
//	aspect default {
//    // วาดวงกลมตามสถานะสี
//    draw circle(player_size/2.0) at: location + {0, 0, z_offset} color: color;
//    
//    // ✅ แก้ไขตรงนี้: ลบเครื่องหมาย : หลังคำว่า text
//    draw (display_name = "" ? name : display_name) at: location + {0, 0, z_offset + 1} size: 10 color: #black;
//}
	
	
	// Action นี้จะถูกเรียกอัตโนมัติเมื่อมี Player หลุดจาก Unity
 
	
	
	
	reflex debug_score {
        // ให้มันตะโกนบอกคะแนนตัวเองใน Console ทุกๆ step
         write name + " has score: " + score;
    }
    reflex check_connection {
        // ถ้าไม่มีข้อมูลส่งมาจาก Unity เกิน 3 วินาที (3000ms)
        if (gama.machine_time - last_update > 30000) {
            if (is_online) {
                is_online <- false;
                color <- #blue; // 🔵 เปลี่ยนเป็นสีฟ้าเมื่อหลุด
                write "🔌 [OFFLINE] " + name + " (Display: " + display_name + ") ข้อมูลขาดการติดต่อ";
            }
        }
    }

    reflex debug_score {
        // write name + " has score: " + score; // ปิดไว้ก่อนก็ได้ถ้ามันเยอะเกินไป
    }
}



//species unity_player parent: abstract_unity_player{
//	//allow to reduce the quantity of information sent to Unity - only the agents at a certain distance are sent
//	float player_agents_perception_radius <- 0.0;
//	
//	//allow to not send to Unity agents that are to close (i.e. overlapping) 
//	float player_agents_min_dist <- 0.0;
//	
//	float player_size <- 3.0;
//	rgb color <- #blue;
//	float cone_distance <- 10.0 * player_size;
//	float cone_amplitude <- 90.0;
//	float player_rotation <- 90.0;
//	bool to_display <- true;
//		int score <- 0; // <--- เพิ่มบรรทัดนี้
//	string ip <- ""; // <--- เพิ่มบรรทัดนี้เพื่อเก็บค่า IP ของผู้เล่นแต่ละคน
//	
// 
//	aspect default { 
//		if to_display {
//			if (selected) {
//				draw circle(player_size) at: location + {0, 0, 4.9} color: rgb(#blue, 0.5);
//			}
//			if file_exists("../images/headset.png")  {
//				draw image("../images/headset.png")  size: {player_size, player_size} at: location + {0, 0, 5} rotate: heading - 90;
//			
//			} else {
//				draw circle(player_size/2.0) at: location + {0, 0, 5} color: color ;
//			}
//			
//			draw player_perception_cone() color: rgb(#red, 0.5);
//		}			
//	}
//		reflex debug_score {
//        // ให้มันตะโกนบอกคะแนนตัวเองใน Console ทุกๆ step
//         write name + " has score: " + score;
//    }
//}





//experiment vr_xp parent:"Main" autorun: false type: unity {
//	float minimum_cycle_duration <- 0.1;
//	
//	string unity_linker_species <- string(unity_linker);
//	
//	list<string> displays_to_hide <- ["test","test"];
//	
//	float t_ref;
//
//	action create_player(string id) {
//		ask unity_linker {
//			do create_player(id);
//		}
//	}
//
//	action remove_player(string id_input) {
//		if (not empty(unity_player)) {
//			ask first(unity_player where (each.name = id_input)) {
//				do die;
//			}
//		}
//	}
//
//
//	output {
//		 display test_VR parent:test{
//			 species unity_player;
//			 event #mouse_down{
//				 float t <- gama.machine_time;
//				 if (t - t_ref) > 500 {
//					 ask unity_linker {
//						 move_player_event <- true;
//					 }
//					 t_ref <- t;
//				 }
//			 }
//		 }
//		 
//display point_player1 parent:test {
//    chart "Player Scores Comparison" type: histogram background: #white {
//        // แกน X = ชื่อผู้เล่น (list of strings)
//        // แกน Y = คะแนนของผู้เล่น (list of numbers)
//        datalist (unity_player collect each.name) 
//                 value: (unity_player collect each.score) 
//                 color: [#blue, #red, #green, #orange]; // ใส่สีแยกตามคนได้
//    }
//}		
//	}	
//	
//	
//}

















experiment vr_xp parent:"Main" autorun: false type: unity {
    float minimum_cycle_duration <- 0.1;
    string unity_linker_species <- string(unity_linker);
    list<string> displays_to_hide <- ["test", "test"];
    float t_ref;

    action create_player(string id) {
        ask unity_linker { do create_player(id); }
    }

    action remove_player(string id_input) {
        if (not empty(unity_player)) {
            ask first(unity_player where (each.name = id_input)) { do die; }
        }
    }

    output { 
        display test_VR parent: test {
            species unity_player;
            
            // ใช้คำสั่งดักจับเมาส์แบบดั้งเดิมที่เสถียรที่สุด
            event #mouse_down {
                float t <- gama.machine_time;
                if (t - t_ref) > 500 {
                    
                    // --- ลองใช้ #user_location แทน #event_location ---
                    point pos <- #user_location; 
                    
                    ask unity_linker {
                        move_player_event <- true;
                        write "GAMA: คลิกที่พิกัด " + pos + " ส่งสัญญาณไป Unity แล้ว";
                    }
                    t_ref <- t;
                }
            }
        }

//        display point_player1 parent: test {
//            chart "Player Scores Comparison" type: histogram background: #white {
//                datalist (unity_player collect each.name) 
//                         value: (unity_player collect each.score) 
//                         color: [#blue, #red, #green, #orange]; 
//            }





display point_player1 parent: test {
    chart "Player Scores Comparison" type: histogram background: #white {
        // ใช้ each.name แทน medical_id กรณีที่ display_name ยังว่างอยู่
        datalist (unity_player collect (each.display_name = "" ? each.name : each.display_name)) 
                 value: (unity_player collect each.score) 
                 color: [#blue, #red, #green, #orange]; 
    }
}


display bb parent: test {
    chart "Player Scores Comparison" type: histogram background: #white {
        // ใช้ each.name แทน medical_id กรณีที่ display_name ยังว่างอยู่
        datalist (unity_player collect (each.display_name = "" ? each.name : each.display_name)) 
                 value: (unity_player collect each.score) 
                 color: [#blue, #red, #green, #orange]; 
    }
}

	display "Datalist bar chart" type:2d {
			chart "Datalist bar chart" type:histogram 
			series_label_position: onchart
			{
				datalist legend:["cycle","cosinus normalized","offsetted cosinus normalized"] 
					style: bar
					value:[cycle,(sin(100*cycle) +  1) * cycle/2,(sin(100*(cycle+30)) + 1) * cycle/2] 
					color:[#green,#black,#purple];
			}
		}

display yb parent: test {
    chart "Player Scores Comparison" type: histogram background: #white {
        // ใช้ each.name แทน medical_id กรณีที่ display_name ยังว่างอยู่
        datalist (unity_player collect (each.display_name = "" ? each.name : each.display_name)) 
                 value: (unity_player collect each.score) 
                 color: [#blue, #red, #green, #orange]; 
    }
}


display gb parent: test {
    chart "Player Scores Comparison" type: histogram background: #white {
        // ใช้ each.name แทน medical_id กรณีที่ display_name ยังว่างอยู่
        datalist (unity_player collect (each.display_name = "" ? each.name : each.display_name)) 
                 value: (unity_player collect each.score) 
                 color: [#blue, #red, #green, #orange]; 
    }
}


display rb parent: test {
    chart "Player Scores Comparison" type: histogram background: #white {
        // ใช้ each.name แทน medical_id กรณีที่ display_name ยังว่างอยู่
        datalist (unity_player collect (each.display_name = "" ? each.name : each.display_name)) 
                 value: (unity_player collect each.score) 
                 color: [#blue, #red, #green, #orange]; 
    }
}

        
    } 
}