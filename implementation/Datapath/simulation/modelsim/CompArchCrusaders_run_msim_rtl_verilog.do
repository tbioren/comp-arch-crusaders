transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/biorentr/Projects/rhit-csse232-2324b-project-amber-2324b-01/implementation/Datapath {C:/Users/biorentr/Projects/rhit-csse232-2324b-project-amber-2324b-01/implementation/Datapath/ImmediateGenerator.v}

