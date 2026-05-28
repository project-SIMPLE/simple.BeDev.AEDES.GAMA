///**
//* Name: button
//* Based on the internal empty template. 
//* Author: LEGION
//* Tags: 
//*/
//
//model button
//
//global {
//    // 1. เก็บตัวแปรสวิตช์ไว้ที่ global เพื่อให้เอเจนต์ดึงไปใช้ได้
//    bool is_switch_on <- false;
//
//    init {
//        create switch_agent number: 1;
//    }
//}
//
//species switch_agent {
//    rgb agent_color <- #red;
//    
//    reflex update_color {
//        if (is_switch_on) {
//            agent_color <- #green;
//        } else {
//            agent_color <- #red;
//        }
//    }
//
//    aspect default {
//        draw square(10) color: agent_color;
//    }
//}
//
//experiment main_experiment type: gui {
//    
//    // 2. [ถูกต้องตามกฎ] ประกาศ action ไว้ในตัว experiment โดยตรง ไม่ต้องมีอะไรครอบ
//    action turn_on_switch {
//        is_switch_on <- true;
//        write "Switch status: ON (Green)";
//    }
//    
//    action turn_off_switch {
//        is_switch_on <- false;
//        write "Switch status: OFF (Red)";
//    }
//    
//    action toggle_switch {
//        is_switch_on <- !is_switch_on;
//        write "Switch toggled. Current status is_on = " + is_switch_on;
//    }
//
//    // 3. [ถูกต้องตามกฎ] ตัวปุ่มกดจะวิ่งมาดึง action ด้านบนที่อยู่ใน experiment เดียวกันไปใช้
//    user_command "Turn ON Switch" action: turn_on_switch;
//    user_command "Turn OFF Switch" action: turn_off_switch;
//    user_command "Toggle Switch" action: toggle_switch;
//
//    output {
//        display main_display {
//            species switch_agent aspect: default;
//        }
//    }
//}







/**
* Name: SwitchButtonGUI
* Author: LEGION
* Description: โครงสร้างการทำปุ่ม Switch เปิด/ปิด เพื่อควบคุมการกรอกข้อมูลชิ้นอื่น
* Tags: experiment, GUI, parameter, enable
*/

//model SimpleSwitchTest
//
//global {
//    // 1. สวิตช์หลัก (เปิด/ปิด)
//    bool run_test <- false;
//    
//    // 2. ตัวแปรที่จะถูกควบคุม (จะเปิดให้กดเมื่อสวิตช์ข้างบนถูกติ๊ก)
//    int test_value <- 50;
//}
//
//experiment "Test Switch" type: gui {
//    
//    // ปุ่มสวิตช์หลัก: ทำหน้าที่เปิด (enables) ตัวแปรชื่อ test_value
//    parameter "เปิดระบบทดสอบ (Switch)" var: run_test enables: [test_value];
//    
//    // ช่องกรอกข้อมูลที่จะโดนล็อก/ปลดล็อก
//    parameter "ค่าทดสอบ (จะปลดล็อกเมื่อเปิด Switch)" var: test_value;
//
//}






//model StartStopTest
//
//global {
//    // 1. ตัวแปรสวิตช์ (เริ่มต้นเป็น false คือ Stop)
//    bool start_simulation <- false;
//}
//
//species mosquito {
//    // สร้างพฤติกรรมการทำงานของเอเจนต์
//    // เงื่อนไข: จะทำงาน (Start) ก็ต่อเมื่อตัวแปร start_simulation เป็น true เท่านั้น
//    reflex move when: start_simulation {
//        write "ยุงกำลังบินขยับเขยื้อน... (Start)";
//    }
//}
//
//experiment "Start Stop Test" type: gui {
//    
//    // 2. ปุ่มพารามิเตอร์หน้าจอ ติ๊กถูก = Start, เอาติ๊กออก = Stop
//    parameter "สถานะระบบ (Start/Stop)" var: start_simulation;
//    
//    output {
//        display "Main_Window" {
//            species mosquito;
//        }
//    }
//}






//model StartStopLabelsTest
//
//global {
//    // ตัวแปรเก็บค่าลอจิกปกติ (true/false)
//    bool start_simulation <- false;
//}
//
//experiment "Start Stop Test" type: gui {
//    
//    // เปลี่ยนคำบนปุ่ม Switch ด้วย facet -> labels
//    parameter "สถานะระบบ" 
//        var: start_simulation 
//        labels: ["Start", "Stop"]; 
//        
//}









//model CountdownTimerTest
//
//global {
//    // 1. สวิตช์หลักสำหรับ Start / Stop
//    bool start_simulation <- false;
//    
//    // 2. ตั้งค่าเวลานับถอยหลัง (5 นาที = 300 วินาที)
//    int total_seconds <- 300;
//    
//    // ตัวแปรสำหรับแปลงค่าไปแสดงผลในหน้าจอ (ข้อความบอกเวลา)
//    string time_display <- "05:00";
//
//    // ฟังก์ชันทำงานทุกๆ Step (วินาที) ของโมเดล
//    reflex countdown_logic when: start_simulation {
//        
//        if (total_seconds > 0) {
//            // ลดเวลาลงทีละ 1 วินาที
//            total_seconds <- total_seconds - 1;
//            
//            // คำนวณหานาทีและวินาทีเพื่อจัดฟอร์แมตข้อความ (เช่น 04:59)
//            int minutes <- total_seconds div 60;
//            int seconds <- total_seconds mod 60;
//            
//            // เติมเลข 0 ข้างหน้าหากหลักหน่วยเหลือน้อยกว่า 10 เพื่อความสวยงาม
//            string min_str <- (minutes < 10) ? "0" + string(minutes) : string(minutes);
//            string sec_str <- (seconds < 10) ? "0" + string(seconds) : string(seconds);
//            
//            time_display <- min_str + ":" + sec_str;
//        } else {
//            // เมื่อเวลาหมด (เหลือ 0) ให้หยุดระบบอัตโนมัติ และแจ้งเตือน
//            start_simulation <- false;
//            time_display <- "TIME OUT!";
//            write "หมดเวลา 5 นาทีแล้ว!";
//        }
//    }
//}
//
//experiment "Start Stop Test" type: gui {
//    
//    // ตัวสวิตช์ควบคุมระบบ
//    parameter "สถานะระบบ" 
//        var: start_simulation 
//        labels: ["Start", "Stop"]; 
//        
//    output {
//        // สร้างหน้าจอ Display สำหรับแสดงผลตัวนับเวลาโดยเฉพาะ
//        display "Timer Display" background: #black {
//            
//            // ใช้ graphics เพื่อเขียนข้อความหรือวาดรูปทรงลงบนหน้าจอตามต้องการ
//            graphics "Time Text" {
//                
//                // วาดข้อความบอกเวลาไว้ตรงกลางหน้าจอ (พิกัด x: 35, y: 45) เปลี่ยนสีตามสถานะ
//                rgb text_color <- start_simulation ? #green : #red;
//                
//                if(time_display = "TIME OUT!") { text_color <- #orange; }
//                
//                draw time_display 
//                    at: {30, 50} 
//                    color: text_color 
//                    font: font("Arial", 40, #bold);
//                    
//                // วาดคำอธิบายเพิ่มเติมตัวเล็กๆ ด้านบน
//                draw "COUNTDOWN TIMER" 
//                    at: {32, 30} 
//                    color: #white 
//                    font: font("Arial", 14, #plain);
//            }
//        }
//    }
//}










//model CountdownTimerWithPermanentLog
//
//global {
//    bool start_simulation <- false;
//    int total_seconds <- 300;
//    string time_display <- "05:00";
//
//    init {
//        // พิมพ์บอกค่าตั้งแต่เปิดโมเดลขึ้นมาครั้งแรก (ยังไม่ได้กด Start)
//        write "== [System Ready] โมเดลถูกสร้างสำเร็จ ==";
//        write "-> [Initial Log] ค่า Duration ต่อรอบเริ่มต้น (step) = " + string(step) + " s";
//    }
//
//    reflex countdown_logic when: start_simulation {
//        if (total_seconds > 0) {
//            total_seconds <- total_seconds - 1;
//            
//            int minutes <- total_seconds div 60;
//            int seconds <- total_seconds mod 60;
//            
//            string min_str <- (minutes < 10) ? "0" + string(minutes) : string(minutes);
//            string sec_str <- (seconds < 10) ? "0" + string(seconds) : string(seconds);
//            
//            time_display <- min_str + ":" + sec_str;
//        } else {
//            start_simulation <- false;
//            time_display <- "TIME OUT!";
//            write "== [Log] หมดเวลา 5 นาทีแล้ว! ==";
//        }
//    }
//}
//
//experiment "Start Stop Test" type: gui {
//    
//    // สร้างตัวแปรแอบจับเวลาภายในระดับหน้าต่าง GUI 
//    float last_time_check <- 0.0;
//    float live_duration <- 0.0;
//
//    parameter "สถานะระบบ" 
//        var: start_simulation 
//        labels: ["Start", "Stop"]; 
//        
//    output {
//        display "Timer Display" background: #black {
//            
//            // ใช้ความสามารถของหน้าจอ (Display) ในการกระตุ้นให้โค้ดส่วนนี้ทำงานตลอดเวลาแม้จะกด Pause
//            graphics "Time Text" {
//                
//                // คำนวณหาค่าเวลาที่เปลี่ยนไปของตัวหน้าจอ UI เอง (ล้อตามสไลเดอร์ความเร็ว)
//                float current_time <- float(gama.machine_time);
//                if (last_time_check > 0.0) {
//                    live_duration <- (current_time - last_time_check) / 1000.0;
//                }
//                last_time_check <- current_time;
//
//                rgb text_color <- start_simulation ? #green : #red;
//                if(time_display = "TIME OUT!") { text_color <- #orange; }
//                
//                // วาดตัวนับเวลา 5 นาทีหลัก
//                draw time_display at: {30, 50} color: text_color font: font("Arial", 40, #bold);
//                draw "COUNTDOWN TIMER" at: {32, 30} color: #white font: font("Arial", 14, #plain);
//            }
//        }
//        
//        // ดึงค่า live_duration ที่หน้าจอคำนวณเสร็จเรียบร้อยไปแสดงในกล่องมอนิเตอร์สีเหลือง
//        // ค่านี้จะวิ่งปรับตามความเร็วของสไลเดอร์ที่คุณเลื่อนทันทีอย่างแม่นยำ
//        monitor "สปีด Duration สไลเดอร์ (Real-time)" value: (live_duration = 0.0 ? 1.0 : live_duration) color: #yellow;
//    }
//}










//model RealTimeCountdown
//
//global {
//    // 1. สวิตช์หลักสำหรับ Start / Stop
//    bool start_simulation <- false;
//    
//    // ตัวแปรควบคุมเวลาจริง (หน่วยเป็นมิลลิวินาที)
//    float start_machine_time <- 0.0;
//    int total_duration_ms <- 5 * 60 * 1000; // 5 นาทีแปลงเป็นมิลลิวินาที (300,000 ms)
//    int remaining_ms <- 300000;
//    
//    // ตัวแปรข้อความแสดงผลบนหน้าจอ
//    string time_display <- "05:00";
//    
//    // ตัวแปรสถานะเอาไว้เช็คจังหวะที่เริ่มกดปุ่มครั้งแรก
//    bool is_timer_initialized <- false;
//
//    reflex real_time_countdown_logic {
//        
//        // กรณีที่ผู้ใช้กดสวิตช์เป็น Start (True)
//        if (start_simulation) {
//            
//            // จังหวะแรกที่กด Start: ปักหมุดเวลาปัจจุบันของเครื่องคอมพิวเตอร์เอาไว้
//            if (!is_timer_initialized) {
//                // คำนวณหาเวลาเครื่อง ณ วินาทีนี้ (มิลลิวินาทีสากลนับจากเริ่มรันโมเดล)
//                start_machine_time <- gama.machine_time;
//                is_timer_initialized <- true;
//            }
//            
//            // คำนวณเวลาที่ผ่านไปจริงนับจากจุดปักหมุด
//            float time_passed <- gama.machine_time - start_machine_time;
//            
//            // เวลาที่เหลือจริง = เวลาคงเหลือเดิมก่อนกดรัน - เวลาที่รันผ่านไปแล้ว
//            float calculated_remaining <- remaining_ms - time_passed;
//            
//            if (calculated_remaining > 0) {
//                int total_seconds_left <- int(calculated_remaining / 1000);
//                int minutes <- total_seconds_left div 60;
//                int seconds <- total_seconds_left mod 60;
//                
//                string min_str <- (minutes < 10) ? "0" + string(minutes) : string(minutes);
//                string sec_str <- (seconds < 10) ? "0" + string(seconds) : string(seconds);
//                
//                time_display <- min_str + ":" + sec_str;
//            } else {
//                // เมื่อเวลาหมด 5 นาทีจริง
//                start_simulation <- false;
//                is_timer_initialized <- false;
//                remaining_ms <- 0;
//                time_display <- "TIME OUT!";
//                write "== หมดเวลา 5 นาทีบนโลกจริงแล้ว! ==";
//            }
//            
//        } else {
//            // กรณีที่ผู้ใช้กด Stop (False) หรือกด Pause ไว้
//            // เซฟเวลาที่เหลือคาเอาไว้ก่อน เพื่อให้เวลากด Start ใหม่มันจะนับต่อจากเดิมได้ ไม่รีเซ็ต
//            if (is_timer_initialized) {
//                float time_passed <- gama.machine_time - start_machine_time;
//                remaining_ms <- int(remaining_ms - time_passed);
//                is_timer_initialized <- false; // ปลดล็อกเพื่อให้ปักหมุดใหม่รอบหน้า
//            }
//        }
//    }
//}
//
//experiment "Real Time Test" type: gui {
//    
//    parameter "สถานะระบบ" 
//        var: start_simulation 
//        labels: ["Start", "Stop"]; 
//        
//    output {
//        display "Timer Display" background: #black {
//            graphics "Time Text" {
//                rgb text_color <- start_simulation ? #green : #red;
//                if(time_display = "TIME OUT!") { text_color <- #orange; }
//                
//                draw time_display at: {30, 50} color: text_color font: font("Arial", 40, #bold);
//                draw "REAL-WORLD TIMER (5 MIN)" at: {20, 30} color: #white font: font("Arial", 14, #plain);
//            }
//        }
//    }
//}










model FuturisticTimerCentered

global {
    bool start_simulation <- false;
    float total_duration_ms <- 5 * 60 * 1000.0; 
    float remaining_ms <- 300000.0;
    float start_machine_time <- 0.0;
    bool is_timer_initialized <- false;
    string time_display <- "05:00";
    float progress_val <- 1.0;

    reflex update_timer {
        if (start_simulation) {
            if (!is_timer_initialized) {
                start_machine_time <- gama.machine_time;
                is_timer_initialized <- true;
            }
            float time_passed <- gama.machine_time - start_machine_time;
            float calculated_remaining <- remaining_ms - time_passed;
            
            if (calculated_remaining > 0) {
                progress_val <- calculated_remaining / total_duration_ms;
                int total_seconds_left <- int(calculated_remaining / 1000);
                
                // จัดรูปแบบตัวเลข 00:00
                int m <- total_seconds_left div 60;
                int s <- total_seconds_left mod 60;
                string ms <- (m < 10) ? "0" + string(m) : string(m);
                string ss <- (s < 10) ? "0" + string(s) : string(s);
                time_display <- ms + ":" + ss;
            } else {
                start_simulation <- false;
                progress_val <- 0.0;
                time_display <- "00:00";
            }
        } else if (is_timer_initialized) {
            remaining_ms <- remaining_ms - (gama.machine_time - start_machine_time);
            is_timer_initialized <- false;
        }
    }
}

experiment "Dashboard UI" type: gui {
    parameter "SYSTEM STATUS" var: start_simulation labels: ["START", "STOP"];

    output {
        display "Futuristic Display" background: #black {
            graphics "HUD Layer" {
                // กำหนดพิกัดกึ่งกลางหน้าจอ
                point center_pt <- {50, 50};
                float ring_radius <- 20.0; 
                
                // 1. วาดวงแหวนพื้นหลัง (Static Ring)
                draw circle(ring_radius) at: center_pt color: #transparent border: #darkgray width: 2.0;
                
                // 2. คำนวณสีและมุมของวงแหวนตามเวลาที่เหลือ
                rgb active_color <- #cyan;
                if (progress_val < 0.2) { active_color <- #red; }
                
                float end_angle <- -90.0 + (360.0 * progress_val);
                
                // 3. วาดวงแหวนที่เคลื่อนที่ (Progress Arc)
                draw arc(ring_radius, -90.0, end_angle) at: center_pt color: #transparent border: active_color width: 6.0;

                // 4. วาดตัวเลขเวลา (Timer Text) - ใช้ anchor: #center เพื่อให้อยู่กลางวงกลมพอดี
                draw time_display at: center_pt color: active_color font: font("Arial", 250, #bold) anchor: #center;
                
                // 5. วาดสถานะ Active/Paused ด้านล่าง
                string status_txt <- "PAUSED";
                rgb status_col <- #gray;
                if (start_simulation) {
                    status_txt <- "ACTIVE";
                    status_col <- #green;
                }
                draw status_txt at: {50, 65} color: status_col font: font("Arial", 50, #bold) anchor: #center;
                
                // 6. วาดหัวข้อด้านบน
                draw "REAL-WORLD TIMER (5 MIN)" at: {50, 25} color: #white font: font("Arial", 10) anchor: #center;
            }
        }
    }
}