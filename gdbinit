source ~/tools/pwn/pwndbg/gdbinit.py
source ~/tools/pwn/Pwngdb/pwngdb.py
source ~/tools/pwn/Pwngdb/angelheap/gdbinit.py

define hook-run
python
import angelheap
angelheap.init_angelheap()
end
end
