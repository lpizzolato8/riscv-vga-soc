create_project riscv_vga_soc ./vivado_project -part xc7a35tcpg236-1 -force

add_files -fileset sources_1 [glob -nocomplain ./rtl/*.v ./rtl/core/*.v ./rtl/bus/*.v ./rtl/peripherals/*.v ./rtl/video/*.v]
add_files -fileset sim_1 [glob -nocomplain ./tb/*.v]
add_files -fileset constrs_1 [glob -nocomplain ./constraints/*.xdc]

set_property top soc_top [current_fileset]

puts "Done. Open vivado_project/riscv_vga_soc.xpr"