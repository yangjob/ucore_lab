
bin/kernel：     文件格式 elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
c0100000:	0f 01 15 18 70 11 00 	lgdtl  0x117018
    movl $KERNEL_DS, %eax
c0100007:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c010000c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c010000e:	8e c0                	mov    %eax,%es
    movw %ax, %ss
c0100010:	8e d0                	mov    %eax,%ss

    ljmp $KERNEL_CS, $relocated
c0100012:	ea 19 00 10 c0 08 00 	ljmp   $0x8,$0xc0100019

c0100019 <relocated>:

relocated:

    # set ebp, esp
    movl $0x0, %ebp
c0100019:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010001e:	bc 00 70 11 c0       	mov    $0xc0117000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
c0100023:	e8 02 00 00 00       	call   c010002a <kern_init>

c0100028 <spin>:

# should never get here
spin:
    jmp spin
c0100028:	eb fe                	jmp    c0100028 <spin>

c010002a <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
c010002a:	55                   	push   %ebp
c010002b:	89 e5                	mov    %esp,%ebp
c010002d:	83 ec 18             	sub    $0x18,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c0100030:	ba 68 89 11 c0       	mov    $0xc0118968,%edx
c0100035:	b8 36 7a 11 c0       	mov    $0xc0117a36,%eax
c010003a:	29 c2                	sub    %eax,%edx
c010003c:	89 d0                	mov    %edx,%eax
c010003e:	83 ec 04             	sub    $0x4,%esp
c0100041:	50                   	push   %eax
c0100042:	6a 00                	push   $0x0
c0100044:	68 36 7a 11 c0       	push   $0xc0117a36
c0100049:	e8 6a 52 00 00       	call   c01052b8 <memset>
c010004e:	83 c4 10             	add    $0x10,%esp

    cons_init();                // init the console
c0100051:	e8 48 15 00 00       	call   c010159e <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c0100056:	c7 45 f4 60 5a 10 c0 	movl   $0xc0105a60,-0xc(%ebp)
    cprintf("%s\n\n", message);
c010005d:	83 ec 08             	sub    $0x8,%esp
c0100060:	ff 75 f4             	pushl  -0xc(%ebp)
c0100063:	68 7c 5a 10 c0       	push   $0xc0105a7c
c0100068:	e8 fa 01 00 00       	call   c0100267 <cprintf>
c010006d:	83 c4 10             	add    $0x10,%esp

    print_kerninfo();
c0100070:	e8 7c 08 00 00       	call   c01008f1 <print_kerninfo>

    grade_backtrace();
c0100075:	e8 74 00 00 00       	call   c01000ee <grade_backtrace>

    pmm_init();                 // init physical memory management
c010007a:	e8 ea 30 00 00       	call   c0103169 <pmm_init>

    pic_init();                 // init interrupt controller
c010007f:	e8 8c 16 00 00       	call   c0101710 <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100084:	e8 ed 17 00 00       	call   c0101876 <idt_init>

    clock_init();               // init clock interrupt
c0100089:	e8 b7 0c 00 00       	call   c0100d45 <clock_init>
    intr_enable();              // enable irq interrupt
c010008e:	e8 ba 17 00 00       	call   c010184d <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c0100093:	eb fe                	jmp    c0100093 <kern_init+0x69>

c0100095 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c0100095:	55                   	push   %ebp
c0100096:	89 e5                	mov    %esp,%ebp
c0100098:	83 ec 08             	sub    $0x8,%esp
    mon_backtrace(0, NULL, NULL);
c010009b:	83 ec 04             	sub    $0x4,%esp
c010009e:	6a 00                	push   $0x0
c01000a0:	6a 00                	push   $0x0
c01000a2:	6a 00                	push   $0x0
c01000a4:	e8 8a 0c 00 00       	call   c0100d33 <mon_backtrace>
c01000a9:	83 c4 10             	add    $0x10,%esp
}
c01000ac:	90                   	nop
c01000ad:	c9                   	leave  
c01000ae:	c3                   	ret    

c01000af <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000af:	55                   	push   %ebp
c01000b0:	89 e5                	mov    %esp,%ebp
c01000b2:	53                   	push   %ebx
c01000b3:	83 ec 04             	sub    $0x4,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000b6:	8d 4d 0c             	lea    0xc(%ebp),%ecx
c01000b9:	8b 55 0c             	mov    0xc(%ebp),%edx
c01000bc:	8d 5d 08             	lea    0x8(%ebp),%ebx
c01000bf:	8b 45 08             	mov    0x8(%ebp),%eax
c01000c2:	51                   	push   %ecx
c01000c3:	52                   	push   %edx
c01000c4:	53                   	push   %ebx
c01000c5:	50                   	push   %eax
c01000c6:	e8 ca ff ff ff       	call   c0100095 <grade_backtrace2>
c01000cb:	83 c4 10             	add    $0x10,%esp
}
c01000ce:	90                   	nop
c01000cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01000d2:	c9                   	leave  
c01000d3:	c3                   	ret    

c01000d4 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c01000d4:	55                   	push   %ebp
c01000d5:	89 e5                	mov    %esp,%ebp
c01000d7:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace1(arg0, arg2);
c01000da:	83 ec 08             	sub    $0x8,%esp
c01000dd:	ff 75 10             	pushl  0x10(%ebp)
c01000e0:	ff 75 08             	pushl  0x8(%ebp)
c01000e3:	e8 c7 ff ff ff       	call   c01000af <grade_backtrace1>
c01000e8:	83 c4 10             	add    $0x10,%esp
}
c01000eb:	90                   	nop
c01000ec:	c9                   	leave  
c01000ed:	c3                   	ret    

c01000ee <grade_backtrace>:

void
grade_backtrace(void) {
c01000ee:	55                   	push   %ebp
c01000ef:	89 e5                	mov    %esp,%ebp
c01000f1:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c01000f4:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c01000f9:	83 ec 04             	sub    $0x4,%esp
c01000fc:	68 00 00 ff ff       	push   $0xffff0000
c0100101:	50                   	push   %eax
c0100102:	6a 00                	push   $0x0
c0100104:	e8 cb ff ff ff       	call   c01000d4 <grade_backtrace0>
c0100109:	83 c4 10             	add    $0x10,%esp
}
c010010c:	90                   	nop
c010010d:	c9                   	leave  
c010010e:	c3                   	ret    

c010010f <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c010010f:	55                   	push   %ebp
c0100110:	89 e5                	mov    %esp,%ebp
c0100112:	83 ec 18             	sub    $0x18,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c0100115:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c0100118:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c010011b:	8c 45 f2             	mov    %es,-0xe(%ebp)
c010011e:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c0100121:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100125:	0f b7 c0             	movzwl %ax,%eax
c0100128:	83 e0 03             	and    $0x3,%eax
c010012b:	89 c2                	mov    %eax,%edx
c010012d:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c0100132:	83 ec 04             	sub    $0x4,%esp
c0100135:	52                   	push   %edx
c0100136:	50                   	push   %eax
c0100137:	68 81 5a 10 c0       	push   $0xc0105a81
c010013c:	e8 26 01 00 00       	call   c0100267 <cprintf>
c0100141:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  cs = %x\n", round, reg1);
c0100144:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100148:	0f b7 d0             	movzwl %ax,%edx
c010014b:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c0100150:	83 ec 04             	sub    $0x4,%esp
c0100153:	52                   	push   %edx
c0100154:	50                   	push   %eax
c0100155:	68 8f 5a 10 c0       	push   $0xc0105a8f
c010015a:	e8 08 01 00 00       	call   c0100267 <cprintf>
c010015f:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ds = %x\n", round, reg2);
c0100162:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0100166:	0f b7 d0             	movzwl %ax,%edx
c0100169:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c010016e:	83 ec 04             	sub    $0x4,%esp
c0100171:	52                   	push   %edx
c0100172:	50                   	push   %eax
c0100173:	68 9d 5a 10 c0       	push   $0xc0105a9d
c0100178:	e8 ea 00 00 00       	call   c0100267 <cprintf>
c010017d:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  es = %x\n", round, reg3);
c0100180:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100184:	0f b7 d0             	movzwl %ax,%edx
c0100187:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c010018c:	83 ec 04             	sub    $0x4,%esp
c010018f:	52                   	push   %edx
c0100190:	50                   	push   %eax
c0100191:	68 ab 5a 10 c0       	push   $0xc0105aab
c0100196:	e8 cc 00 00 00       	call   c0100267 <cprintf>
c010019b:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ss = %x\n", round, reg4);
c010019e:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001a2:	0f b7 d0             	movzwl %ax,%edx
c01001a5:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001aa:	83 ec 04             	sub    $0x4,%esp
c01001ad:	52                   	push   %edx
c01001ae:	50                   	push   %eax
c01001af:	68 b9 5a 10 c0       	push   $0xc0105ab9
c01001b4:	e8 ae 00 00 00       	call   c0100267 <cprintf>
c01001b9:	83 c4 10             	add    $0x10,%esp
    round ++;
c01001bc:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001c1:	83 c0 01             	add    $0x1,%eax
c01001c4:	a3 40 7a 11 c0       	mov    %eax,0xc0117a40
}
c01001c9:	90                   	nop
c01001ca:	c9                   	leave  
c01001cb:	c3                   	ret    

c01001cc <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c01001cc:	55                   	push   %ebp
c01001cd:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
c01001cf:	90                   	nop
c01001d0:	5d                   	pop    %ebp
c01001d1:	c3                   	ret    

c01001d2 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c01001d2:	55                   	push   %ebp
c01001d3:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
c01001d5:	90                   	nop
c01001d6:	5d                   	pop    %ebp
c01001d7:	c3                   	ret    

c01001d8 <lab1_switch_test>:

static void
lab1_switch_test(void) {
c01001d8:	55                   	push   %ebp
c01001d9:	89 e5                	mov    %esp,%ebp
c01001db:	83 ec 08             	sub    $0x8,%esp
    lab1_print_cur_status();
c01001de:	e8 2c ff ff ff       	call   c010010f <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c01001e3:	83 ec 0c             	sub    $0xc,%esp
c01001e6:	68 c8 5a 10 c0       	push   $0xc0105ac8
c01001eb:	e8 77 00 00 00       	call   c0100267 <cprintf>
c01001f0:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_user();
c01001f3:	e8 d4 ff ff ff       	call   c01001cc <lab1_switch_to_user>
    lab1_print_cur_status();
c01001f8:	e8 12 ff ff ff       	call   c010010f <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c01001fd:	83 ec 0c             	sub    $0xc,%esp
c0100200:	68 e8 5a 10 c0       	push   $0xc0105ae8
c0100205:	e8 5d 00 00 00       	call   c0100267 <cprintf>
c010020a:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_kernel();
c010020d:	e8 c0 ff ff ff       	call   c01001d2 <lab1_switch_to_kernel>
    lab1_print_cur_status();
c0100212:	e8 f8 fe ff ff       	call   c010010f <lab1_print_cur_status>
}
c0100217:	90                   	nop
c0100218:	c9                   	leave  
c0100219:	c3                   	ret    

c010021a <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c010021a:	55                   	push   %ebp
c010021b:	89 e5                	mov    %esp,%ebp
c010021d:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
c0100220:	83 ec 0c             	sub    $0xc,%esp
c0100223:	ff 75 08             	pushl  0x8(%ebp)
c0100226:	e8 a4 13 00 00       	call   c01015cf <cons_putc>
c010022b:	83 c4 10             	add    $0x10,%esp
    (*cnt) ++;
c010022e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100231:	8b 00                	mov    (%eax),%eax
c0100233:	8d 50 01             	lea    0x1(%eax),%edx
c0100236:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100239:	89 10                	mov    %edx,(%eax)
}
c010023b:	90                   	nop
c010023c:	c9                   	leave  
c010023d:	c3                   	ret    

c010023e <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c010023e:	55                   	push   %ebp
c010023f:	89 e5                	mov    %esp,%ebp
c0100241:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
c0100244:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c010024b:	ff 75 0c             	pushl  0xc(%ebp)
c010024e:	ff 75 08             	pushl  0x8(%ebp)
c0100251:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0100254:	50                   	push   %eax
c0100255:	68 1a 02 10 c0       	push   $0xc010021a
c010025a:	e8 8f 53 00 00       	call   c01055ee <vprintfmt>
c010025f:	83 c4 10             	add    $0x10,%esp
    return cnt;
c0100262:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100265:	c9                   	leave  
c0100266:	c3                   	ret    

c0100267 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c0100267:	55                   	push   %ebp
c0100268:	89 e5                	mov    %esp,%ebp
c010026a:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c010026d:	8d 45 0c             	lea    0xc(%ebp),%eax
c0100270:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c0100273:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100276:	83 ec 08             	sub    $0x8,%esp
c0100279:	50                   	push   %eax
c010027a:	ff 75 08             	pushl  0x8(%ebp)
c010027d:	e8 bc ff ff ff       	call   c010023e <vcprintf>
c0100282:	83 c4 10             	add    $0x10,%esp
c0100285:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0100288:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010028b:	c9                   	leave  
c010028c:	c3                   	ret    

c010028d <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c010028d:	55                   	push   %ebp
c010028e:	89 e5                	mov    %esp,%ebp
c0100290:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
c0100293:	83 ec 0c             	sub    $0xc,%esp
c0100296:	ff 75 08             	pushl  0x8(%ebp)
c0100299:	e8 31 13 00 00       	call   c01015cf <cons_putc>
c010029e:	83 c4 10             	add    $0x10,%esp
}
c01002a1:	90                   	nop
c01002a2:	c9                   	leave  
c01002a3:	c3                   	ret    

c01002a4 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c01002a4:	55                   	push   %ebp
c01002a5:	89 e5                	mov    %esp,%ebp
c01002a7:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
c01002aa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c01002b1:	eb 14                	jmp    c01002c7 <cputs+0x23>
        cputch(c, &cnt);
c01002b3:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c01002b7:	83 ec 08             	sub    $0x8,%esp
c01002ba:	8d 55 f0             	lea    -0x10(%ebp),%edx
c01002bd:	52                   	push   %edx
c01002be:	50                   	push   %eax
c01002bf:	e8 56 ff ff ff       	call   c010021a <cputch>
c01002c4:	83 c4 10             	add    $0x10,%esp
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
c01002c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01002ca:	8d 50 01             	lea    0x1(%eax),%edx
c01002cd:	89 55 08             	mov    %edx,0x8(%ebp)
c01002d0:	0f b6 00             	movzbl (%eax),%eax
c01002d3:	88 45 f7             	mov    %al,-0x9(%ebp)
c01002d6:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01002da:	75 d7                	jne    c01002b3 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
c01002dc:	83 ec 08             	sub    $0x8,%esp
c01002df:	8d 45 f0             	lea    -0x10(%ebp),%eax
c01002e2:	50                   	push   %eax
c01002e3:	6a 0a                	push   $0xa
c01002e5:	e8 30 ff ff ff       	call   c010021a <cputch>
c01002ea:	83 c4 10             	add    $0x10,%esp
    return cnt;
c01002ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01002f0:	c9                   	leave  
c01002f1:	c3                   	ret    

c01002f2 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c01002f2:	55                   	push   %ebp
c01002f3:	89 e5                	mov    %esp,%ebp
c01002f5:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c01002f8:	e8 1b 13 00 00       	call   c0101618 <cons_getc>
c01002fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100300:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100304:	74 f2                	je     c01002f8 <getchar+0x6>
        /* do nothing */;
    return c;
c0100306:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100309:	c9                   	leave  
c010030a:	c3                   	ret    

c010030b <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c010030b:	55                   	push   %ebp
c010030c:	89 e5                	mov    %esp,%ebp
c010030e:	83 ec 18             	sub    $0x18,%esp
    if (prompt != NULL) {
c0100311:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100315:	74 13                	je     c010032a <readline+0x1f>
        cprintf("%s", prompt);
c0100317:	83 ec 08             	sub    $0x8,%esp
c010031a:	ff 75 08             	pushl  0x8(%ebp)
c010031d:	68 07 5b 10 c0       	push   $0xc0105b07
c0100322:	e8 40 ff ff ff       	call   c0100267 <cprintf>
c0100327:	83 c4 10             	add    $0x10,%esp
    }
    int i = 0, c;
c010032a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100331:	e8 bc ff ff ff       	call   c01002f2 <getchar>
c0100336:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c0100339:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010033d:	79 0a                	jns    c0100349 <readline+0x3e>
            return NULL;
c010033f:	b8 00 00 00 00       	mov    $0x0,%eax
c0100344:	e9 82 00 00 00       	jmp    c01003cb <readline+0xc0>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c0100349:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c010034d:	7e 2b                	jle    c010037a <readline+0x6f>
c010034f:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c0100356:	7f 22                	jg     c010037a <readline+0x6f>
            cputchar(c);
c0100358:	83 ec 0c             	sub    $0xc,%esp
c010035b:	ff 75 f0             	pushl  -0x10(%ebp)
c010035e:	e8 2a ff ff ff       	call   c010028d <cputchar>
c0100363:	83 c4 10             	add    $0x10,%esp
            buf[i ++] = c;
c0100366:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100369:	8d 50 01             	lea    0x1(%eax),%edx
c010036c:	89 55 f4             	mov    %edx,-0xc(%ebp)
c010036f:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100372:	88 90 60 7a 11 c0    	mov    %dl,-0x3fee85a0(%eax)
c0100378:	eb 4c                	jmp    c01003c6 <readline+0xbb>
        }
        else if (c == '\b' && i > 0) {
c010037a:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c010037e:	75 1a                	jne    c010039a <readline+0x8f>
c0100380:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100384:	7e 14                	jle    c010039a <readline+0x8f>
            cputchar(c);
c0100386:	83 ec 0c             	sub    $0xc,%esp
c0100389:	ff 75 f0             	pushl  -0x10(%ebp)
c010038c:	e8 fc fe ff ff       	call   c010028d <cputchar>
c0100391:	83 c4 10             	add    $0x10,%esp
            i --;
c0100394:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0100398:	eb 2c                	jmp    c01003c6 <readline+0xbb>
        }
        else if (c == '\n' || c == '\r') {
c010039a:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c010039e:	74 06                	je     c01003a6 <readline+0x9b>
c01003a0:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01003a4:	75 8b                	jne    c0100331 <readline+0x26>
            cputchar(c);
c01003a6:	83 ec 0c             	sub    $0xc,%esp
c01003a9:	ff 75 f0             	pushl  -0x10(%ebp)
c01003ac:	e8 dc fe ff ff       	call   c010028d <cputchar>
c01003b1:	83 c4 10             	add    $0x10,%esp
            buf[i] = '\0';
c01003b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01003b7:	05 60 7a 11 c0       	add    $0xc0117a60,%eax
c01003bc:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01003bf:	b8 60 7a 11 c0       	mov    $0xc0117a60,%eax
c01003c4:	eb 05                	jmp    c01003cb <readline+0xc0>
        }
    }
c01003c6:	e9 66 ff ff ff       	jmp    c0100331 <readline+0x26>
}
c01003cb:	c9                   	leave  
c01003cc:	c3                   	ret    

c01003cd <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c01003cd:	55                   	push   %ebp
c01003ce:	89 e5                	mov    %esp,%ebp
c01003d0:	83 ec 18             	sub    $0x18,%esp
    if (is_panic) {
c01003d3:	a1 60 7e 11 c0       	mov    0xc0117e60,%eax
c01003d8:	85 c0                	test   %eax,%eax
c01003da:	75 4a                	jne    c0100426 <__panic+0x59>
        goto panic_dead;
    }
    is_panic = 1;
c01003dc:	c7 05 60 7e 11 c0 01 	movl   $0x1,0xc0117e60
c01003e3:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c01003e6:	8d 45 14             	lea    0x14(%ebp),%eax
c01003e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c01003ec:	83 ec 04             	sub    $0x4,%esp
c01003ef:	ff 75 0c             	pushl  0xc(%ebp)
c01003f2:	ff 75 08             	pushl  0x8(%ebp)
c01003f5:	68 0a 5b 10 c0       	push   $0xc0105b0a
c01003fa:	e8 68 fe ff ff       	call   c0100267 <cprintf>
c01003ff:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
c0100402:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100405:	83 ec 08             	sub    $0x8,%esp
c0100408:	50                   	push   %eax
c0100409:	ff 75 10             	pushl  0x10(%ebp)
c010040c:	e8 2d fe ff ff       	call   c010023e <vcprintf>
c0100411:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
c0100414:	83 ec 0c             	sub    $0xc,%esp
c0100417:	68 26 5b 10 c0       	push   $0xc0105b26
c010041c:	e8 46 fe ff ff       	call   c0100267 <cprintf>
c0100421:	83 c4 10             	add    $0x10,%esp
c0100424:	eb 01                	jmp    c0100427 <__panic+0x5a>
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
        goto panic_dead;
c0100426:	90                   	nop
    vcprintf(fmt, ap);
    cprintf("\n");
    va_end(ap);

panic_dead:
    intr_disable();
c0100427:	e8 28 14 00 00       	call   c0101854 <intr_disable>
    while (1) {
        kmonitor(NULL);
c010042c:	83 ec 0c             	sub    $0xc,%esp
c010042f:	6a 00                	push   $0x0
c0100431:	e8 23 08 00 00       	call   c0100c59 <kmonitor>
c0100436:	83 c4 10             	add    $0x10,%esp
    }
c0100439:	eb f1                	jmp    c010042c <__panic+0x5f>

c010043b <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c010043b:	55                   	push   %ebp
c010043c:	89 e5                	mov    %esp,%ebp
c010043e:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    va_start(ap, fmt);
c0100441:	8d 45 14             	lea    0x14(%ebp),%eax
c0100444:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100447:	83 ec 04             	sub    $0x4,%esp
c010044a:	ff 75 0c             	pushl  0xc(%ebp)
c010044d:	ff 75 08             	pushl  0x8(%ebp)
c0100450:	68 28 5b 10 c0       	push   $0xc0105b28
c0100455:	e8 0d fe ff ff       	call   c0100267 <cprintf>
c010045a:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
c010045d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100460:	83 ec 08             	sub    $0x8,%esp
c0100463:	50                   	push   %eax
c0100464:	ff 75 10             	pushl  0x10(%ebp)
c0100467:	e8 d2 fd ff ff       	call   c010023e <vcprintf>
c010046c:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
c010046f:	83 ec 0c             	sub    $0xc,%esp
c0100472:	68 26 5b 10 c0       	push   $0xc0105b26
c0100477:	e8 eb fd ff ff       	call   c0100267 <cprintf>
c010047c:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
c010047f:	90                   	nop
c0100480:	c9                   	leave  
c0100481:	c3                   	ret    

c0100482 <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100482:	55                   	push   %ebp
c0100483:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100485:	a1 60 7e 11 c0       	mov    0xc0117e60,%eax
}
c010048a:	5d                   	pop    %ebp
c010048b:	c3                   	ret    

c010048c <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c010048c:	55                   	push   %ebp
c010048d:	89 e5                	mov    %esp,%ebp
c010048f:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c0100492:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100495:	8b 00                	mov    (%eax),%eax
c0100497:	89 45 fc             	mov    %eax,-0x4(%ebp)
c010049a:	8b 45 10             	mov    0x10(%ebp),%eax
c010049d:	8b 00                	mov    (%eax),%eax
c010049f:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004a2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c01004a9:	e9 d2 00 00 00       	jmp    c0100580 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
c01004ae:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01004b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01004b4:	01 d0                	add    %edx,%eax
c01004b6:	89 c2                	mov    %eax,%edx
c01004b8:	c1 ea 1f             	shr    $0x1f,%edx
c01004bb:	01 d0                	add    %edx,%eax
c01004bd:	d1 f8                	sar    %eax
c01004bf:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01004c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01004c5:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c01004c8:	eb 04                	jmp    c01004ce <stab_binsearch+0x42>
            m --;
c01004ca:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c01004ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004d1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c01004d4:	7c 1f                	jl     c01004f5 <stab_binsearch+0x69>
c01004d6:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004d9:	89 d0                	mov    %edx,%eax
c01004db:	01 c0                	add    %eax,%eax
c01004dd:	01 d0                	add    %edx,%eax
c01004df:	c1 e0 02             	shl    $0x2,%eax
c01004e2:	89 c2                	mov    %eax,%edx
c01004e4:	8b 45 08             	mov    0x8(%ebp),%eax
c01004e7:	01 d0                	add    %edx,%eax
c01004e9:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01004ed:	0f b6 c0             	movzbl %al,%eax
c01004f0:	3b 45 14             	cmp    0x14(%ebp),%eax
c01004f3:	75 d5                	jne    c01004ca <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
c01004f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004f8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c01004fb:	7d 0b                	jge    c0100508 <stab_binsearch+0x7c>
            l = true_m + 1;
c01004fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100500:	83 c0 01             	add    $0x1,%eax
c0100503:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c0100506:	eb 78                	jmp    c0100580 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
c0100508:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c010050f:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100512:	89 d0                	mov    %edx,%eax
c0100514:	01 c0                	add    %eax,%eax
c0100516:	01 d0                	add    %edx,%eax
c0100518:	c1 e0 02             	shl    $0x2,%eax
c010051b:	89 c2                	mov    %eax,%edx
c010051d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100520:	01 d0                	add    %edx,%eax
c0100522:	8b 40 08             	mov    0x8(%eax),%eax
c0100525:	3b 45 18             	cmp    0x18(%ebp),%eax
c0100528:	73 13                	jae    c010053d <stab_binsearch+0xb1>
            *region_left = m;
c010052a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010052d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100530:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c0100532:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100535:	83 c0 01             	add    $0x1,%eax
c0100538:	89 45 fc             	mov    %eax,-0x4(%ebp)
c010053b:	eb 43                	jmp    c0100580 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
c010053d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100540:	89 d0                	mov    %edx,%eax
c0100542:	01 c0                	add    %eax,%eax
c0100544:	01 d0                	add    %edx,%eax
c0100546:	c1 e0 02             	shl    $0x2,%eax
c0100549:	89 c2                	mov    %eax,%edx
c010054b:	8b 45 08             	mov    0x8(%ebp),%eax
c010054e:	01 d0                	add    %edx,%eax
c0100550:	8b 40 08             	mov    0x8(%eax),%eax
c0100553:	3b 45 18             	cmp    0x18(%ebp),%eax
c0100556:	76 16                	jbe    c010056e <stab_binsearch+0xe2>
            *region_right = m - 1;
c0100558:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010055b:	8d 50 ff             	lea    -0x1(%eax),%edx
c010055e:	8b 45 10             	mov    0x10(%ebp),%eax
c0100561:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c0100563:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100566:	83 e8 01             	sub    $0x1,%eax
c0100569:	89 45 f8             	mov    %eax,-0x8(%ebp)
c010056c:	eb 12                	jmp    c0100580 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c010056e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100571:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100574:	89 10                	mov    %edx,(%eax)
            l = m;
c0100576:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100579:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c010057c:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
c0100580:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100583:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c0100586:	0f 8e 22 ff ff ff    	jle    c01004ae <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
c010058c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100590:	75 0f                	jne    c01005a1 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
c0100592:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100595:	8b 00                	mov    (%eax),%eax
c0100597:	8d 50 ff             	lea    -0x1(%eax),%edx
c010059a:	8b 45 10             	mov    0x10(%ebp),%eax
c010059d:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
c010059f:	eb 3f                	jmp    c01005e0 <stab_binsearch+0x154>
    if (!any_matches) {
        *region_right = *region_left - 1;
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
c01005a1:	8b 45 10             	mov    0x10(%ebp),%eax
c01005a4:	8b 00                	mov    (%eax),%eax
c01005a6:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c01005a9:	eb 04                	jmp    c01005af <stab_binsearch+0x123>
c01005ab:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
c01005af:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005b2:	8b 00                	mov    (%eax),%eax
c01005b4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c01005b7:	7d 1f                	jge    c01005d8 <stab_binsearch+0x14c>
c01005b9:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01005bc:	89 d0                	mov    %edx,%eax
c01005be:	01 c0                	add    %eax,%eax
c01005c0:	01 d0                	add    %edx,%eax
c01005c2:	c1 e0 02             	shl    $0x2,%eax
c01005c5:	89 c2                	mov    %eax,%edx
c01005c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01005ca:	01 d0                	add    %edx,%eax
c01005cc:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01005d0:	0f b6 c0             	movzbl %al,%eax
c01005d3:	3b 45 14             	cmp    0x14(%ebp),%eax
c01005d6:	75 d3                	jne    c01005ab <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
c01005d8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005db:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01005de:	89 10                	mov    %edx,(%eax)
    }
}
c01005e0:	90                   	nop
c01005e1:	c9                   	leave  
c01005e2:	c3                   	ret    

c01005e3 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c01005e3:	55                   	push   %ebp
c01005e4:	89 e5                	mov    %esp,%ebp
c01005e6:	83 ec 38             	sub    $0x38,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c01005e9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005ec:	c7 00 48 5b 10 c0    	movl   $0xc0105b48,(%eax)
    info->eip_line = 0;
c01005f2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005f5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c01005fc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005ff:	c7 40 08 48 5b 10 c0 	movl   $0xc0105b48,0x8(%eax)
    info->eip_fn_namelen = 9;
c0100606:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100609:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c0100610:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100613:	8b 55 08             	mov    0x8(%ebp),%edx
c0100616:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100619:	8b 45 0c             	mov    0xc(%ebp),%eax
c010061c:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c0100623:	c7 45 f4 50 6d 10 c0 	movl   $0xc0106d50,-0xc(%ebp)
    stab_end = __STAB_END__;
c010062a:	c7 45 f0 b0 1b 11 c0 	movl   $0xc0111bb0,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c0100631:	c7 45 ec b1 1b 11 c0 	movl   $0xc0111bb1,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c0100638:	c7 45 e8 4b 46 11 c0 	movl   $0xc011464b,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c010063f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100642:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0100645:	76 0d                	jbe    c0100654 <debuginfo_eip+0x71>
c0100647:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010064a:	83 e8 01             	sub    $0x1,%eax
c010064d:	0f b6 00             	movzbl (%eax),%eax
c0100650:	84 c0                	test   %al,%al
c0100652:	74 0a                	je     c010065e <debuginfo_eip+0x7b>
        return -1;
c0100654:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100659:	e9 91 02 00 00       	jmp    c01008ef <debuginfo_eip+0x30c>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c010065e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c0100665:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100668:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010066b:	29 c2                	sub    %eax,%edx
c010066d:	89 d0                	mov    %edx,%eax
c010066f:	c1 f8 02             	sar    $0x2,%eax
c0100672:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c0100678:	83 e8 01             	sub    $0x1,%eax
c010067b:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c010067e:	ff 75 08             	pushl  0x8(%ebp)
c0100681:	6a 64                	push   $0x64
c0100683:	8d 45 e0             	lea    -0x20(%ebp),%eax
c0100686:	50                   	push   %eax
c0100687:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c010068a:	50                   	push   %eax
c010068b:	ff 75 f4             	pushl  -0xc(%ebp)
c010068e:	e8 f9 fd ff ff       	call   c010048c <stab_binsearch>
c0100693:	83 c4 14             	add    $0x14,%esp
    if (lfile == 0)
c0100696:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100699:	85 c0                	test   %eax,%eax
c010069b:	75 0a                	jne    c01006a7 <debuginfo_eip+0xc4>
        return -1;
c010069d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01006a2:	e9 48 02 00 00       	jmp    c01008ef <debuginfo_eip+0x30c>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c01006a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006aa:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01006ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006b0:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c01006b3:	ff 75 08             	pushl  0x8(%ebp)
c01006b6:	6a 24                	push   $0x24
c01006b8:	8d 45 d8             	lea    -0x28(%ebp),%eax
c01006bb:	50                   	push   %eax
c01006bc:	8d 45 dc             	lea    -0x24(%ebp),%eax
c01006bf:	50                   	push   %eax
c01006c0:	ff 75 f4             	pushl  -0xc(%ebp)
c01006c3:	e8 c4 fd ff ff       	call   c010048c <stab_binsearch>
c01006c8:	83 c4 14             	add    $0x14,%esp

    if (lfun <= rfun) {
c01006cb:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01006ce:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01006d1:	39 c2                	cmp    %eax,%edx
c01006d3:	7f 7c                	jg     c0100751 <debuginfo_eip+0x16e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c01006d5:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006d8:	89 c2                	mov    %eax,%edx
c01006da:	89 d0                	mov    %edx,%eax
c01006dc:	01 c0                	add    %eax,%eax
c01006de:	01 d0                	add    %edx,%eax
c01006e0:	c1 e0 02             	shl    $0x2,%eax
c01006e3:	89 c2                	mov    %eax,%edx
c01006e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006e8:	01 d0                	add    %edx,%eax
c01006ea:	8b 00                	mov    (%eax),%eax
c01006ec:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c01006ef:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01006f2:	29 d1                	sub    %edx,%ecx
c01006f4:	89 ca                	mov    %ecx,%edx
c01006f6:	39 d0                	cmp    %edx,%eax
c01006f8:	73 22                	jae    c010071c <debuginfo_eip+0x139>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c01006fa:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006fd:	89 c2                	mov    %eax,%edx
c01006ff:	89 d0                	mov    %edx,%eax
c0100701:	01 c0                	add    %eax,%eax
c0100703:	01 d0                	add    %edx,%eax
c0100705:	c1 e0 02             	shl    $0x2,%eax
c0100708:	89 c2                	mov    %eax,%edx
c010070a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010070d:	01 d0                	add    %edx,%eax
c010070f:	8b 10                	mov    (%eax),%edx
c0100711:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100714:	01 c2                	add    %eax,%edx
c0100716:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100719:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c010071c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010071f:	89 c2                	mov    %eax,%edx
c0100721:	89 d0                	mov    %edx,%eax
c0100723:	01 c0                	add    %eax,%eax
c0100725:	01 d0                	add    %edx,%eax
c0100727:	c1 e0 02             	shl    $0x2,%eax
c010072a:	89 c2                	mov    %eax,%edx
c010072c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010072f:	01 d0                	add    %edx,%eax
c0100731:	8b 50 08             	mov    0x8(%eax),%edx
c0100734:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100737:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c010073a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010073d:	8b 40 10             	mov    0x10(%eax),%eax
c0100740:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c0100743:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100746:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c0100749:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010074c:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010074f:	eb 15                	jmp    c0100766 <debuginfo_eip+0x183>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c0100751:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100754:	8b 55 08             	mov    0x8(%ebp),%edx
c0100757:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c010075a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010075d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c0100760:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0100763:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c0100766:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100769:	8b 40 08             	mov    0x8(%eax),%eax
c010076c:	83 ec 08             	sub    $0x8,%esp
c010076f:	6a 3a                	push   $0x3a
c0100771:	50                   	push   %eax
c0100772:	e8 b5 49 00 00       	call   c010512c <strfind>
c0100777:	83 c4 10             	add    $0x10,%esp
c010077a:	89 c2                	mov    %eax,%edx
c010077c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010077f:	8b 40 08             	mov    0x8(%eax),%eax
c0100782:	29 c2                	sub    %eax,%edx
c0100784:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100787:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c010078a:	83 ec 0c             	sub    $0xc,%esp
c010078d:	ff 75 08             	pushl  0x8(%ebp)
c0100790:	6a 44                	push   $0x44
c0100792:	8d 45 d0             	lea    -0x30(%ebp),%eax
c0100795:	50                   	push   %eax
c0100796:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c0100799:	50                   	push   %eax
c010079a:	ff 75 f4             	pushl  -0xc(%ebp)
c010079d:	e8 ea fc ff ff       	call   c010048c <stab_binsearch>
c01007a2:	83 c4 20             	add    $0x20,%esp
    if (lline <= rline) {
c01007a5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007a8:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01007ab:	39 c2                	cmp    %eax,%edx
c01007ad:	7f 24                	jg     c01007d3 <debuginfo_eip+0x1f0>
        info->eip_line = stabs[rline].n_desc;
c01007af:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01007b2:	89 c2                	mov    %eax,%edx
c01007b4:	89 d0                	mov    %edx,%eax
c01007b6:	01 c0                	add    %eax,%eax
c01007b8:	01 d0                	add    %edx,%eax
c01007ba:	c1 e0 02             	shl    $0x2,%eax
c01007bd:	89 c2                	mov    %eax,%edx
c01007bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007c2:	01 d0                	add    %edx,%eax
c01007c4:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c01007c8:	0f b7 d0             	movzwl %ax,%edx
c01007cb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007ce:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c01007d1:	eb 13                	jmp    c01007e6 <debuginfo_eip+0x203>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
c01007d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01007d8:	e9 12 01 00 00       	jmp    c01008ef <debuginfo_eip+0x30c>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c01007dd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007e0:	83 e8 01             	sub    $0x1,%eax
c01007e3:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c01007e6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007ec:	39 c2                	cmp    %eax,%edx
c01007ee:	7c 56                	jl     c0100846 <debuginfo_eip+0x263>
           && stabs[lline].n_type != N_SOL
c01007f0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007f3:	89 c2                	mov    %eax,%edx
c01007f5:	89 d0                	mov    %edx,%eax
c01007f7:	01 c0                	add    %eax,%eax
c01007f9:	01 d0                	add    %edx,%eax
c01007fb:	c1 e0 02             	shl    $0x2,%eax
c01007fe:	89 c2                	mov    %eax,%edx
c0100800:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100803:	01 d0                	add    %edx,%eax
c0100805:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100809:	3c 84                	cmp    $0x84,%al
c010080b:	74 39                	je     c0100846 <debuginfo_eip+0x263>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c010080d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100810:	89 c2                	mov    %eax,%edx
c0100812:	89 d0                	mov    %edx,%eax
c0100814:	01 c0                	add    %eax,%eax
c0100816:	01 d0                	add    %edx,%eax
c0100818:	c1 e0 02             	shl    $0x2,%eax
c010081b:	89 c2                	mov    %eax,%edx
c010081d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100820:	01 d0                	add    %edx,%eax
c0100822:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100826:	3c 64                	cmp    $0x64,%al
c0100828:	75 b3                	jne    c01007dd <debuginfo_eip+0x1fa>
c010082a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010082d:	89 c2                	mov    %eax,%edx
c010082f:	89 d0                	mov    %edx,%eax
c0100831:	01 c0                	add    %eax,%eax
c0100833:	01 d0                	add    %edx,%eax
c0100835:	c1 e0 02             	shl    $0x2,%eax
c0100838:	89 c2                	mov    %eax,%edx
c010083a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010083d:	01 d0                	add    %edx,%eax
c010083f:	8b 40 08             	mov    0x8(%eax),%eax
c0100842:	85 c0                	test   %eax,%eax
c0100844:	74 97                	je     c01007dd <debuginfo_eip+0x1fa>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c0100846:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100849:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010084c:	39 c2                	cmp    %eax,%edx
c010084e:	7c 46                	jl     c0100896 <debuginfo_eip+0x2b3>
c0100850:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100853:	89 c2                	mov    %eax,%edx
c0100855:	89 d0                	mov    %edx,%eax
c0100857:	01 c0                	add    %eax,%eax
c0100859:	01 d0                	add    %edx,%eax
c010085b:	c1 e0 02             	shl    $0x2,%eax
c010085e:	89 c2                	mov    %eax,%edx
c0100860:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100863:	01 d0                	add    %edx,%eax
c0100865:	8b 00                	mov    (%eax),%eax
c0100867:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c010086a:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010086d:	29 d1                	sub    %edx,%ecx
c010086f:	89 ca                	mov    %ecx,%edx
c0100871:	39 d0                	cmp    %edx,%eax
c0100873:	73 21                	jae    c0100896 <debuginfo_eip+0x2b3>
        info->eip_file = stabstr + stabs[lline].n_strx;
c0100875:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100878:	89 c2                	mov    %eax,%edx
c010087a:	89 d0                	mov    %edx,%eax
c010087c:	01 c0                	add    %eax,%eax
c010087e:	01 d0                	add    %edx,%eax
c0100880:	c1 e0 02             	shl    $0x2,%eax
c0100883:	89 c2                	mov    %eax,%edx
c0100885:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100888:	01 d0                	add    %edx,%eax
c010088a:	8b 10                	mov    (%eax),%edx
c010088c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010088f:	01 c2                	add    %eax,%edx
c0100891:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100894:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c0100896:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100899:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010089c:	39 c2                	cmp    %eax,%edx
c010089e:	7d 4a                	jge    c01008ea <debuginfo_eip+0x307>
        for (lline = lfun + 1;
c01008a0:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01008a3:	83 c0 01             	add    $0x1,%eax
c01008a6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c01008a9:	eb 18                	jmp    c01008c3 <debuginfo_eip+0x2e0>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c01008ab:	8b 45 0c             	mov    0xc(%ebp),%eax
c01008ae:	8b 40 14             	mov    0x14(%eax),%eax
c01008b1:	8d 50 01             	lea    0x1(%eax),%edx
c01008b4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01008b7:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
c01008ba:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01008bd:	83 c0 01             	add    $0x1,%eax
c01008c0:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
c01008c3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01008c6:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
c01008c9:	39 c2                	cmp    %eax,%edx
c01008cb:	7d 1d                	jge    c01008ea <debuginfo_eip+0x307>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c01008cd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01008d0:	89 c2                	mov    %eax,%edx
c01008d2:	89 d0                	mov    %edx,%eax
c01008d4:	01 c0                	add    %eax,%eax
c01008d6:	01 d0                	add    %edx,%eax
c01008d8:	c1 e0 02             	shl    $0x2,%eax
c01008db:	89 c2                	mov    %eax,%edx
c01008dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008e0:	01 d0                	add    %edx,%eax
c01008e2:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01008e6:	3c a0                	cmp    $0xa0,%al
c01008e8:	74 c1                	je     c01008ab <debuginfo_eip+0x2c8>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
c01008ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01008ef:	c9                   	leave  
c01008f0:	c3                   	ret    

c01008f1 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c01008f1:	55                   	push   %ebp
c01008f2:	89 e5                	mov    %esp,%ebp
c01008f4:	83 ec 08             	sub    $0x8,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c01008f7:	83 ec 0c             	sub    $0xc,%esp
c01008fa:	68 52 5b 10 c0       	push   $0xc0105b52
c01008ff:	e8 63 f9 ff ff       	call   c0100267 <cprintf>
c0100904:	83 c4 10             	add    $0x10,%esp
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100907:	83 ec 08             	sub    $0x8,%esp
c010090a:	68 2a 00 10 c0       	push   $0xc010002a
c010090f:	68 6b 5b 10 c0       	push   $0xc0105b6b
c0100914:	e8 4e f9 ff ff       	call   c0100267 <cprintf>
c0100919:	83 c4 10             	add    $0x10,%esp
    cprintf("  etext  0x%08x (phys)\n", etext);
c010091c:	83 ec 08             	sub    $0x8,%esp
c010091f:	68 4f 5a 10 c0       	push   $0xc0105a4f
c0100924:	68 83 5b 10 c0       	push   $0xc0105b83
c0100929:	e8 39 f9 ff ff       	call   c0100267 <cprintf>
c010092e:	83 c4 10             	add    $0x10,%esp
    cprintf("  edata  0x%08x (phys)\n", edata);
c0100931:	83 ec 08             	sub    $0x8,%esp
c0100934:	68 36 7a 11 c0       	push   $0xc0117a36
c0100939:	68 9b 5b 10 c0       	push   $0xc0105b9b
c010093e:	e8 24 f9 ff ff       	call   c0100267 <cprintf>
c0100943:	83 c4 10             	add    $0x10,%esp
    cprintf("  end    0x%08x (phys)\n", end);
c0100946:	83 ec 08             	sub    $0x8,%esp
c0100949:	68 68 89 11 c0       	push   $0xc0118968
c010094e:	68 b3 5b 10 c0       	push   $0xc0105bb3
c0100953:	e8 0f f9 ff ff       	call   c0100267 <cprintf>
c0100958:	83 c4 10             	add    $0x10,%esp
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c010095b:	b8 68 89 11 c0       	mov    $0xc0118968,%eax
c0100960:	05 ff 03 00 00       	add    $0x3ff,%eax
c0100965:	ba 2a 00 10 c0       	mov    $0xc010002a,%edx
c010096a:	29 d0                	sub    %edx,%eax
c010096c:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c0100972:	85 c0                	test   %eax,%eax
c0100974:	0f 48 c2             	cmovs  %edx,%eax
c0100977:	c1 f8 0a             	sar    $0xa,%eax
c010097a:	83 ec 08             	sub    $0x8,%esp
c010097d:	50                   	push   %eax
c010097e:	68 cc 5b 10 c0       	push   $0xc0105bcc
c0100983:	e8 df f8 ff ff       	call   c0100267 <cprintf>
c0100988:	83 c4 10             	add    $0x10,%esp
}
c010098b:	90                   	nop
c010098c:	c9                   	leave  
c010098d:	c3                   	ret    

c010098e <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c010098e:	55                   	push   %ebp
c010098f:	89 e5                	mov    %esp,%ebp
c0100991:	81 ec 28 01 00 00    	sub    $0x128,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c0100997:	83 ec 08             	sub    $0x8,%esp
c010099a:	8d 45 dc             	lea    -0x24(%ebp),%eax
c010099d:	50                   	push   %eax
c010099e:	ff 75 08             	pushl  0x8(%ebp)
c01009a1:	e8 3d fc ff ff       	call   c01005e3 <debuginfo_eip>
c01009a6:	83 c4 10             	add    $0x10,%esp
c01009a9:	85 c0                	test   %eax,%eax
c01009ab:	74 15                	je     c01009c2 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c01009ad:	83 ec 08             	sub    $0x8,%esp
c01009b0:	ff 75 08             	pushl  0x8(%ebp)
c01009b3:	68 f6 5b 10 c0       	push   $0xc0105bf6
c01009b8:	e8 aa f8 ff ff       	call   c0100267 <cprintf>
c01009bd:	83 c4 10             	add    $0x10,%esp
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
c01009c0:	eb 65                	jmp    c0100a27 <print_debuginfo+0x99>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c01009c2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01009c9:	eb 1c                	jmp    c01009e7 <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
c01009cb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01009ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009d1:	01 d0                	add    %edx,%eax
c01009d3:	0f b6 00             	movzbl (%eax),%eax
c01009d6:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c01009dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01009df:	01 ca                	add    %ecx,%edx
c01009e1:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c01009e3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01009e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01009ea:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01009ed:	7f dc                	jg     c01009cb <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
c01009ef:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c01009f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009f8:	01 d0                	add    %edx,%eax
c01009fa:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
c01009fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100a00:	8b 55 08             	mov    0x8(%ebp),%edx
c0100a03:	89 d1                	mov    %edx,%ecx
c0100a05:	29 c1                	sub    %eax,%ecx
c0100a07:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100a0a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100a0d:	83 ec 0c             	sub    $0xc,%esp
c0100a10:	51                   	push   %ecx
c0100a11:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100a17:	51                   	push   %ecx
c0100a18:	52                   	push   %edx
c0100a19:	50                   	push   %eax
c0100a1a:	68 12 5c 10 c0       	push   $0xc0105c12
c0100a1f:	e8 43 f8 ff ff       	call   c0100267 <cprintf>
c0100a24:	83 c4 20             	add    $0x20,%esp
                fnname, eip - info.eip_fn_addr);
    }
}
c0100a27:	90                   	nop
c0100a28:	c9                   	leave  
c0100a29:	c3                   	ret    

c0100a2a <read_eip>:

static __noinline uint32_t
read_eip(void) {
c0100a2a:	55                   	push   %ebp
c0100a2b:	89 e5                	mov    %esp,%ebp
c0100a2d:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c0100a30:	8b 45 04             	mov    0x4(%ebp),%eax
c0100a33:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c0100a36:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0100a39:	c9                   	leave  
c0100a3a:	c3                   	ret    

c0100a3b <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c0100a3b:	55                   	push   %ebp
c0100a3c:	89 e5                	mov    %esp,%ebp
c0100a3e:	83 ec 28             	sub    $0x28,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c0100a41:	89 e8                	mov    %ebp,%eax
c0100a43:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
c0100a46:	8b 45 e0             	mov    -0x20(%ebp),%eax
              临时变量n
              ……
      高地址:
      */

      uint32_t ebp = read_ebp(); //ebp为当前栈存放ebp的地址
c0100a49:	89 45 f4             	mov    %eax,-0xc(%ebp)
      uint32_t eip = read_eip(); //eip为当前栈存放eip的地址
c0100a4c:	e8 d9 ff ff ff       	call   c0100a2a <read_eip>
c0100a51:	89 45 f0             	mov    %eax,-0x10(%ebp)
      int i, j;

      for(i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i++)
c0100a54:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0100a5b:	eb 7d                	jmp    c0100ada <print_stackframe+0x9f>
      {
              cprintf("ebp : 0x%08x, eip : 0x%08x  args:", ebp, eip);
c0100a5d:	83 ec 04             	sub    $0x4,%esp
c0100a60:	ff 75 f0             	pushl  -0x10(%ebp)
c0100a63:	ff 75 f4             	pushl  -0xc(%ebp)
c0100a66:	68 24 5c 10 c0       	push   $0xc0105c24
c0100a6b:	e8 f7 f7 ff ff       	call   c0100267 <cprintf>
c0100a70:	83 c4 10             	add    $0x10,%esp

              uint32_t *args = (uint32_t *)ebp + 2; 
c0100a73:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a76:	83 c0 08             	add    $0x8,%eax
c0100a79:	89 45 e4             	mov    %eax,-0x1c(%ebp)
              for(j = 0; j < 4; j++)
c0100a7c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0100a83:	eb 26                	jmp    c0100aab <print_stackframe+0x70>
                      cprintf("0x%08x ", args[j]);
c0100a85:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a88:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100a8f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100a92:	01 d0                	add    %edx,%eax
c0100a94:	8b 00                	mov    (%eax),%eax
c0100a96:	83 ec 08             	sub    $0x8,%esp
c0100a99:	50                   	push   %eax
c0100a9a:	68 46 5c 10 c0       	push   $0xc0105c46
c0100a9f:	e8 c3 f7 ff ff       	call   c0100267 <cprintf>
c0100aa4:	83 c4 10             	add    $0x10,%esp
      for(i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i++)
      {
              cprintf("ebp : 0x%08x, eip : 0x%08x  args:", ebp, eip);

              uint32_t *args = (uint32_t *)ebp + 2; 
              for(j = 0; j < 4; j++)
c0100aa7:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
c0100aab:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100aaf:	7e d4                	jle    c0100a85 <print_stackframe+0x4a>
                      cprintf("0x%08x ", args[j]);

              print_debuginfo(eip - 1);
c0100ab1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100ab4:	83 e8 01             	sub    $0x1,%eax
c0100ab7:	83 ec 0c             	sub    $0xc,%esp
c0100aba:	50                   	push   %eax
c0100abb:	e8 ce fe ff ff       	call   c010098e <print_debuginfo>
c0100ac0:	83 c4 10             	add    $0x10,%esp

              eip = ((uint32_t *)ebp)[1]; //取出存在栈中的地址，ebp[1]指向返回本次调用后的下一条指令
c0100ac3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ac6:	83 c0 04             	add    $0x4,%eax
c0100ac9:	8b 00                	mov    (%eax),%eax
c0100acb:	89 45 f0             	mov    %eax,-0x10(%ebp)
              ebp = ((uint32_t *)ebp)[0]; //取出存在栈中的地址，ebp[0]指向其调用者函数的ebp
c0100ace:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ad1:	8b 00                	mov    (%eax),%eax
c0100ad3:	89 45 f4             	mov    %eax,-0xc(%ebp)

      uint32_t ebp = read_ebp(); //ebp为当前栈存放ebp的地址
      uint32_t eip = read_eip(); //eip为当前栈存放eip的地址
      int i, j;

      for(i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i++)
c0100ad6:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0100ada:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100ade:	74 0a                	je     c0100aea <print_stackframe+0xaf>
c0100ae0:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100ae4:	0f 8e 73 ff ff ff    	jle    c0100a5d <print_stackframe+0x22>
              eip = ((uint32_t *)ebp)[1]; //取出存在栈中的地址，ebp[1]指向返回本次调用后的下一条指令
              ebp = ((uint32_t *)ebp)[0]; //取出存在栈中的地址，ebp[0]指向其调用者函数的ebp

      }

}
c0100aea:	90                   	nop
c0100aeb:	c9                   	leave  
c0100aec:	c3                   	ret    

c0100aed <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100aed:	55                   	push   %ebp
c0100aee:	89 e5                	mov    %esp,%ebp
c0100af0:	83 ec 18             	sub    $0x18,%esp
    int argc = 0;
c0100af3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100afa:	eb 0c                	jmp    c0100b08 <parse+0x1b>
            *buf ++ = '\0';
c0100afc:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aff:	8d 50 01             	lea    0x1(%eax),%edx
c0100b02:	89 55 08             	mov    %edx,0x8(%ebp)
c0100b05:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b08:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b0b:	0f b6 00             	movzbl (%eax),%eax
c0100b0e:	84 c0                	test   %al,%al
c0100b10:	74 1e                	je     c0100b30 <parse+0x43>
c0100b12:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b15:	0f b6 00             	movzbl (%eax),%eax
c0100b18:	0f be c0             	movsbl %al,%eax
c0100b1b:	83 ec 08             	sub    $0x8,%esp
c0100b1e:	50                   	push   %eax
c0100b1f:	68 d0 5c 10 c0       	push   $0xc0105cd0
c0100b24:	e8 d0 45 00 00       	call   c01050f9 <strchr>
c0100b29:	83 c4 10             	add    $0x10,%esp
c0100b2c:	85 c0                	test   %eax,%eax
c0100b2e:	75 cc                	jne    c0100afc <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
c0100b30:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b33:	0f b6 00             	movzbl (%eax),%eax
c0100b36:	84 c0                	test   %al,%al
c0100b38:	74 69                	je     c0100ba3 <parse+0xb6>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100b3a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100b3e:	75 12                	jne    c0100b52 <parse+0x65>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100b40:	83 ec 08             	sub    $0x8,%esp
c0100b43:	6a 10                	push   $0x10
c0100b45:	68 d5 5c 10 c0       	push   $0xc0105cd5
c0100b4a:	e8 18 f7 ff ff       	call   c0100267 <cprintf>
c0100b4f:	83 c4 10             	add    $0x10,%esp
        }
        argv[argc ++] = buf;
c0100b52:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b55:	8d 50 01             	lea    0x1(%eax),%edx
c0100b58:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100b5b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100b62:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100b65:	01 c2                	add    %eax,%edx
c0100b67:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b6a:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b6c:	eb 04                	jmp    c0100b72 <parse+0x85>
            buf ++;
c0100b6e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b72:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b75:	0f b6 00             	movzbl (%eax),%eax
c0100b78:	84 c0                	test   %al,%al
c0100b7a:	0f 84 7a ff ff ff    	je     c0100afa <parse+0xd>
c0100b80:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b83:	0f b6 00             	movzbl (%eax),%eax
c0100b86:	0f be c0             	movsbl %al,%eax
c0100b89:	83 ec 08             	sub    $0x8,%esp
c0100b8c:	50                   	push   %eax
c0100b8d:	68 d0 5c 10 c0       	push   $0xc0105cd0
c0100b92:	e8 62 45 00 00       	call   c01050f9 <strchr>
c0100b97:	83 c4 10             	add    $0x10,%esp
c0100b9a:	85 c0                	test   %eax,%eax
c0100b9c:	74 d0                	je     c0100b6e <parse+0x81>
            buf ++;
        }
    }
c0100b9e:	e9 57 ff ff ff       	jmp    c0100afa <parse+0xd>
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
            break;
c0100ba3:	90                   	nop
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
c0100ba4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100ba7:	c9                   	leave  
c0100ba8:	c3                   	ret    

c0100ba9 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100ba9:	55                   	push   %ebp
c0100baa:	89 e5                	mov    %esp,%ebp
c0100bac:	83 ec 58             	sub    $0x58,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100baf:	83 ec 08             	sub    $0x8,%esp
c0100bb2:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100bb5:	50                   	push   %eax
c0100bb6:	ff 75 08             	pushl  0x8(%ebp)
c0100bb9:	e8 2f ff ff ff       	call   c0100aed <parse>
c0100bbe:	83 c4 10             	add    $0x10,%esp
c0100bc1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100bc4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100bc8:	75 0a                	jne    c0100bd4 <runcmd+0x2b>
        return 0;
c0100bca:	b8 00 00 00 00       	mov    $0x0,%eax
c0100bcf:	e9 83 00 00 00       	jmp    c0100c57 <runcmd+0xae>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100bd4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100bdb:	eb 59                	jmp    c0100c36 <runcmd+0x8d>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100bdd:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100be0:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100be3:	89 d0                	mov    %edx,%eax
c0100be5:	01 c0                	add    %eax,%eax
c0100be7:	01 d0                	add    %edx,%eax
c0100be9:	c1 e0 02             	shl    $0x2,%eax
c0100bec:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100bf1:	8b 00                	mov    (%eax),%eax
c0100bf3:	83 ec 08             	sub    $0x8,%esp
c0100bf6:	51                   	push   %ecx
c0100bf7:	50                   	push   %eax
c0100bf8:	e8 5c 44 00 00       	call   c0105059 <strcmp>
c0100bfd:	83 c4 10             	add    $0x10,%esp
c0100c00:	85 c0                	test   %eax,%eax
c0100c02:	75 2e                	jne    c0100c32 <runcmd+0x89>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100c04:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c07:	89 d0                	mov    %edx,%eax
c0100c09:	01 c0                	add    %eax,%eax
c0100c0b:	01 d0                	add    %edx,%eax
c0100c0d:	c1 e0 02             	shl    $0x2,%eax
c0100c10:	05 28 70 11 c0       	add    $0xc0117028,%eax
c0100c15:	8b 10                	mov    (%eax),%edx
c0100c17:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100c1a:	83 c0 04             	add    $0x4,%eax
c0100c1d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0100c20:	83 e9 01             	sub    $0x1,%ecx
c0100c23:	83 ec 04             	sub    $0x4,%esp
c0100c26:	ff 75 0c             	pushl  0xc(%ebp)
c0100c29:	50                   	push   %eax
c0100c2a:	51                   	push   %ecx
c0100c2b:	ff d2                	call   *%edx
c0100c2d:	83 c4 10             	add    $0x10,%esp
c0100c30:	eb 25                	jmp    c0100c57 <runcmd+0xae>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c32:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100c36:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c39:	83 f8 02             	cmp    $0x2,%eax
c0100c3c:	76 9f                	jbe    c0100bdd <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100c3e:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100c41:	83 ec 08             	sub    $0x8,%esp
c0100c44:	50                   	push   %eax
c0100c45:	68 f3 5c 10 c0       	push   $0xc0105cf3
c0100c4a:	e8 18 f6 ff ff       	call   c0100267 <cprintf>
c0100c4f:	83 c4 10             	add    $0x10,%esp
    return 0;
c0100c52:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100c57:	c9                   	leave  
c0100c58:	c3                   	ret    

c0100c59 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100c59:	55                   	push   %ebp
c0100c5a:	89 e5                	mov    %esp,%ebp
c0100c5c:	83 ec 18             	sub    $0x18,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100c5f:	83 ec 0c             	sub    $0xc,%esp
c0100c62:	68 0c 5d 10 c0       	push   $0xc0105d0c
c0100c67:	e8 fb f5 ff ff       	call   c0100267 <cprintf>
c0100c6c:	83 c4 10             	add    $0x10,%esp
    cprintf("Type 'help' for a list of commands.\n");
c0100c6f:	83 ec 0c             	sub    $0xc,%esp
c0100c72:	68 34 5d 10 c0       	push   $0xc0105d34
c0100c77:	e8 eb f5 ff ff       	call   c0100267 <cprintf>
c0100c7c:	83 c4 10             	add    $0x10,%esp

    if (tf != NULL) {
c0100c7f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100c83:	74 0e                	je     c0100c93 <kmonitor+0x3a>
        print_trapframe(tf);
c0100c85:	83 ec 0c             	sub    $0xc,%esp
c0100c88:	ff 75 08             	pushl  0x8(%ebp)
c0100c8b:	e8 9f 0d 00 00       	call   c0101a2f <print_trapframe>
c0100c90:	83 c4 10             	add    $0x10,%esp
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100c93:	83 ec 0c             	sub    $0xc,%esp
c0100c96:	68 59 5d 10 c0       	push   $0xc0105d59
c0100c9b:	e8 6b f6 ff ff       	call   c010030b <readline>
c0100ca0:	83 c4 10             	add    $0x10,%esp
c0100ca3:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100ca6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100caa:	74 e7                	je     c0100c93 <kmonitor+0x3a>
            if (runcmd(buf, tf) < 0) {
c0100cac:	83 ec 08             	sub    $0x8,%esp
c0100caf:	ff 75 08             	pushl  0x8(%ebp)
c0100cb2:	ff 75 f4             	pushl  -0xc(%ebp)
c0100cb5:	e8 ef fe ff ff       	call   c0100ba9 <runcmd>
c0100cba:	83 c4 10             	add    $0x10,%esp
c0100cbd:	85 c0                	test   %eax,%eax
c0100cbf:	78 02                	js     c0100cc3 <kmonitor+0x6a>
                break;
            }
        }
    }
c0100cc1:	eb d0                	jmp    c0100c93 <kmonitor+0x3a>

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
            if (runcmd(buf, tf) < 0) {
                break;
c0100cc3:	90                   	nop
            }
        }
    }
}
c0100cc4:	90                   	nop
c0100cc5:	c9                   	leave  
c0100cc6:	c3                   	ret    

c0100cc7 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100cc7:	55                   	push   %ebp
c0100cc8:	89 e5                	mov    %esp,%ebp
c0100cca:	83 ec 18             	sub    $0x18,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100ccd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100cd4:	eb 3c                	jmp    c0100d12 <mon_help+0x4b>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100cd6:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100cd9:	89 d0                	mov    %edx,%eax
c0100cdb:	01 c0                	add    %eax,%eax
c0100cdd:	01 d0                	add    %edx,%eax
c0100cdf:	c1 e0 02             	shl    $0x2,%eax
c0100ce2:	05 24 70 11 c0       	add    $0xc0117024,%eax
c0100ce7:	8b 08                	mov    (%eax),%ecx
c0100ce9:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100cec:	89 d0                	mov    %edx,%eax
c0100cee:	01 c0                	add    %eax,%eax
c0100cf0:	01 d0                	add    %edx,%eax
c0100cf2:	c1 e0 02             	shl    $0x2,%eax
c0100cf5:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100cfa:	8b 00                	mov    (%eax),%eax
c0100cfc:	83 ec 04             	sub    $0x4,%esp
c0100cff:	51                   	push   %ecx
c0100d00:	50                   	push   %eax
c0100d01:	68 5d 5d 10 c0       	push   $0xc0105d5d
c0100d06:	e8 5c f5 ff ff       	call   c0100267 <cprintf>
c0100d0b:	83 c4 10             	add    $0x10,%esp

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100d0e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100d12:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d15:	83 f8 02             	cmp    $0x2,%eax
c0100d18:	76 bc                	jbe    c0100cd6 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
c0100d1a:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d1f:	c9                   	leave  
c0100d20:	c3                   	ret    

c0100d21 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100d21:	55                   	push   %ebp
c0100d22:	89 e5                	mov    %esp,%ebp
c0100d24:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100d27:	e8 c5 fb ff ff       	call   c01008f1 <print_kerninfo>
    return 0;
c0100d2c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d31:	c9                   	leave  
c0100d32:	c3                   	ret    

c0100d33 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100d33:	55                   	push   %ebp
c0100d34:	89 e5                	mov    %esp,%ebp
c0100d36:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100d39:	e8 fd fc ff ff       	call   c0100a3b <print_stackframe>
    return 0;
c0100d3e:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d43:	c9                   	leave  
c0100d44:	c3                   	ret    

c0100d45 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100d45:	55                   	push   %ebp
c0100d46:	89 e5                	mov    %esp,%ebp
c0100d48:	83 ec 18             	sub    $0x18,%esp
c0100d4b:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c0100d51:	c6 45 ef 34          	movb   $0x34,-0x11(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100d55:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
c0100d59:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100d5d:	ee                   	out    %al,(%dx)
c0100d5e:	66 c7 45 f4 40 00    	movw   $0x40,-0xc(%ebp)
c0100d64:	c6 45 f0 9c          	movb   $0x9c,-0x10(%ebp)
c0100d68:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
c0100d6c:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
c0100d70:	ee                   	out    %al,(%dx)
c0100d71:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100d77:	c6 45 f1 2e          	movb   $0x2e,-0xf(%ebp)
c0100d7b:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100d7f:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100d83:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100d84:	c7 05 4c 89 11 c0 00 	movl   $0x0,0xc011894c
c0100d8b:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100d8e:	83 ec 0c             	sub    $0xc,%esp
c0100d91:	68 66 5d 10 c0       	push   $0xc0105d66
c0100d96:	e8 cc f4 ff ff       	call   c0100267 <cprintf>
c0100d9b:	83 c4 10             	add    $0x10,%esp
    pic_enable(IRQ_TIMER);
c0100d9e:	83 ec 0c             	sub    $0xc,%esp
c0100da1:	6a 00                	push   $0x0
c0100da3:	e8 3b 09 00 00       	call   c01016e3 <pic_enable>
c0100da8:	83 c4 10             	add    $0x10,%esp
}
c0100dab:	90                   	nop
c0100dac:	c9                   	leave  
c0100dad:	c3                   	ret    

c0100dae <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100dae:	55                   	push   %ebp
c0100daf:	89 e5                	mov    %esp,%ebp
c0100db1:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100db4:	9c                   	pushf  
c0100db5:	58                   	pop    %eax
c0100db6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100db9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100dbc:	25 00 02 00 00       	and    $0x200,%eax
c0100dc1:	85 c0                	test   %eax,%eax
c0100dc3:	74 0c                	je     c0100dd1 <__intr_save+0x23>
        intr_disable();
c0100dc5:	e8 8a 0a 00 00       	call   c0101854 <intr_disable>
        return 1;
c0100dca:	b8 01 00 00 00       	mov    $0x1,%eax
c0100dcf:	eb 05                	jmp    c0100dd6 <__intr_save+0x28>
    }
    return 0;
c0100dd1:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100dd6:	c9                   	leave  
c0100dd7:	c3                   	ret    

c0100dd8 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100dd8:	55                   	push   %ebp
c0100dd9:	89 e5                	mov    %esp,%ebp
c0100ddb:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100dde:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100de2:	74 05                	je     c0100de9 <__intr_restore+0x11>
        intr_enable();
c0100de4:	e8 64 0a 00 00       	call   c010184d <intr_enable>
    }
}
c0100de9:	90                   	nop
c0100dea:	c9                   	leave  
c0100deb:	c3                   	ret    

c0100dec <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100dec:	55                   	push   %ebp
c0100ded:	89 e5                	mov    %esp,%ebp
c0100def:	83 ec 10             	sub    $0x10,%esp
c0100df2:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100df8:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100dfc:	89 c2                	mov    %eax,%edx
c0100dfe:	ec                   	in     (%dx),%al
c0100dff:	88 45 f4             	mov    %al,-0xc(%ebp)
c0100e02:	66 c7 45 fc 84 00    	movw   $0x84,-0x4(%ebp)
c0100e08:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0100e0c:	89 c2                	mov    %eax,%edx
c0100e0e:	ec                   	in     (%dx),%al
c0100e0f:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100e12:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100e18:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100e1c:	89 c2                	mov    %eax,%edx
c0100e1e:	ec                   	in     (%dx),%al
c0100e1f:	88 45 f6             	mov    %al,-0xa(%ebp)
c0100e22:	66 c7 45 f8 84 00    	movw   $0x84,-0x8(%ebp)
c0100e28:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
c0100e2c:	89 c2                	mov    %eax,%edx
c0100e2e:	ec                   	in     (%dx),%al
c0100e2f:	88 45 f7             	mov    %al,-0x9(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100e32:	90                   	nop
c0100e33:	c9                   	leave  
c0100e34:	c3                   	ret    

c0100e35 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100e35:	55                   	push   %ebp
c0100e36:	89 e5                	mov    %esp,%ebp
c0100e38:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100e3b:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100e42:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e45:	0f b7 00             	movzwl (%eax),%eax
c0100e48:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100e4c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e4f:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100e54:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e57:	0f b7 00             	movzwl (%eax),%eax
c0100e5a:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100e5e:	74 12                	je     c0100e72 <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100e60:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100e67:	66 c7 05 86 7e 11 c0 	movw   $0x3b4,0xc0117e86
c0100e6e:	b4 03 
c0100e70:	eb 13                	jmp    c0100e85 <cga_init+0x50>
    } else {
        *cp = was;
c0100e72:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e75:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100e79:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100e7c:	66 c7 05 86 7e 11 c0 	movw   $0x3d4,0xc0117e86
c0100e83:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100e85:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100e8c:	0f b7 c0             	movzwl %ax,%eax
c0100e8f:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
c0100e93:	c6 45 ea 0e          	movb   $0xe,-0x16(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100e97:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
c0100e9b:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
c0100e9f:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100ea0:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100ea7:	83 c0 01             	add    $0x1,%eax
c0100eaa:	0f b7 c0             	movzwl %ax,%eax
c0100ead:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100eb1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100eb5:	89 c2                	mov    %eax,%edx
c0100eb7:	ec                   	in     (%dx),%al
c0100eb8:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c0100ebb:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
c0100ebf:	0f b6 c0             	movzbl %al,%eax
c0100ec2:	c1 e0 08             	shl    $0x8,%eax
c0100ec5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100ec8:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100ecf:	0f b7 c0             	movzwl %ax,%eax
c0100ed2:	66 89 45 f0          	mov    %ax,-0x10(%ebp)
c0100ed6:	c6 45 ec 0f          	movb   $0xf,-0x14(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100eda:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
c0100ede:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
c0100ee2:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0100ee3:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100eea:	83 c0 01             	add    $0x1,%eax
c0100eed:	0f b7 c0             	movzwl %ax,%eax
c0100ef0:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100ef4:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0100ef8:	89 c2                	mov    %eax,%edx
c0100efa:	ec                   	in     (%dx),%al
c0100efb:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0100efe:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f02:	0f b6 c0             	movzbl %al,%eax
c0100f05:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100f08:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f0b:	a3 80 7e 11 c0       	mov    %eax,0xc0117e80
    crt_pos = pos;
c0100f10:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f13:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
}
c0100f19:	90                   	nop
c0100f1a:	c9                   	leave  
c0100f1b:	c3                   	ret    

c0100f1c <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100f1c:	55                   	push   %ebp
c0100f1d:	89 e5                	mov    %esp,%ebp
c0100f1f:	83 ec 28             	sub    $0x28,%esp
c0100f22:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c0100f28:	c6 45 da 00          	movb   $0x0,-0x26(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f2c:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
c0100f30:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100f34:	ee                   	out    %al,(%dx)
c0100f35:	66 c7 45 f4 fb 03    	movw   $0x3fb,-0xc(%ebp)
c0100f3b:	c6 45 db 80          	movb   $0x80,-0x25(%ebp)
c0100f3f:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
c0100f43:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
c0100f47:	ee                   	out    %al,(%dx)
c0100f48:	66 c7 45 f2 f8 03    	movw   $0x3f8,-0xe(%ebp)
c0100f4e:	c6 45 dc 0c          	movb   $0xc,-0x24(%ebp)
c0100f52:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
c0100f56:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100f5a:	ee                   	out    %al,(%dx)
c0100f5b:	66 c7 45 f0 f9 03    	movw   $0x3f9,-0x10(%ebp)
c0100f61:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
c0100f65:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0100f69:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
c0100f6d:	ee                   	out    %al,(%dx)
c0100f6e:	66 c7 45 ee fb 03    	movw   $0x3fb,-0x12(%ebp)
c0100f74:	c6 45 de 03          	movb   $0x3,-0x22(%ebp)
c0100f78:	0f b6 45 de          	movzbl -0x22(%ebp),%eax
c0100f7c:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100f80:	ee                   	out    %al,(%dx)
c0100f81:	66 c7 45 ec fc 03    	movw   $0x3fc,-0x14(%ebp)
c0100f87:	c6 45 df 00          	movb   $0x0,-0x21(%ebp)
c0100f8b:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
c0100f8f:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
c0100f93:	ee                   	out    %al,(%dx)
c0100f94:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0100f9a:	c6 45 e0 01          	movb   $0x1,-0x20(%ebp)
c0100f9e:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
c0100fa2:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100fa6:	ee                   	out    %al,(%dx)
c0100fa7:	66 c7 45 e8 fd 03    	movw   $0x3fd,-0x18(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100fad:	0f b7 45 e8          	movzwl -0x18(%ebp),%eax
c0100fb1:	89 c2                	mov    %eax,%edx
c0100fb3:	ec                   	in     (%dx),%al
c0100fb4:	88 45 e1             	mov    %al,-0x1f(%ebp)
    return data;
c0100fb7:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0100fbb:	3c ff                	cmp    $0xff,%al
c0100fbd:	0f 95 c0             	setne  %al
c0100fc0:	0f b6 c0             	movzbl %al,%eax
c0100fc3:	a3 88 7e 11 c0       	mov    %eax,0xc0117e88
c0100fc8:	66 c7 45 e6 fa 03    	movw   $0x3fa,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100fce:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0100fd2:	89 c2                	mov    %eax,%edx
c0100fd4:	ec                   	in     (%dx),%al
c0100fd5:	88 45 e2             	mov    %al,-0x1e(%ebp)
c0100fd8:	66 c7 45 e4 f8 03    	movw   $0x3f8,-0x1c(%ebp)
c0100fde:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
c0100fe2:	89 c2                	mov    %eax,%edx
c0100fe4:	ec                   	in     (%dx),%al
c0100fe5:	88 45 e3             	mov    %al,-0x1d(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c0100fe8:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c0100fed:	85 c0                	test   %eax,%eax
c0100fef:	74 0d                	je     c0100ffe <serial_init+0xe2>
        pic_enable(IRQ_COM1);
c0100ff1:	83 ec 0c             	sub    $0xc,%esp
c0100ff4:	6a 04                	push   $0x4
c0100ff6:	e8 e8 06 00 00       	call   c01016e3 <pic_enable>
c0100ffb:	83 c4 10             	add    $0x10,%esp
    }
}
c0100ffe:	90                   	nop
c0100fff:	c9                   	leave  
c0101000:	c3                   	ret    

c0101001 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c0101001:	55                   	push   %ebp
c0101002:	89 e5                	mov    %esp,%ebp
c0101004:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101007:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c010100e:	eb 09                	jmp    c0101019 <lpt_putc_sub+0x18>
        delay();
c0101010:	e8 d7 fd ff ff       	call   c0100dec <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101015:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101019:	66 c7 45 f4 79 03    	movw   $0x379,-0xc(%ebp)
c010101f:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0101023:	89 c2                	mov    %eax,%edx
c0101025:	ec                   	in     (%dx),%al
c0101026:	88 45 f3             	mov    %al,-0xd(%ebp)
    return data;
c0101029:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010102d:	84 c0                	test   %al,%al
c010102f:	78 09                	js     c010103a <lpt_putc_sub+0x39>
c0101031:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101038:	7e d6                	jle    c0101010 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
c010103a:	8b 45 08             	mov    0x8(%ebp),%eax
c010103d:	0f b6 c0             	movzbl %al,%eax
c0101040:	66 c7 45 f8 78 03    	movw   $0x378,-0x8(%ebp)
c0101046:	88 45 f0             	mov    %al,-0x10(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101049:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
c010104d:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
c0101051:	ee                   	out    %al,(%dx)
c0101052:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
c0101058:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c010105c:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101060:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101064:	ee                   	out    %al,(%dx)
c0101065:	66 c7 45 fa 7a 03    	movw   $0x37a,-0x6(%ebp)
c010106b:	c6 45 f2 08          	movb   $0x8,-0xe(%ebp)
c010106f:	0f b6 45 f2          	movzbl -0xe(%ebp),%eax
c0101073:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101077:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c0101078:	90                   	nop
c0101079:	c9                   	leave  
c010107a:	c3                   	ret    

c010107b <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c010107b:	55                   	push   %ebp
c010107c:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
c010107e:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101082:	74 0d                	je     c0101091 <lpt_putc+0x16>
        lpt_putc_sub(c);
c0101084:	ff 75 08             	pushl  0x8(%ebp)
c0101087:	e8 75 ff ff ff       	call   c0101001 <lpt_putc_sub>
c010108c:	83 c4 04             	add    $0x4,%esp
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
c010108f:	eb 1e                	jmp    c01010af <lpt_putc+0x34>
lpt_putc(int c) {
    if (c != '\b') {
        lpt_putc_sub(c);
    }
    else {
        lpt_putc_sub('\b');
c0101091:	6a 08                	push   $0x8
c0101093:	e8 69 ff ff ff       	call   c0101001 <lpt_putc_sub>
c0101098:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub(' ');
c010109b:	6a 20                	push   $0x20
c010109d:	e8 5f ff ff ff       	call   c0101001 <lpt_putc_sub>
c01010a2:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub('\b');
c01010a5:	6a 08                	push   $0x8
c01010a7:	e8 55 ff ff ff       	call   c0101001 <lpt_putc_sub>
c01010ac:	83 c4 04             	add    $0x4,%esp
    }
}
c01010af:	90                   	nop
c01010b0:	c9                   	leave  
c01010b1:	c3                   	ret    

c01010b2 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c01010b2:	55                   	push   %ebp
c01010b3:	89 e5                	mov    %esp,%ebp
c01010b5:	53                   	push   %ebx
c01010b6:	83 ec 14             	sub    $0x14,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c01010b9:	8b 45 08             	mov    0x8(%ebp),%eax
c01010bc:	b0 00                	mov    $0x0,%al
c01010be:	85 c0                	test   %eax,%eax
c01010c0:	75 07                	jne    c01010c9 <cga_putc+0x17>
        c |= 0x0700;
c01010c2:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c01010c9:	8b 45 08             	mov    0x8(%ebp),%eax
c01010cc:	0f b6 c0             	movzbl %al,%eax
c01010cf:	83 f8 0a             	cmp    $0xa,%eax
c01010d2:	74 4e                	je     c0101122 <cga_putc+0x70>
c01010d4:	83 f8 0d             	cmp    $0xd,%eax
c01010d7:	74 59                	je     c0101132 <cga_putc+0x80>
c01010d9:	83 f8 08             	cmp    $0x8,%eax
c01010dc:	0f 85 8a 00 00 00    	jne    c010116c <cga_putc+0xba>
    case '\b':
        if (crt_pos > 0) {
c01010e2:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c01010e9:	66 85 c0             	test   %ax,%ax
c01010ec:	0f 84 a0 00 00 00    	je     c0101192 <cga_putc+0xe0>
            crt_pos --;
c01010f2:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c01010f9:	83 e8 01             	sub    $0x1,%eax
c01010fc:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c0101102:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c0101107:	0f b7 15 84 7e 11 c0 	movzwl 0xc0117e84,%edx
c010110e:	0f b7 d2             	movzwl %dx,%edx
c0101111:	01 d2                	add    %edx,%edx
c0101113:	01 d0                	add    %edx,%eax
c0101115:	8b 55 08             	mov    0x8(%ebp),%edx
c0101118:	b2 00                	mov    $0x0,%dl
c010111a:	83 ca 20             	or     $0x20,%edx
c010111d:	66 89 10             	mov    %dx,(%eax)
        }
        break;
c0101120:	eb 70                	jmp    c0101192 <cga_putc+0xe0>
    case '\n':
        crt_pos += CRT_COLS;
c0101122:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101129:	83 c0 50             	add    $0x50,%eax
c010112c:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c0101132:	0f b7 1d 84 7e 11 c0 	movzwl 0xc0117e84,%ebx
c0101139:	0f b7 0d 84 7e 11 c0 	movzwl 0xc0117e84,%ecx
c0101140:	0f b7 c1             	movzwl %cx,%eax
c0101143:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c0101149:	c1 e8 10             	shr    $0x10,%eax
c010114c:	89 c2                	mov    %eax,%edx
c010114e:	66 c1 ea 06          	shr    $0x6,%dx
c0101152:	89 d0                	mov    %edx,%eax
c0101154:	c1 e0 02             	shl    $0x2,%eax
c0101157:	01 d0                	add    %edx,%eax
c0101159:	c1 e0 04             	shl    $0x4,%eax
c010115c:	29 c1                	sub    %eax,%ecx
c010115e:	89 ca                	mov    %ecx,%edx
c0101160:	89 d8                	mov    %ebx,%eax
c0101162:	29 d0                	sub    %edx,%eax
c0101164:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
        break;
c010116a:	eb 27                	jmp    c0101193 <cga_putc+0xe1>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c010116c:	8b 0d 80 7e 11 c0    	mov    0xc0117e80,%ecx
c0101172:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101179:	8d 50 01             	lea    0x1(%eax),%edx
c010117c:	66 89 15 84 7e 11 c0 	mov    %dx,0xc0117e84
c0101183:	0f b7 c0             	movzwl %ax,%eax
c0101186:	01 c0                	add    %eax,%eax
c0101188:	01 c8                	add    %ecx,%eax
c010118a:	8b 55 08             	mov    0x8(%ebp),%edx
c010118d:	66 89 10             	mov    %dx,(%eax)
        break;
c0101190:	eb 01                	jmp    c0101193 <cga_putc+0xe1>
    case '\b':
        if (crt_pos > 0) {
            crt_pos --;
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
        }
        break;
c0101192:	90                   	nop
        crt_buf[crt_pos ++] = c;     // write the character
        break;
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c0101193:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c010119a:	66 3d cf 07          	cmp    $0x7cf,%ax
c010119e:	76 59                	jbe    c01011f9 <cga_putc+0x147>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c01011a0:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c01011a5:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c01011ab:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c01011b0:	83 ec 04             	sub    $0x4,%esp
c01011b3:	68 00 0f 00 00       	push   $0xf00
c01011b8:	52                   	push   %edx
c01011b9:	50                   	push   %eax
c01011ba:	e8 39 41 00 00       	call   c01052f8 <memmove>
c01011bf:	83 c4 10             	add    $0x10,%esp
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c01011c2:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c01011c9:	eb 15                	jmp    c01011e0 <cga_putc+0x12e>
            crt_buf[i] = 0x0700 | ' ';
c01011cb:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c01011d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01011d3:	01 d2                	add    %edx,%edx
c01011d5:	01 d0                	add    %edx,%eax
c01011d7:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c01011dc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01011e0:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c01011e7:	7e e2                	jle    c01011cb <cga_putc+0x119>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
c01011e9:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c01011f0:	83 e8 50             	sub    $0x50,%eax
c01011f3:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c01011f9:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0101200:	0f b7 c0             	movzwl %ax,%eax
c0101203:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101207:	c6 45 e8 0e          	movb   $0xe,-0x18(%ebp)
c010120b:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
c010120f:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101213:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c0101214:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c010121b:	66 c1 e8 08          	shr    $0x8,%ax
c010121f:	0f b6 c0             	movzbl %al,%eax
c0101222:	0f b7 15 86 7e 11 c0 	movzwl 0xc0117e86,%edx
c0101229:	83 c2 01             	add    $0x1,%edx
c010122c:	0f b7 d2             	movzwl %dx,%edx
c010122f:	66 89 55 f0          	mov    %dx,-0x10(%ebp)
c0101233:	88 45 e9             	mov    %al,-0x17(%ebp)
c0101236:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c010123a:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
c010123e:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c010123f:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0101246:	0f b7 c0             	movzwl %ax,%eax
c0101249:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c010124d:	c6 45 ea 0f          	movb   $0xf,-0x16(%ebp)
c0101251:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
c0101255:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101259:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c010125a:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101261:	0f b6 c0             	movzbl %al,%eax
c0101264:	0f b7 15 86 7e 11 c0 	movzwl 0xc0117e86,%edx
c010126b:	83 c2 01             	add    $0x1,%edx
c010126e:	0f b7 d2             	movzwl %dx,%edx
c0101271:	66 89 55 ec          	mov    %dx,-0x14(%ebp)
c0101275:	88 45 eb             	mov    %al,-0x15(%ebp)
c0101278:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
c010127c:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
c0101280:	ee                   	out    %al,(%dx)
}
c0101281:	90                   	nop
c0101282:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0101285:	c9                   	leave  
c0101286:	c3                   	ret    

c0101287 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c0101287:	55                   	push   %ebp
c0101288:	89 e5                	mov    %esp,%ebp
c010128a:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c010128d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101294:	eb 09                	jmp    c010129f <serial_putc_sub+0x18>
        delay();
c0101296:	e8 51 fb ff ff       	call   c0100dec <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c010129b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010129f:	66 c7 45 f8 fd 03    	movw   $0x3fd,-0x8(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01012a5:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
c01012a9:	89 c2                	mov    %eax,%edx
c01012ab:	ec                   	in     (%dx),%al
c01012ac:	88 45 f7             	mov    %al,-0x9(%ebp)
    return data;
c01012af:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c01012b3:	0f b6 c0             	movzbl %al,%eax
c01012b6:	83 e0 20             	and    $0x20,%eax
c01012b9:	85 c0                	test   %eax,%eax
c01012bb:	75 09                	jne    c01012c6 <serial_putc_sub+0x3f>
c01012bd:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c01012c4:	7e d0                	jle    c0101296 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
c01012c6:	8b 45 08             	mov    0x8(%ebp),%eax
c01012c9:	0f b6 c0             	movzbl %al,%eax
c01012cc:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
c01012d2:	88 45 f6             	mov    %al,-0xa(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01012d5:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
c01012d9:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c01012dd:	ee                   	out    %al,(%dx)
}
c01012de:	90                   	nop
c01012df:	c9                   	leave  
c01012e0:	c3                   	ret    

c01012e1 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c01012e1:	55                   	push   %ebp
c01012e2:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
c01012e4:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01012e8:	74 0d                	je     c01012f7 <serial_putc+0x16>
        serial_putc_sub(c);
c01012ea:	ff 75 08             	pushl  0x8(%ebp)
c01012ed:	e8 95 ff ff ff       	call   c0101287 <serial_putc_sub>
c01012f2:	83 c4 04             	add    $0x4,%esp
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
c01012f5:	eb 1e                	jmp    c0101315 <serial_putc+0x34>
serial_putc(int c) {
    if (c != '\b') {
        serial_putc_sub(c);
    }
    else {
        serial_putc_sub('\b');
c01012f7:	6a 08                	push   $0x8
c01012f9:	e8 89 ff ff ff       	call   c0101287 <serial_putc_sub>
c01012fe:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub(' ');
c0101301:	6a 20                	push   $0x20
c0101303:	e8 7f ff ff ff       	call   c0101287 <serial_putc_sub>
c0101308:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub('\b');
c010130b:	6a 08                	push   $0x8
c010130d:	e8 75 ff ff ff       	call   c0101287 <serial_putc_sub>
c0101312:	83 c4 04             	add    $0x4,%esp
    }
}
c0101315:	90                   	nop
c0101316:	c9                   	leave  
c0101317:	c3                   	ret    

c0101318 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c0101318:	55                   	push   %ebp
c0101319:	89 e5                	mov    %esp,%ebp
c010131b:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c010131e:	eb 33                	jmp    c0101353 <cons_intr+0x3b>
        if (c != 0) {
c0101320:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101324:	74 2d                	je     c0101353 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c0101326:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c010132b:	8d 50 01             	lea    0x1(%eax),%edx
c010132e:	89 15 a4 80 11 c0    	mov    %edx,0xc01180a4
c0101334:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101337:	88 90 a0 7e 11 c0    	mov    %dl,-0x3fee8160(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c010133d:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c0101342:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101347:	75 0a                	jne    c0101353 <cons_intr+0x3b>
                cons.wpos = 0;
c0101349:	c7 05 a4 80 11 c0 00 	movl   $0x0,0xc01180a4
c0101350:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
c0101353:	8b 45 08             	mov    0x8(%ebp),%eax
c0101356:	ff d0                	call   *%eax
c0101358:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010135b:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c010135f:	75 bf                	jne    c0101320 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
c0101361:	90                   	nop
c0101362:	c9                   	leave  
c0101363:	c3                   	ret    

c0101364 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c0101364:	55                   	push   %ebp
c0101365:	89 e5                	mov    %esp,%ebp
c0101367:	83 ec 10             	sub    $0x10,%esp
c010136a:	66 c7 45 f8 fd 03    	movw   $0x3fd,-0x8(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101370:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
c0101374:	89 c2                	mov    %eax,%edx
c0101376:	ec                   	in     (%dx),%al
c0101377:	88 45 f7             	mov    %al,-0x9(%ebp)
    return data;
c010137a:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c010137e:	0f b6 c0             	movzbl %al,%eax
c0101381:	83 e0 01             	and    $0x1,%eax
c0101384:	85 c0                	test   %eax,%eax
c0101386:	75 07                	jne    c010138f <serial_proc_data+0x2b>
        return -1;
c0101388:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010138d:	eb 2a                	jmp    c01013b9 <serial_proc_data+0x55>
c010138f:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101395:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101399:	89 c2                	mov    %eax,%edx
c010139b:	ec                   	in     (%dx),%al
c010139c:	88 45 f6             	mov    %al,-0xa(%ebp)
    return data;
c010139f:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c01013a3:	0f b6 c0             	movzbl %al,%eax
c01013a6:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c01013a9:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c01013ad:	75 07                	jne    c01013b6 <serial_proc_data+0x52>
        c = '\b';
c01013af:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c01013b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01013b9:	c9                   	leave  
c01013ba:	c3                   	ret    

c01013bb <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c01013bb:	55                   	push   %ebp
c01013bc:	89 e5                	mov    %esp,%ebp
c01013be:	83 ec 08             	sub    $0x8,%esp
    if (serial_exists) {
c01013c1:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c01013c6:	85 c0                	test   %eax,%eax
c01013c8:	74 10                	je     c01013da <serial_intr+0x1f>
        cons_intr(serial_proc_data);
c01013ca:	83 ec 0c             	sub    $0xc,%esp
c01013cd:	68 64 13 10 c0       	push   $0xc0101364
c01013d2:	e8 41 ff ff ff       	call   c0101318 <cons_intr>
c01013d7:	83 c4 10             	add    $0x10,%esp
    }
}
c01013da:	90                   	nop
c01013db:	c9                   	leave  
c01013dc:	c3                   	ret    

c01013dd <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c01013dd:	55                   	push   %ebp
c01013de:	89 e5                	mov    %esp,%ebp
c01013e0:	83 ec 18             	sub    $0x18,%esp
c01013e3:	66 c7 45 ec 64 00    	movw   $0x64,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013e9:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01013ed:	89 c2                	mov    %eax,%edx
c01013ef:	ec                   	in     (%dx),%al
c01013f0:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c01013f3:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c01013f7:	0f b6 c0             	movzbl %al,%eax
c01013fa:	83 e0 01             	and    $0x1,%eax
c01013fd:	85 c0                	test   %eax,%eax
c01013ff:	75 0a                	jne    c010140b <kbd_proc_data+0x2e>
        return -1;
c0101401:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101406:	e9 5d 01 00 00       	jmp    c0101568 <kbd_proc_data+0x18b>
c010140b:	66 c7 45 f0 60 00    	movw   $0x60,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101411:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101415:	89 c2                	mov    %eax,%edx
c0101417:	ec                   	in     (%dx),%al
c0101418:	88 45 ea             	mov    %al,-0x16(%ebp)
    return data;
c010141b:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
    }

    data = inb(KBDATAP);
c010141f:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c0101422:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c0101426:	75 17                	jne    c010143f <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
c0101428:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c010142d:	83 c8 40             	or     $0x40,%eax
c0101430:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
        return 0;
c0101435:	b8 00 00 00 00       	mov    $0x0,%eax
c010143a:	e9 29 01 00 00       	jmp    c0101568 <kbd_proc_data+0x18b>
    } else if (data & 0x80) {
c010143f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101443:	84 c0                	test   %al,%al
c0101445:	79 47                	jns    c010148e <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c0101447:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c010144c:	83 e0 40             	and    $0x40,%eax
c010144f:	85 c0                	test   %eax,%eax
c0101451:	75 09                	jne    c010145c <kbd_proc_data+0x7f>
c0101453:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101457:	83 e0 7f             	and    $0x7f,%eax
c010145a:	eb 04                	jmp    c0101460 <kbd_proc_data+0x83>
c010145c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101460:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c0101463:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101467:	0f b6 80 60 70 11 c0 	movzbl -0x3fee8fa0(%eax),%eax
c010146e:	83 c8 40             	or     $0x40,%eax
c0101471:	0f b6 c0             	movzbl %al,%eax
c0101474:	f7 d0                	not    %eax
c0101476:	89 c2                	mov    %eax,%edx
c0101478:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c010147d:	21 d0                	and    %edx,%eax
c010147f:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
        return 0;
c0101484:	b8 00 00 00 00       	mov    $0x0,%eax
c0101489:	e9 da 00 00 00       	jmp    c0101568 <kbd_proc_data+0x18b>
    } else if (shift & E0ESC) {
c010148e:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101493:	83 e0 40             	and    $0x40,%eax
c0101496:	85 c0                	test   %eax,%eax
c0101498:	74 11                	je     c01014ab <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c010149a:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c010149e:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014a3:	83 e0 bf             	and    $0xffffffbf,%eax
c01014a6:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
    }

    shift |= shiftcode[data];
c01014ab:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014af:	0f b6 80 60 70 11 c0 	movzbl -0x3fee8fa0(%eax),%eax
c01014b6:	0f b6 d0             	movzbl %al,%edx
c01014b9:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014be:	09 d0                	or     %edx,%eax
c01014c0:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
    shift ^= togglecode[data];
c01014c5:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014c9:	0f b6 80 60 71 11 c0 	movzbl -0x3fee8ea0(%eax),%eax
c01014d0:	0f b6 d0             	movzbl %al,%edx
c01014d3:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014d8:	31 d0                	xor    %edx,%eax
c01014da:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8

    c = charcode[shift & (CTL | SHIFT)][data];
c01014df:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014e4:	83 e0 03             	and    $0x3,%eax
c01014e7:	8b 14 85 60 75 11 c0 	mov    -0x3fee8aa0(,%eax,4),%edx
c01014ee:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014f2:	01 d0                	add    %edx,%eax
c01014f4:	0f b6 00             	movzbl (%eax),%eax
c01014f7:	0f b6 c0             	movzbl %al,%eax
c01014fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c01014fd:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101502:	83 e0 08             	and    $0x8,%eax
c0101505:	85 c0                	test   %eax,%eax
c0101507:	74 22                	je     c010152b <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c0101509:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c010150d:	7e 0c                	jle    c010151b <kbd_proc_data+0x13e>
c010150f:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c0101513:	7f 06                	jg     c010151b <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c0101515:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c0101519:	eb 10                	jmp    c010152b <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c010151b:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c010151f:	7e 0a                	jle    c010152b <kbd_proc_data+0x14e>
c0101521:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c0101525:	7f 04                	jg     c010152b <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c0101527:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c010152b:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101530:	f7 d0                	not    %eax
c0101532:	83 e0 06             	and    $0x6,%eax
c0101535:	85 c0                	test   %eax,%eax
c0101537:	75 2c                	jne    c0101565 <kbd_proc_data+0x188>
c0101539:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c0101540:	75 23                	jne    c0101565 <kbd_proc_data+0x188>
        cprintf("Rebooting!\n");
c0101542:	83 ec 0c             	sub    $0xc,%esp
c0101545:	68 81 5d 10 c0       	push   $0xc0105d81
c010154a:	e8 18 ed ff ff       	call   c0100267 <cprintf>
c010154f:	83 c4 10             	add    $0x10,%esp
c0101552:	66 c7 45 ee 92 00    	movw   $0x92,-0x12(%ebp)
c0101558:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010155c:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101560:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101564:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c0101565:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101568:	c9                   	leave  
c0101569:	c3                   	ret    

c010156a <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c010156a:	55                   	push   %ebp
c010156b:	89 e5                	mov    %esp,%ebp
c010156d:	83 ec 08             	sub    $0x8,%esp
    cons_intr(kbd_proc_data);
c0101570:	83 ec 0c             	sub    $0xc,%esp
c0101573:	68 dd 13 10 c0       	push   $0xc01013dd
c0101578:	e8 9b fd ff ff       	call   c0101318 <cons_intr>
c010157d:	83 c4 10             	add    $0x10,%esp
}
c0101580:	90                   	nop
c0101581:	c9                   	leave  
c0101582:	c3                   	ret    

c0101583 <kbd_init>:

static void
kbd_init(void) {
c0101583:	55                   	push   %ebp
c0101584:	89 e5                	mov    %esp,%ebp
c0101586:	83 ec 08             	sub    $0x8,%esp
    // drain the kbd buffer
    kbd_intr();
c0101589:	e8 dc ff ff ff       	call   c010156a <kbd_intr>
    pic_enable(IRQ_KBD);
c010158e:	83 ec 0c             	sub    $0xc,%esp
c0101591:	6a 01                	push   $0x1
c0101593:	e8 4b 01 00 00       	call   c01016e3 <pic_enable>
c0101598:	83 c4 10             	add    $0x10,%esp
}
c010159b:	90                   	nop
c010159c:	c9                   	leave  
c010159d:	c3                   	ret    

c010159e <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c010159e:	55                   	push   %ebp
c010159f:	89 e5                	mov    %esp,%ebp
c01015a1:	83 ec 08             	sub    $0x8,%esp
    cga_init();
c01015a4:	e8 8c f8 ff ff       	call   c0100e35 <cga_init>
    serial_init();
c01015a9:	e8 6e f9 ff ff       	call   c0100f1c <serial_init>
    kbd_init();
c01015ae:	e8 d0 ff ff ff       	call   c0101583 <kbd_init>
    if (!serial_exists) {
c01015b3:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c01015b8:	85 c0                	test   %eax,%eax
c01015ba:	75 10                	jne    c01015cc <cons_init+0x2e>
        cprintf("serial port does not exist!!\n");
c01015bc:	83 ec 0c             	sub    $0xc,%esp
c01015bf:	68 8d 5d 10 c0       	push   $0xc0105d8d
c01015c4:	e8 9e ec ff ff       	call   c0100267 <cprintf>
c01015c9:	83 c4 10             	add    $0x10,%esp
    }
}
c01015cc:	90                   	nop
c01015cd:	c9                   	leave  
c01015ce:	c3                   	ret    

c01015cf <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c01015cf:	55                   	push   %ebp
c01015d0:	89 e5                	mov    %esp,%ebp
c01015d2:	83 ec 18             	sub    $0x18,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c01015d5:	e8 d4 f7 ff ff       	call   c0100dae <__intr_save>
c01015da:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c01015dd:	83 ec 0c             	sub    $0xc,%esp
c01015e0:	ff 75 08             	pushl  0x8(%ebp)
c01015e3:	e8 93 fa ff ff       	call   c010107b <lpt_putc>
c01015e8:	83 c4 10             	add    $0x10,%esp
        cga_putc(c);
c01015eb:	83 ec 0c             	sub    $0xc,%esp
c01015ee:	ff 75 08             	pushl  0x8(%ebp)
c01015f1:	e8 bc fa ff ff       	call   c01010b2 <cga_putc>
c01015f6:	83 c4 10             	add    $0x10,%esp
        serial_putc(c);
c01015f9:	83 ec 0c             	sub    $0xc,%esp
c01015fc:	ff 75 08             	pushl  0x8(%ebp)
c01015ff:	e8 dd fc ff ff       	call   c01012e1 <serial_putc>
c0101604:	83 c4 10             	add    $0x10,%esp
    }
    local_intr_restore(intr_flag);
c0101607:	83 ec 0c             	sub    $0xc,%esp
c010160a:	ff 75 f4             	pushl  -0xc(%ebp)
c010160d:	e8 c6 f7 ff ff       	call   c0100dd8 <__intr_restore>
c0101612:	83 c4 10             	add    $0x10,%esp
}
c0101615:	90                   	nop
c0101616:	c9                   	leave  
c0101617:	c3                   	ret    

c0101618 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c0101618:	55                   	push   %ebp
c0101619:	89 e5                	mov    %esp,%ebp
c010161b:	83 ec 18             	sub    $0x18,%esp
    int c = 0;
c010161e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0101625:	e8 84 f7 ff ff       	call   c0100dae <__intr_save>
c010162a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c010162d:	e8 89 fd ff ff       	call   c01013bb <serial_intr>
        kbd_intr();
c0101632:	e8 33 ff ff ff       	call   c010156a <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c0101637:	8b 15 a0 80 11 c0    	mov    0xc01180a0,%edx
c010163d:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c0101642:	39 c2                	cmp    %eax,%edx
c0101644:	74 31                	je     c0101677 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c0101646:	a1 a0 80 11 c0       	mov    0xc01180a0,%eax
c010164b:	8d 50 01             	lea    0x1(%eax),%edx
c010164e:	89 15 a0 80 11 c0    	mov    %edx,0xc01180a0
c0101654:	0f b6 80 a0 7e 11 c0 	movzbl -0x3fee8160(%eax),%eax
c010165b:	0f b6 c0             	movzbl %al,%eax
c010165e:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c0101661:	a1 a0 80 11 c0       	mov    0xc01180a0,%eax
c0101666:	3d 00 02 00 00       	cmp    $0x200,%eax
c010166b:	75 0a                	jne    c0101677 <cons_getc+0x5f>
                cons.rpos = 0;
c010166d:	c7 05 a0 80 11 c0 00 	movl   $0x0,0xc01180a0
c0101674:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c0101677:	83 ec 0c             	sub    $0xc,%esp
c010167a:	ff 75 f0             	pushl  -0x10(%ebp)
c010167d:	e8 56 f7 ff ff       	call   c0100dd8 <__intr_restore>
c0101682:	83 c4 10             	add    $0x10,%esp
    return c;
c0101685:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101688:	c9                   	leave  
c0101689:	c3                   	ret    

c010168a <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c010168a:	55                   	push   %ebp
c010168b:	89 e5                	mov    %esp,%ebp
c010168d:	83 ec 14             	sub    $0x14,%esp
c0101690:	8b 45 08             	mov    0x8(%ebp),%eax
c0101693:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c0101697:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c010169b:	66 a3 70 75 11 c0    	mov    %ax,0xc0117570
    if (did_init) {
c01016a1:	a1 ac 80 11 c0       	mov    0xc01180ac,%eax
c01016a6:	85 c0                	test   %eax,%eax
c01016a8:	74 36                	je     c01016e0 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c01016aa:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016ae:	0f b6 c0             	movzbl %al,%eax
c01016b1:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c01016b7:	88 45 fa             	mov    %al,-0x6(%ebp)
c01016ba:	0f b6 45 fa          	movzbl -0x6(%ebp),%eax
c01016be:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c01016c2:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c01016c3:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016c7:	66 c1 e8 08          	shr    $0x8,%ax
c01016cb:	0f b6 c0             	movzbl %al,%eax
c01016ce:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
c01016d4:	88 45 fb             	mov    %al,-0x5(%ebp)
c01016d7:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c01016db:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
c01016df:	ee                   	out    %al,(%dx)
    }
}
c01016e0:	90                   	nop
c01016e1:	c9                   	leave  
c01016e2:	c3                   	ret    

c01016e3 <pic_enable>:

void
pic_enable(unsigned int irq) {
c01016e3:	55                   	push   %ebp
c01016e4:	89 e5                	mov    %esp,%ebp
    pic_setmask(irq_mask & ~(1 << irq));
c01016e6:	8b 45 08             	mov    0x8(%ebp),%eax
c01016e9:	ba 01 00 00 00       	mov    $0x1,%edx
c01016ee:	89 c1                	mov    %eax,%ecx
c01016f0:	d3 e2                	shl    %cl,%edx
c01016f2:	89 d0                	mov    %edx,%eax
c01016f4:	f7 d0                	not    %eax
c01016f6:	89 c2                	mov    %eax,%edx
c01016f8:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c01016ff:	21 d0                	and    %edx,%eax
c0101701:	0f b7 c0             	movzwl %ax,%eax
c0101704:	50                   	push   %eax
c0101705:	e8 80 ff ff ff       	call   c010168a <pic_setmask>
c010170a:	83 c4 04             	add    $0x4,%esp
}
c010170d:	90                   	nop
c010170e:	c9                   	leave  
c010170f:	c3                   	ret    

c0101710 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c0101710:	55                   	push   %ebp
c0101711:	89 e5                	mov    %esp,%ebp
c0101713:	83 ec 30             	sub    $0x30,%esp
    did_init = 1;
c0101716:	c7 05 ac 80 11 c0 01 	movl   $0x1,0xc01180ac
c010171d:	00 00 00 
c0101720:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101726:	c6 45 d6 ff          	movb   $0xff,-0x2a(%ebp)
c010172a:	0f b6 45 d6          	movzbl -0x2a(%ebp),%eax
c010172e:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101732:	ee                   	out    %al,(%dx)
c0101733:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
c0101739:	c6 45 d7 ff          	movb   $0xff,-0x29(%ebp)
c010173d:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
c0101741:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
c0101745:	ee                   	out    %al,(%dx)
c0101746:	66 c7 45 fa 20 00    	movw   $0x20,-0x6(%ebp)
c010174c:	c6 45 d8 11          	movb   $0x11,-0x28(%ebp)
c0101750:	0f b6 45 d8          	movzbl -0x28(%ebp),%eax
c0101754:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101758:	ee                   	out    %al,(%dx)
c0101759:	66 c7 45 f8 21 00    	movw   $0x21,-0x8(%ebp)
c010175f:	c6 45 d9 20          	movb   $0x20,-0x27(%ebp)
c0101763:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101767:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
c010176b:	ee                   	out    %al,(%dx)
c010176c:	66 c7 45 f6 21 00    	movw   $0x21,-0xa(%ebp)
c0101772:	c6 45 da 04          	movb   $0x4,-0x26(%ebp)
c0101776:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
c010177a:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010177e:	ee                   	out    %al,(%dx)
c010177f:	66 c7 45 f4 21 00    	movw   $0x21,-0xc(%ebp)
c0101785:	c6 45 db 03          	movb   $0x3,-0x25(%ebp)
c0101789:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
c010178d:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
c0101791:	ee                   	out    %al,(%dx)
c0101792:	66 c7 45 f2 a0 00    	movw   $0xa0,-0xe(%ebp)
c0101798:	c6 45 dc 11          	movb   $0x11,-0x24(%ebp)
c010179c:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
c01017a0:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01017a4:	ee                   	out    %al,(%dx)
c01017a5:	66 c7 45 f0 a1 00    	movw   $0xa1,-0x10(%ebp)
c01017ab:	c6 45 dd 28          	movb   $0x28,-0x23(%ebp)
c01017af:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c01017b3:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
c01017b7:	ee                   	out    %al,(%dx)
c01017b8:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
c01017be:	c6 45 de 02          	movb   $0x2,-0x22(%ebp)
c01017c2:	0f b6 45 de          	movzbl -0x22(%ebp),%eax
c01017c6:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01017ca:	ee                   	out    %al,(%dx)
c01017cb:	66 c7 45 ec a1 00    	movw   $0xa1,-0x14(%ebp)
c01017d1:	c6 45 df 03          	movb   $0x3,-0x21(%ebp)
c01017d5:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
c01017d9:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
c01017dd:	ee                   	out    %al,(%dx)
c01017de:	66 c7 45 ea 20 00    	movw   $0x20,-0x16(%ebp)
c01017e4:	c6 45 e0 68          	movb   $0x68,-0x20(%ebp)
c01017e8:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
c01017ec:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01017f0:	ee                   	out    %al,(%dx)
c01017f1:	66 c7 45 e8 20 00    	movw   $0x20,-0x18(%ebp)
c01017f7:	c6 45 e1 0a          	movb   $0xa,-0x1f(%ebp)
c01017fb:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c01017ff:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c0101803:	ee                   	out    %al,(%dx)
c0101804:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c010180a:	c6 45 e2 68          	movb   $0x68,-0x1e(%ebp)
c010180e:	0f b6 45 e2          	movzbl -0x1e(%ebp),%eax
c0101812:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101816:	ee                   	out    %al,(%dx)
c0101817:	66 c7 45 e4 a0 00    	movw   $0xa0,-0x1c(%ebp)
c010181d:	c6 45 e3 0a          	movb   $0xa,-0x1d(%ebp)
c0101821:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
c0101825:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
c0101829:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c010182a:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c0101831:	66 83 f8 ff          	cmp    $0xffff,%ax
c0101835:	74 13                	je     c010184a <pic_init+0x13a>
        pic_setmask(irq_mask);
c0101837:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c010183e:	0f b7 c0             	movzwl %ax,%eax
c0101841:	50                   	push   %eax
c0101842:	e8 43 fe ff ff       	call   c010168a <pic_setmask>
c0101847:	83 c4 04             	add    $0x4,%esp
    }
}
c010184a:	90                   	nop
c010184b:	c9                   	leave  
c010184c:	c3                   	ret    

c010184d <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c010184d:	55                   	push   %ebp
c010184e:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
c0101850:	fb                   	sti    
    sti();
}
c0101851:	90                   	nop
c0101852:	5d                   	pop    %ebp
c0101853:	c3                   	ret    

c0101854 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c0101854:	55                   	push   %ebp
c0101855:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
c0101857:	fa                   	cli    
    cli();
}
c0101858:	90                   	nop
c0101859:	5d                   	pop    %ebp
c010185a:	c3                   	ret    

c010185b <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c010185b:	55                   	push   %ebp
c010185c:	89 e5                	mov    %esp,%ebp
c010185e:	83 ec 08             	sub    $0x8,%esp
    cprintf("%d ticks\n",TICK_NUM);
c0101861:	83 ec 08             	sub    $0x8,%esp
c0101864:	6a 64                	push   $0x64
c0101866:	68 c0 5d 10 c0       	push   $0xc0105dc0
c010186b:	e8 f7 e9 ff ff       	call   c0100267 <cprintf>
c0101870:	83 c4 10             	add    $0x10,%esp
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
c0101873:	90                   	nop
c0101874:	c9                   	leave  
c0101875:	c3                   	ret    

c0101876 <idt_init>:
    */    
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c0101876:	55                   	push   %ebp
c0101877:	89 e5                	mov    %esp,%ebp
c0101879:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
        extern uintptr_t __vectors[];
        int i;
        for(i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++){
c010187c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101883:	e9 c3 00 00 00       	jmp    c010194b <idt_init+0xd5>
                SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
c0101888:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010188b:	8b 04 85 00 76 11 c0 	mov    -0x3fee8a00(,%eax,4),%eax
c0101892:	89 c2                	mov    %eax,%edx
c0101894:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101897:	66 89 14 c5 c0 80 11 	mov    %dx,-0x3fee7f40(,%eax,8)
c010189e:	c0 
c010189f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018a2:	66 c7 04 c5 c2 80 11 	movw   $0x8,-0x3fee7f3e(,%eax,8)
c01018a9:	c0 08 00 
c01018ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018af:	0f b6 14 c5 c4 80 11 	movzbl -0x3fee7f3c(,%eax,8),%edx
c01018b6:	c0 
c01018b7:	83 e2 e0             	and    $0xffffffe0,%edx
c01018ba:	88 14 c5 c4 80 11 c0 	mov    %dl,-0x3fee7f3c(,%eax,8)
c01018c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018c4:	0f b6 14 c5 c4 80 11 	movzbl -0x3fee7f3c(,%eax,8),%edx
c01018cb:	c0 
c01018cc:	83 e2 1f             	and    $0x1f,%edx
c01018cf:	88 14 c5 c4 80 11 c0 	mov    %dl,-0x3fee7f3c(,%eax,8)
c01018d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018d9:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c01018e0:	c0 
c01018e1:	83 e2 f0             	and    $0xfffffff0,%edx
c01018e4:	83 ca 0e             	or     $0xe,%edx
c01018e7:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c01018ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018f1:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c01018f8:	c0 
c01018f9:	83 e2 ef             	and    $0xffffffef,%edx
c01018fc:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101903:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101906:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c010190d:	c0 
c010190e:	83 e2 9f             	and    $0xffffff9f,%edx
c0101911:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101918:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010191b:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c0101922:	c0 
c0101923:	83 ca 80             	or     $0xffffff80,%edx
c0101926:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c010192d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101930:	8b 04 85 00 76 11 c0 	mov    -0x3fee8a00(,%eax,4),%eax
c0101937:	c1 e8 10             	shr    $0x10,%eax
c010193a:	89 c2                	mov    %eax,%edx
c010193c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010193f:	66 89 14 c5 c6 80 11 	mov    %dx,-0x3fee7f3a(,%eax,8)
c0101946:	c0 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
        extern uintptr_t __vectors[];
        int i;
        for(i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++){
c0101947:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010194b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010194e:	3d ff 00 00 00       	cmp    $0xff,%eax
c0101953:	0f 86 2f ff ff ff    	jbe    c0101888 <idt_init+0x12>
                SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
        }
        SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
c0101959:	a1 e4 77 11 c0       	mov    0xc01177e4,%eax
c010195e:	66 a3 88 84 11 c0    	mov    %ax,0xc0118488
c0101964:	66 c7 05 8a 84 11 c0 	movw   $0x8,0xc011848a
c010196b:	08 00 
c010196d:	0f b6 05 8c 84 11 c0 	movzbl 0xc011848c,%eax
c0101974:	83 e0 e0             	and    $0xffffffe0,%eax
c0101977:	a2 8c 84 11 c0       	mov    %al,0xc011848c
c010197c:	0f b6 05 8c 84 11 c0 	movzbl 0xc011848c,%eax
c0101983:	83 e0 1f             	and    $0x1f,%eax
c0101986:	a2 8c 84 11 c0       	mov    %al,0xc011848c
c010198b:	0f b6 05 8d 84 11 c0 	movzbl 0xc011848d,%eax
c0101992:	83 e0 f0             	and    $0xfffffff0,%eax
c0101995:	83 c8 0e             	or     $0xe,%eax
c0101998:	a2 8d 84 11 c0       	mov    %al,0xc011848d
c010199d:	0f b6 05 8d 84 11 c0 	movzbl 0xc011848d,%eax
c01019a4:	83 e0 ef             	and    $0xffffffef,%eax
c01019a7:	a2 8d 84 11 c0       	mov    %al,0xc011848d
c01019ac:	0f b6 05 8d 84 11 c0 	movzbl 0xc011848d,%eax
c01019b3:	83 c8 60             	or     $0x60,%eax
c01019b6:	a2 8d 84 11 c0       	mov    %al,0xc011848d
c01019bb:	0f b6 05 8d 84 11 c0 	movzbl 0xc011848d,%eax
c01019c2:	83 c8 80             	or     $0xffffff80,%eax
c01019c5:	a2 8d 84 11 c0       	mov    %al,0xc011848d
c01019ca:	a1 e4 77 11 c0       	mov    0xc01177e4,%eax
c01019cf:	c1 e8 10             	shr    $0x10,%eax
c01019d2:	66 a3 8e 84 11 c0    	mov    %ax,0xc011848e
c01019d8:	c7 45 f8 80 75 11 c0 	movl   $0xc0117580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c01019df:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01019e2:	0f 01 18             	lidtl  (%eax)

        //load the IDT，和lgdt相似？
        lidt(&idt_pd);
}
c01019e5:	90                   	nop
c01019e6:	c9                   	leave  
c01019e7:	c3                   	ret    

c01019e8 <trapname>:

static const char *
trapname(int trapno) {
c01019e8:	55                   	push   %ebp
c01019e9:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c01019eb:	8b 45 08             	mov    0x8(%ebp),%eax
c01019ee:	83 f8 13             	cmp    $0x13,%eax
c01019f1:	77 0c                	ja     c01019ff <trapname+0x17>
        return excnames[trapno];
c01019f3:	8b 45 08             	mov    0x8(%ebp),%eax
c01019f6:	8b 04 85 20 61 10 c0 	mov    -0x3fef9ee0(,%eax,4),%eax
c01019fd:	eb 18                	jmp    c0101a17 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c01019ff:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0101a03:	7e 0d                	jle    c0101a12 <trapname+0x2a>
c0101a05:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0101a09:	7f 07                	jg     c0101a12 <trapname+0x2a>
        return "Hardware Interrupt";
c0101a0b:	b8 ca 5d 10 c0       	mov    $0xc0105dca,%eax
c0101a10:	eb 05                	jmp    c0101a17 <trapname+0x2f>
    }
    return "(unknown trap)";
c0101a12:	b8 dd 5d 10 c0       	mov    $0xc0105ddd,%eax
}
c0101a17:	5d                   	pop    %ebp
c0101a18:	c3                   	ret    

c0101a19 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c0101a19:	55                   	push   %ebp
c0101a1a:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c0101a1c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a1f:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101a23:	66 83 f8 08          	cmp    $0x8,%ax
c0101a27:	0f 94 c0             	sete   %al
c0101a2a:	0f b6 c0             	movzbl %al,%eax
}
c0101a2d:	5d                   	pop    %ebp
c0101a2e:	c3                   	ret    

c0101a2f <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0101a2f:	55                   	push   %ebp
c0101a30:	89 e5                	mov    %esp,%ebp
c0101a32:	83 ec 18             	sub    $0x18,%esp
    cprintf("trapframe at %p\n", tf);
c0101a35:	83 ec 08             	sub    $0x8,%esp
c0101a38:	ff 75 08             	pushl  0x8(%ebp)
c0101a3b:	68 1e 5e 10 c0       	push   $0xc0105e1e
c0101a40:	e8 22 e8 ff ff       	call   c0100267 <cprintf>
c0101a45:	83 c4 10             	add    $0x10,%esp
    print_regs(&tf->tf_regs);
c0101a48:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a4b:	83 ec 0c             	sub    $0xc,%esp
c0101a4e:	50                   	push   %eax
c0101a4f:	e8 b8 01 00 00       	call   c0101c0c <print_regs>
c0101a54:	83 c4 10             	add    $0x10,%esp
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101a57:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a5a:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101a5e:	0f b7 c0             	movzwl %ax,%eax
c0101a61:	83 ec 08             	sub    $0x8,%esp
c0101a64:	50                   	push   %eax
c0101a65:	68 2f 5e 10 c0       	push   $0xc0105e2f
c0101a6a:	e8 f8 e7 ff ff       	call   c0100267 <cprintf>
c0101a6f:	83 c4 10             	add    $0x10,%esp
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101a72:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a75:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101a79:	0f b7 c0             	movzwl %ax,%eax
c0101a7c:	83 ec 08             	sub    $0x8,%esp
c0101a7f:	50                   	push   %eax
c0101a80:	68 42 5e 10 c0       	push   $0xc0105e42
c0101a85:	e8 dd e7 ff ff       	call   c0100267 <cprintf>
c0101a8a:	83 c4 10             	add    $0x10,%esp
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101a8d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a90:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101a94:	0f b7 c0             	movzwl %ax,%eax
c0101a97:	83 ec 08             	sub    $0x8,%esp
c0101a9a:	50                   	push   %eax
c0101a9b:	68 55 5e 10 c0       	push   $0xc0105e55
c0101aa0:	e8 c2 e7 ff ff       	call   c0100267 <cprintf>
c0101aa5:	83 c4 10             	add    $0x10,%esp
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101aa8:	8b 45 08             	mov    0x8(%ebp),%eax
c0101aab:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101aaf:	0f b7 c0             	movzwl %ax,%eax
c0101ab2:	83 ec 08             	sub    $0x8,%esp
c0101ab5:	50                   	push   %eax
c0101ab6:	68 68 5e 10 c0       	push   $0xc0105e68
c0101abb:	e8 a7 e7 ff ff       	call   c0100267 <cprintf>
c0101ac0:	83 c4 10             	add    $0x10,%esp
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0101ac3:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ac6:	8b 40 30             	mov    0x30(%eax),%eax
c0101ac9:	83 ec 0c             	sub    $0xc,%esp
c0101acc:	50                   	push   %eax
c0101acd:	e8 16 ff ff ff       	call   c01019e8 <trapname>
c0101ad2:	83 c4 10             	add    $0x10,%esp
c0101ad5:	89 c2                	mov    %eax,%edx
c0101ad7:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ada:	8b 40 30             	mov    0x30(%eax),%eax
c0101add:	83 ec 04             	sub    $0x4,%esp
c0101ae0:	52                   	push   %edx
c0101ae1:	50                   	push   %eax
c0101ae2:	68 7b 5e 10 c0       	push   $0xc0105e7b
c0101ae7:	e8 7b e7 ff ff       	call   c0100267 <cprintf>
c0101aec:	83 c4 10             	add    $0x10,%esp
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101aef:	8b 45 08             	mov    0x8(%ebp),%eax
c0101af2:	8b 40 34             	mov    0x34(%eax),%eax
c0101af5:	83 ec 08             	sub    $0x8,%esp
c0101af8:	50                   	push   %eax
c0101af9:	68 8d 5e 10 c0       	push   $0xc0105e8d
c0101afe:	e8 64 e7 ff ff       	call   c0100267 <cprintf>
c0101b03:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101b06:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b09:	8b 40 38             	mov    0x38(%eax),%eax
c0101b0c:	83 ec 08             	sub    $0x8,%esp
c0101b0f:	50                   	push   %eax
c0101b10:	68 9c 5e 10 c0       	push   $0xc0105e9c
c0101b15:	e8 4d e7 ff ff       	call   c0100267 <cprintf>
c0101b1a:	83 c4 10             	add    $0x10,%esp
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101b1d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b20:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101b24:	0f b7 c0             	movzwl %ax,%eax
c0101b27:	83 ec 08             	sub    $0x8,%esp
c0101b2a:	50                   	push   %eax
c0101b2b:	68 ab 5e 10 c0       	push   $0xc0105eab
c0101b30:	e8 32 e7 ff ff       	call   c0100267 <cprintf>
c0101b35:	83 c4 10             	add    $0x10,%esp
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101b38:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b3b:	8b 40 40             	mov    0x40(%eax),%eax
c0101b3e:	83 ec 08             	sub    $0x8,%esp
c0101b41:	50                   	push   %eax
c0101b42:	68 be 5e 10 c0       	push   $0xc0105ebe
c0101b47:	e8 1b e7 ff ff       	call   c0100267 <cprintf>
c0101b4c:	83 c4 10             	add    $0x10,%esp

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101b4f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101b56:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101b5d:	eb 3f                	jmp    c0101b9e <print_trapframe+0x16f>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0101b5f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b62:	8b 50 40             	mov    0x40(%eax),%edx
c0101b65:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101b68:	21 d0                	and    %edx,%eax
c0101b6a:	85 c0                	test   %eax,%eax
c0101b6c:	74 29                	je     c0101b97 <print_trapframe+0x168>
c0101b6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b71:	8b 04 85 a0 75 11 c0 	mov    -0x3fee8a60(,%eax,4),%eax
c0101b78:	85 c0                	test   %eax,%eax
c0101b7a:	74 1b                	je     c0101b97 <print_trapframe+0x168>
            cprintf("%s,", IA32flags[i]);
c0101b7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b7f:	8b 04 85 a0 75 11 c0 	mov    -0x3fee8a60(,%eax,4),%eax
c0101b86:	83 ec 08             	sub    $0x8,%esp
c0101b89:	50                   	push   %eax
c0101b8a:	68 cd 5e 10 c0       	push   $0xc0105ecd
c0101b8f:	e8 d3 e6 ff ff       	call   c0100267 <cprintf>
c0101b94:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101b97:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101b9b:	d1 65 f0             	shll   -0x10(%ebp)
c0101b9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101ba1:	83 f8 17             	cmp    $0x17,%eax
c0101ba4:	76 b9                	jbe    c0101b5f <print_trapframe+0x130>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101ba6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ba9:	8b 40 40             	mov    0x40(%eax),%eax
c0101bac:	25 00 30 00 00       	and    $0x3000,%eax
c0101bb1:	c1 e8 0c             	shr    $0xc,%eax
c0101bb4:	83 ec 08             	sub    $0x8,%esp
c0101bb7:	50                   	push   %eax
c0101bb8:	68 d1 5e 10 c0       	push   $0xc0105ed1
c0101bbd:	e8 a5 e6 ff ff       	call   c0100267 <cprintf>
c0101bc2:	83 c4 10             	add    $0x10,%esp

    if (!trap_in_kernel(tf)) {
c0101bc5:	83 ec 0c             	sub    $0xc,%esp
c0101bc8:	ff 75 08             	pushl  0x8(%ebp)
c0101bcb:	e8 49 fe ff ff       	call   c0101a19 <trap_in_kernel>
c0101bd0:	83 c4 10             	add    $0x10,%esp
c0101bd3:	85 c0                	test   %eax,%eax
c0101bd5:	75 32                	jne    c0101c09 <print_trapframe+0x1da>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0101bd7:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bda:	8b 40 44             	mov    0x44(%eax),%eax
c0101bdd:	83 ec 08             	sub    $0x8,%esp
c0101be0:	50                   	push   %eax
c0101be1:	68 da 5e 10 c0       	push   $0xc0105eda
c0101be6:	e8 7c e6 ff ff       	call   c0100267 <cprintf>
c0101beb:	83 c4 10             	add    $0x10,%esp
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101bee:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bf1:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101bf5:	0f b7 c0             	movzwl %ax,%eax
c0101bf8:	83 ec 08             	sub    $0x8,%esp
c0101bfb:	50                   	push   %eax
c0101bfc:	68 e9 5e 10 c0       	push   $0xc0105ee9
c0101c01:	e8 61 e6 ff ff       	call   c0100267 <cprintf>
c0101c06:	83 c4 10             	add    $0x10,%esp
    }
}
c0101c09:	90                   	nop
c0101c0a:	c9                   	leave  
c0101c0b:	c3                   	ret    

c0101c0c <print_regs>:

void
print_regs(struct pushregs *regs) {
c0101c0c:	55                   	push   %ebp
c0101c0d:	89 e5                	mov    %esp,%ebp
c0101c0f:	83 ec 08             	sub    $0x8,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101c12:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c15:	8b 00                	mov    (%eax),%eax
c0101c17:	83 ec 08             	sub    $0x8,%esp
c0101c1a:	50                   	push   %eax
c0101c1b:	68 fc 5e 10 c0       	push   $0xc0105efc
c0101c20:	e8 42 e6 ff ff       	call   c0100267 <cprintf>
c0101c25:	83 c4 10             	add    $0x10,%esp
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101c28:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c2b:	8b 40 04             	mov    0x4(%eax),%eax
c0101c2e:	83 ec 08             	sub    $0x8,%esp
c0101c31:	50                   	push   %eax
c0101c32:	68 0b 5f 10 c0       	push   $0xc0105f0b
c0101c37:	e8 2b e6 ff ff       	call   c0100267 <cprintf>
c0101c3c:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101c3f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c42:	8b 40 08             	mov    0x8(%eax),%eax
c0101c45:	83 ec 08             	sub    $0x8,%esp
c0101c48:	50                   	push   %eax
c0101c49:	68 1a 5f 10 c0       	push   $0xc0105f1a
c0101c4e:	e8 14 e6 ff ff       	call   c0100267 <cprintf>
c0101c53:	83 c4 10             	add    $0x10,%esp
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101c56:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c59:	8b 40 0c             	mov    0xc(%eax),%eax
c0101c5c:	83 ec 08             	sub    $0x8,%esp
c0101c5f:	50                   	push   %eax
c0101c60:	68 29 5f 10 c0       	push   $0xc0105f29
c0101c65:	e8 fd e5 ff ff       	call   c0100267 <cprintf>
c0101c6a:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101c6d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c70:	8b 40 10             	mov    0x10(%eax),%eax
c0101c73:	83 ec 08             	sub    $0x8,%esp
c0101c76:	50                   	push   %eax
c0101c77:	68 38 5f 10 c0       	push   $0xc0105f38
c0101c7c:	e8 e6 e5 ff ff       	call   c0100267 <cprintf>
c0101c81:	83 c4 10             	add    $0x10,%esp
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101c84:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c87:	8b 40 14             	mov    0x14(%eax),%eax
c0101c8a:	83 ec 08             	sub    $0x8,%esp
c0101c8d:	50                   	push   %eax
c0101c8e:	68 47 5f 10 c0       	push   $0xc0105f47
c0101c93:	e8 cf e5 ff ff       	call   c0100267 <cprintf>
c0101c98:	83 c4 10             	add    $0x10,%esp
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101c9b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c9e:	8b 40 18             	mov    0x18(%eax),%eax
c0101ca1:	83 ec 08             	sub    $0x8,%esp
c0101ca4:	50                   	push   %eax
c0101ca5:	68 56 5f 10 c0       	push   $0xc0105f56
c0101caa:	e8 b8 e5 ff ff       	call   c0100267 <cprintf>
c0101caf:	83 c4 10             	add    $0x10,%esp
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101cb2:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cb5:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101cb8:	83 ec 08             	sub    $0x8,%esp
c0101cbb:	50                   	push   %eax
c0101cbc:	68 65 5f 10 c0       	push   $0xc0105f65
c0101cc1:	e8 a1 e5 ff ff       	call   c0100267 <cprintf>
c0101cc6:	83 c4 10             	add    $0x10,%esp
}
c0101cc9:	90                   	nop
c0101cca:	c9                   	leave  
c0101ccb:	c3                   	ret    

c0101ccc <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c0101ccc:	55                   	push   %ebp
c0101ccd:	89 e5                	mov    %esp,%ebp
c0101ccf:	83 ec 18             	sub    $0x18,%esp
    char c;

    switch (tf->tf_trapno) {
c0101cd2:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cd5:	8b 40 30             	mov    0x30(%eax),%eax
c0101cd8:	83 f8 2f             	cmp    $0x2f,%eax
c0101cdb:	77 1d                	ja     c0101cfa <trap_dispatch+0x2e>
c0101cdd:	83 f8 2e             	cmp    $0x2e,%eax
c0101ce0:	0f 83 f4 00 00 00    	jae    c0101dda <trap_dispatch+0x10e>
c0101ce6:	83 f8 21             	cmp    $0x21,%eax
c0101ce9:	74 7e                	je     c0101d69 <trap_dispatch+0x9d>
c0101ceb:	83 f8 24             	cmp    $0x24,%eax
c0101cee:	74 55                	je     c0101d45 <trap_dispatch+0x79>
c0101cf0:	83 f8 20             	cmp    $0x20,%eax
c0101cf3:	74 16                	je     c0101d0b <trap_dispatch+0x3f>
c0101cf5:	e9 aa 00 00 00       	jmp    c0101da4 <trap_dispatch+0xd8>
c0101cfa:	83 e8 78             	sub    $0x78,%eax
c0101cfd:	83 f8 01             	cmp    $0x1,%eax
c0101d00:	0f 87 9e 00 00 00    	ja     c0101da4 <trap_dispatch+0xd8>
c0101d06:	e9 82 00 00 00       	jmp    c0101d8d <trap_dispatch+0xc1>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
c0101d0b:	a1 4c 89 11 c0       	mov    0xc011894c,%eax
c0101d10:	83 c0 01             	add    $0x1,%eax
c0101d13:	a3 4c 89 11 c0       	mov    %eax,0xc011894c
        if(ticks % TICK_NUM == 0)
c0101d18:	8b 0d 4c 89 11 c0    	mov    0xc011894c,%ecx
c0101d1e:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c0101d23:	89 c8                	mov    %ecx,%eax
c0101d25:	f7 e2                	mul    %edx
c0101d27:	89 d0                	mov    %edx,%eax
c0101d29:	c1 e8 05             	shr    $0x5,%eax
c0101d2c:	6b c0 64             	imul   $0x64,%eax,%eax
c0101d2f:	29 c1                	sub    %eax,%ecx
c0101d31:	89 c8                	mov    %ecx,%eax
c0101d33:	85 c0                	test   %eax,%eax
c0101d35:	0f 85 a2 00 00 00    	jne    c0101ddd <trap_dispatch+0x111>
                print_ticks();
c0101d3b:	e8 1b fb ff ff       	call   c010185b <print_ticks>
        break;
c0101d40:	e9 98 00 00 00       	jmp    c0101ddd <trap_dispatch+0x111>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0101d45:	e8 ce f8 ff ff       	call   c0101618 <cons_getc>
c0101d4a:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101d4d:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101d51:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101d55:	83 ec 04             	sub    $0x4,%esp
c0101d58:	52                   	push   %edx
c0101d59:	50                   	push   %eax
c0101d5a:	68 74 5f 10 c0       	push   $0xc0105f74
c0101d5f:	e8 03 e5 ff ff       	call   c0100267 <cprintf>
c0101d64:	83 c4 10             	add    $0x10,%esp
        break;
c0101d67:	eb 75                	jmp    c0101dde <trap_dispatch+0x112>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0101d69:	e8 aa f8 ff ff       	call   c0101618 <cons_getc>
c0101d6e:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0101d71:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101d75:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101d79:	83 ec 04             	sub    $0x4,%esp
c0101d7c:	52                   	push   %edx
c0101d7d:	50                   	push   %eax
c0101d7e:	68 86 5f 10 c0       	push   $0xc0105f86
c0101d83:	e8 df e4 ff ff       	call   c0100267 <cprintf>
c0101d88:	83 c4 10             	add    $0x10,%esp
        break;
c0101d8b:	eb 51                	jmp    c0101dde <trap_dispatch+0x112>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c0101d8d:	83 ec 04             	sub    $0x4,%esp
c0101d90:	68 95 5f 10 c0       	push   $0xc0105f95
c0101d95:	68 b4 00 00 00       	push   $0xb4
c0101d9a:	68 a5 5f 10 c0       	push   $0xc0105fa5
c0101d9f:	e8 29 e6 ff ff       	call   c01003cd <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0101da4:	8b 45 08             	mov    0x8(%ebp),%eax
c0101da7:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101dab:	0f b7 c0             	movzwl %ax,%eax
c0101dae:	83 e0 03             	and    $0x3,%eax
c0101db1:	85 c0                	test   %eax,%eax
c0101db3:	75 29                	jne    c0101dde <trap_dispatch+0x112>
            print_trapframe(tf);
c0101db5:	83 ec 0c             	sub    $0xc,%esp
c0101db8:	ff 75 08             	pushl  0x8(%ebp)
c0101dbb:	e8 6f fc ff ff       	call   c0101a2f <print_trapframe>
c0101dc0:	83 c4 10             	add    $0x10,%esp
            panic("unexpected trap in kernel.\n");
c0101dc3:	83 ec 04             	sub    $0x4,%esp
c0101dc6:	68 b6 5f 10 c0       	push   $0xc0105fb6
c0101dcb:	68 be 00 00 00       	push   $0xbe
c0101dd0:	68 a5 5f 10 c0       	push   $0xc0105fa5
c0101dd5:	e8 f3 e5 ff ff       	call   c01003cd <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c0101dda:	90                   	nop
c0101ddb:	eb 01                	jmp    c0101dde <trap_dispatch+0x112>
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
        if(ticks % TICK_NUM == 0)
                print_ticks();
        break;
c0101ddd:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
c0101dde:	90                   	nop
c0101ddf:	c9                   	leave  
c0101de0:	c3                   	ret    

c0101de1 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0101de1:	55                   	push   %ebp
c0101de2:	89 e5                	mov    %esp,%ebp
c0101de4:	83 ec 08             	sub    $0x8,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0101de7:	83 ec 0c             	sub    $0xc,%esp
c0101dea:	ff 75 08             	pushl  0x8(%ebp)
c0101ded:	e8 da fe ff ff       	call   c0101ccc <trap_dispatch>
c0101df2:	83 c4 10             	add    $0x10,%esp
}
c0101df5:	90                   	nop
c0101df6:	c9                   	leave  
c0101df7:	c3                   	ret    

c0101df8 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0101df8:	6a 00                	push   $0x0
  pushl $0
c0101dfa:	6a 00                	push   $0x0
  jmp __alltraps
c0101dfc:	e9 67 0a 00 00       	jmp    c0102868 <__alltraps>

c0101e01 <vector1>:
.globl vector1
vector1:
  pushl $0
c0101e01:	6a 00                	push   $0x0
  pushl $1
c0101e03:	6a 01                	push   $0x1
  jmp __alltraps
c0101e05:	e9 5e 0a 00 00       	jmp    c0102868 <__alltraps>

c0101e0a <vector2>:
.globl vector2
vector2:
  pushl $0
c0101e0a:	6a 00                	push   $0x0
  pushl $2
c0101e0c:	6a 02                	push   $0x2
  jmp __alltraps
c0101e0e:	e9 55 0a 00 00       	jmp    c0102868 <__alltraps>

c0101e13 <vector3>:
.globl vector3
vector3:
  pushl $0
c0101e13:	6a 00                	push   $0x0
  pushl $3
c0101e15:	6a 03                	push   $0x3
  jmp __alltraps
c0101e17:	e9 4c 0a 00 00       	jmp    c0102868 <__alltraps>

c0101e1c <vector4>:
.globl vector4
vector4:
  pushl $0
c0101e1c:	6a 00                	push   $0x0
  pushl $4
c0101e1e:	6a 04                	push   $0x4
  jmp __alltraps
c0101e20:	e9 43 0a 00 00       	jmp    c0102868 <__alltraps>

c0101e25 <vector5>:
.globl vector5
vector5:
  pushl $0
c0101e25:	6a 00                	push   $0x0
  pushl $5
c0101e27:	6a 05                	push   $0x5
  jmp __alltraps
c0101e29:	e9 3a 0a 00 00       	jmp    c0102868 <__alltraps>

c0101e2e <vector6>:
.globl vector6
vector6:
  pushl $0
c0101e2e:	6a 00                	push   $0x0
  pushl $6
c0101e30:	6a 06                	push   $0x6
  jmp __alltraps
c0101e32:	e9 31 0a 00 00       	jmp    c0102868 <__alltraps>

c0101e37 <vector7>:
.globl vector7
vector7:
  pushl $0
c0101e37:	6a 00                	push   $0x0
  pushl $7
c0101e39:	6a 07                	push   $0x7
  jmp __alltraps
c0101e3b:	e9 28 0a 00 00       	jmp    c0102868 <__alltraps>

c0101e40 <vector8>:
.globl vector8
vector8:
  pushl $8
c0101e40:	6a 08                	push   $0x8
  jmp __alltraps
c0101e42:	e9 21 0a 00 00       	jmp    c0102868 <__alltraps>

c0101e47 <vector9>:
.globl vector9
vector9:
  pushl $9
c0101e47:	6a 09                	push   $0x9
  jmp __alltraps
c0101e49:	e9 1a 0a 00 00       	jmp    c0102868 <__alltraps>

c0101e4e <vector10>:
.globl vector10
vector10:
  pushl $10
c0101e4e:	6a 0a                	push   $0xa
  jmp __alltraps
c0101e50:	e9 13 0a 00 00       	jmp    c0102868 <__alltraps>

c0101e55 <vector11>:
.globl vector11
vector11:
  pushl $11
c0101e55:	6a 0b                	push   $0xb
  jmp __alltraps
c0101e57:	e9 0c 0a 00 00       	jmp    c0102868 <__alltraps>

c0101e5c <vector12>:
.globl vector12
vector12:
  pushl $12
c0101e5c:	6a 0c                	push   $0xc
  jmp __alltraps
c0101e5e:	e9 05 0a 00 00       	jmp    c0102868 <__alltraps>

c0101e63 <vector13>:
.globl vector13
vector13:
  pushl $13
c0101e63:	6a 0d                	push   $0xd
  jmp __alltraps
c0101e65:	e9 fe 09 00 00       	jmp    c0102868 <__alltraps>

c0101e6a <vector14>:
.globl vector14
vector14:
  pushl $14
c0101e6a:	6a 0e                	push   $0xe
  jmp __alltraps
c0101e6c:	e9 f7 09 00 00       	jmp    c0102868 <__alltraps>

c0101e71 <vector15>:
.globl vector15
vector15:
  pushl $0
c0101e71:	6a 00                	push   $0x0
  pushl $15
c0101e73:	6a 0f                	push   $0xf
  jmp __alltraps
c0101e75:	e9 ee 09 00 00       	jmp    c0102868 <__alltraps>

c0101e7a <vector16>:
.globl vector16
vector16:
  pushl $0
c0101e7a:	6a 00                	push   $0x0
  pushl $16
c0101e7c:	6a 10                	push   $0x10
  jmp __alltraps
c0101e7e:	e9 e5 09 00 00       	jmp    c0102868 <__alltraps>

c0101e83 <vector17>:
.globl vector17
vector17:
  pushl $17
c0101e83:	6a 11                	push   $0x11
  jmp __alltraps
c0101e85:	e9 de 09 00 00       	jmp    c0102868 <__alltraps>

c0101e8a <vector18>:
.globl vector18
vector18:
  pushl $0
c0101e8a:	6a 00                	push   $0x0
  pushl $18
c0101e8c:	6a 12                	push   $0x12
  jmp __alltraps
c0101e8e:	e9 d5 09 00 00       	jmp    c0102868 <__alltraps>

c0101e93 <vector19>:
.globl vector19
vector19:
  pushl $0
c0101e93:	6a 00                	push   $0x0
  pushl $19
c0101e95:	6a 13                	push   $0x13
  jmp __alltraps
c0101e97:	e9 cc 09 00 00       	jmp    c0102868 <__alltraps>

c0101e9c <vector20>:
.globl vector20
vector20:
  pushl $0
c0101e9c:	6a 00                	push   $0x0
  pushl $20
c0101e9e:	6a 14                	push   $0x14
  jmp __alltraps
c0101ea0:	e9 c3 09 00 00       	jmp    c0102868 <__alltraps>

c0101ea5 <vector21>:
.globl vector21
vector21:
  pushl $0
c0101ea5:	6a 00                	push   $0x0
  pushl $21
c0101ea7:	6a 15                	push   $0x15
  jmp __alltraps
c0101ea9:	e9 ba 09 00 00       	jmp    c0102868 <__alltraps>

c0101eae <vector22>:
.globl vector22
vector22:
  pushl $0
c0101eae:	6a 00                	push   $0x0
  pushl $22
c0101eb0:	6a 16                	push   $0x16
  jmp __alltraps
c0101eb2:	e9 b1 09 00 00       	jmp    c0102868 <__alltraps>

c0101eb7 <vector23>:
.globl vector23
vector23:
  pushl $0
c0101eb7:	6a 00                	push   $0x0
  pushl $23
c0101eb9:	6a 17                	push   $0x17
  jmp __alltraps
c0101ebb:	e9 a8 09 00 00       	jmp    c0102868 <__alltraps>

c0101ec0 <vector24>:
.globl vector24
vector24:
  pushl $0
c0101ec0:	6a 00                	push   $0x0
  pushl $24
c0101ec2:	6a 18                	push   $0x18
  jmp __alltraps
c0101ec4:	e9 9f 09 00 00       	jmp    c0102868 <__alltraps>

c0101ec9 <vector25>:
.globl vector25
vector25:
  pushl $0
c0101ec9:	6a 00                	push   $0x0
  pushl $25
c0101ecb:	6a 19                	push   $0x19
  jmp __alltraps
c0101ecd:	e9 96 09 00 00       	jmp    c0102868 <__alltraps>

c0101ed2 <vector26>:
.globl vector26
vector26:
  pushl $0
c0101ed2:	6a 00                	push   $0x0
  pushl $26
c0101ed4:	6a 1a                	push   $0x1a
  jmp __alltraps
c0101ed6:	e9 8d 09 00 00       	jmp    c0102868 <__alltraps>

c0101edb <vector27>:
.globl vector27
vector27:
  pushl $0
c0101edb:	6a 00                	push   $0x0
  pushl $27
c0101edd:	6a 1b                	push   $0x1b
  jmp __alltraps
c0101edf:	e9 84 09 00 00       	jmp    c0102868 <__alltraps>

c0101ee4 <vector28>:
.globl vector28
vector28:
  pushl $0
c0101ee4:	6a 00                	push   $0x0
  pushl $28
c0101ee6:	6a 1c                	push   $0x1c
  jmp __alltraps
c0101ee8:	e9 7b 09 00 00       	jmp    c0102868 <__alltraps>

c0101eed <vector29>:
.globl vector29
vector29:
  pushl $0
c0101eed:	6a 00                	push   $0x0
  pushl $29
c0101eef:	6a 1d                	push   $0x1d
  jmp __alltraps
c0101ef1:	e9 72 09 00 00       	jmp    c0102868 <__alltraps>

c0101ef6 <vector30>:
.globl vector30
vector30:
  pushl $0
c0101ef6:	6a 00                	push   $0x0
  pushl $30
c0101ef8:	6a 1e                	push   $0x1e
  jmp __alltraps
c0101efa:	e9 69 09 00 00       	jmp    c0102868 <__alltraps>

c0101eff <vector31>:
.globl vector31
vector31:
  pushl $0
c0101eff:	6a 00                	push   $0x0
  pushl $31
c0101f01:	6a 1f                	push   $0x1f
  jmp __alltraps
c0101f03:	e9 60 09 00 00       	jmp    c0102868 <__alltraps>

c0101f08 <vector32>:
.globl vector32
vector32:
  pushl $0
c0101f08:	6a 00                	push   $0x0
  pushl $32
c0101f0a:	6a 20                	push   $0x20
  jmp __alltraps
c0101f0c:	e9 57 09 00 00       	jmp    c0102868 <__alltraps>

c0101f11 <vector33>:
.globl vector33
vector33:
  pushl $0
c0101f11:	6a 00                	push   $0x0
  pushl $33
c0101f13:	6a 21                	push   $0x21
  jmp __alltraps
c0101f15:	e9 4e 09 00 00       	jmp    c0102868 <__alltraps>

c0101f1a <vector34>:
.globl vector34
vector34:
  pushl $0
c0101f1a:	6a 00                	push   $0x0
  pushl $34
c0101f1c:	6a 22                	push   $0x22
  jmp __alltraps
c0101f1e:	e9 45 09 00 00       	jmp    c0102868 <__alltraps>

c0101f23 <vector35>:
.globl vector35
vector35:
  pushl $0
c0101f23:	6a 00                	push   $0x0
  pushl $35
c0101f25:	6a 23                	push   $0x23
  jmp __alltraps
c0101f27:	e9 3c 09 00 00       	jmp    c0102868 <__alltraps>

c0101f2c <vector36>:
.globl vector36
vector36:
  pushl $0
c0101f2c:	6a 00                	push   $0x0
  pushl $36
c0101f2e:	6a 24                	push   $0x24
  jmp __alltraps
c0101f30:	e9 33 09 00 00       	jmp    c0102868 <__alltraps>

c0101f35 <vector37>:
.globl vector37
vector37:
  pushl $0
c0101f35:	6a 00                	push   $0x0
  pushl $37
c0101f37:	6a 25                	push   $0x25
  jmp __alltraps
c0101f39:	e9 2a 09 00 00       	jmp    c0102868 <__alltraps>

c0101f3e <vector38>:
.globl vector38
vector38:
  pushl $0
c0101f3e:	6a 00                	push   $0x0
  pushl $38
c0101f40:	6a 26                	push   $0x26
  jmp __alltraps
c0101f42:	e9 21 09 00 00       	jmp    c0102868 <__alltraps>

c0101f47 <vector39>:
.globl vector39
vector39:
  pushl $0
c0101f47:	6a 00                	push   $0x0
  pushl $39
c0101f49:	6a 27                	push   $0x27
  jmp __alltraps
c0101f4b:	e9 18 09 00 00       	jmp    c0102868 <__alltraps>

c0101f50 <vector40>:
.globl vector40
vector40:
  pushl $0
c0101f50:	6a 00                	push   $0x0
  pushl $40
c0101f52:	6a 28                	push   $0x28
  jmp __alltraps
c0101f54:	e9 0f 09 00 00       	jmp    c0102868 <__alltraps>

c0101f59 <vector41>:
.globl vector41
vector41:
  pushl $0
c0101f59:	6a 00                	push   $0x0
  pushl $41
c0101f5b:	6a 29                	push   $0x29
  jmp __alltraps
c0101f5d:	e9 06 09 00 00       	jmp    c0102868 <__alltraps>

c0101f62 <vector42>:
.globl vector42
vector42:
  pushl $0
c0101f62:	6a 00                	push   $0x0
  pushl $42
c0101f64:	6a 2a                	push   $0x2a
  jmp __alltraps
c0101f66:	e9 fd 08 00 00       	jmp    c0102868 <__alltraps>

c0101f6b <vector43>:
.globl vector43
vector43:
  pushl $0
c0101f6b:	6a 00                	push   $0x0
  pushl $43
c0101f6d:	6a 2b                	push   $0x2b
  jmp __alltraps
c0101f6f:	e9 f4 08 00 00       	jmp    c0102868 <__alltraps>

c0101f74 <vector44>:
.globl vector44
vector44:
  pushl $0
c0101f74:	6a 00                	push   $0x0
  pushl $44
c0101f76:	6a 2c                	push   $0x2c
  jmp __alltraps
c0101f78:	e9 eb 08 00 00       	jmp    c0102868 <__alltraps>

c0101f7d <vector45>:
.globl vector45
vector45:
  pushl $0
c0101f7d:	6a 00                	push   $0x0
  pushl $45
c0101f7f:	6a 2d                	push   $0x2d
  jmp __alltraps
c0101f81:	e9 e2 08 00 00       	jmp    c0102868 <__alltraps>

c0101f86 <vector46>:
.globl vector46
vector46:
  pushl $0
c0101f86:	6a 00                	push   $0x0
  pushl $46
c0101f88:	6a 2e                	push   $0x2e
  jmp __alltraps
c0101f8a:	e9 d9 08 00 00       	jmp    c0102868 <__alltraps>

c0101f8f <vector47>:
.globl vector47
vector47:
  pushl $0
c0101f8f:	6a 00                	push   $0x0
  pushl $47
c0101f91:	6a 2f                	push   $0x2f
  jmp __alltraps
c0101f93:	e9 d0 08 00 00       	jmp    c0102868 <__alltraps>

c0101f98 <vector48>:
.globl vector48
vector48:
  pushl $0
c0101f98:	6a 00                	push   $0x0
  pushl $48
c0101f9a:	6a 30                	push   $0x30
  jmp __alltraps
c0101f9c:	e9 c7 08 00 00       	jmp    c0102868 <__alltraps>

c0101fa1 <vector49>:
.globl vector49
vector49:
  pushl $0
c0101fa1:	6a 00                	push   $0x0
  pushl $49
c0101fa3:	6a 31                	push   $0x31
  jmp __alltraps
c0101fa5:	e9 be 08 00 00       	jmp    c0102868 <__alltraps>

c0101faa <vector50>:
.globl vector50
vector50:
  pushl $0
c0101faa:	6a 00                	push   $0x0
  pushl $50
c0101fac:	6a 32                	push   $0x32
  jmp __alltraps
c0101fae:	e9 b5 08 00 00       	jmp    c0102868 <__alltraps>

c0101fb3 <vector51>:
.globl vector51
vector51:
  pushl $0
c0101fb3:	6a 00                	push   $0x0
  pushl $51
c0101fb5:	6a 33                	push   $0x33
  jmp __alltraps
c0101fb7:	e9 ac 08 00 00       	jmp    c0102868 <__alltraps>

c0101fbc <vector52>:
.globl vector52
vector52:
  pushl $0
c0101fbc:	6a 00                	push   $0x0
  pushl $52
c0101fbe:	6a 34                	push   $0x34
  jmp __alltraps
c0101fc0:	e9 a3 08 00 00       	jmp    c0102868 <__alltraps>

c0101fc5 <vector53>:
.globl vector53
vector53:
  pushl $0
c0101fc5:	6a 00                	push   $0x0
  pushl $53
c0101fc7:	6a 35                	push   $0x35
  jmp __alltraps
c0101fc9:	e9 9a 08 00 00       	jmp    c0102868 <__alltraps>

c0101fce <vector54>:
.globl vector54
vector54:
  pushl $0
c0101fce:	6a 00                	push   $0x0
  pushl $54
c0101fd0:	6a 36                	push   $0x36
  jmp __alltraps
c0101fd2:	e9 91 08 00 00       	jmp    c0102868 <__alltraps>

c0101fd7 <vector55>:
.globl vector55
vector55:
  pushl $0
c0101fd7:	6a 00                	push   $0x0
  pushl $55
c0101fd9:	6a 37                	push   $0x37
  jmp __alltraps
c0101fdb:	e9 88 08 00 00       	jmp    c0102868 <__alltraps>

c0101fe0 <vector56>:
.globl vector56
vector56:
  pushl $0
c0101fe0:	6a 00                	push   $0x0
  pushl $56
c0101fe2:	6a 38                	push   $0x38
  jmp __alltraps
c0101fe4:	e9 7f 08 00 00       	jmp    c0102868 <__alltraps>

c0101fe9 <vector57>:
.globl vector57
vector57:
  pushl $0
c0101fe9:	6a 00                	push   $0x0
  pushl $57
c0101feb:	6a 39                	push   $0x39
  jmp __alltraps
c0101fed:	e9 76 08 00 00       	jmp    c0102868 <__alltraps>

c0101ff2 <vector58>:
.globl vector58
vector58:
  pushl $0
c0101ff2:	6a 00                	push   $0x0
  pushl $58
c0101ff4:	6a 3a                	push   $0x3a
  jmp __alltraps
c0101ff6:	e9 6d 08 00 00       	jmp    c0102868 <__alltraps>

c0101ffb <vector59>:
.globl vector59
vector59:
  pushl $0
c0101ffb:	6a 00                	push   $0x0
  pushl $59
c0101ffd:	6a 3b                	push   $0x3b
  jmp __alltraps
c0101fff:	e9 64 08 00 00       	jmp    c0102868 <__alltraps>

c0102004 <vector60>:
.globl vector60
vector60:
  pushl $0
c0102004:	6a 00                	push   $0x0
  pushl $60
c0102006:	6a 3c                	push   $0x3c
  jmp __alltraps
c0102008:	e9 5b 08 00 00       	jmp    c0102868 <__alltraps>

c010200d <vector61>:
.globl vector61
vector61:
  pushl $0
c010200d:	6a 00                	push   $0x0
  pushl $61
c010200f:	6a 3d                	push   $0x3d
  jmp __alltraps
c0102011:	e9 52 08 00 00       	jmp    c0102868 <__alltraps>

c0102016 <vector62>:
.globl vector62
vector62:
  pushl $0
c0102016:	6a 00                	push   $0x0
  pushl $62
c0102018:	6a 3e                	push   $0x3e
  jmp __alltraps
c010201a:	e9 49 08 00 00       	jmp    c0102868 <__alltraps>

c010201f <vector63>:
.globl vector63
vector63:
  pushl $0
c010201f:	6a 00                	push   $0x0
  pushl $63
c0102021:	6a 3f                	push   $0x3f
  jmp __alltraps
c0102023:	e9 40 08 00 00       	jmp    c0102868 <__alltraps>

c0102028 <vector64>:
.globl vector64
vector64:
  pushl $0
c0102028:	6a 00                	push   $0x0
  pushl $64
c010202a:	6a 40                	push   $0x40
  jmp __alltraps
c010202c:	e9 37 08 00 00       	jmp    c0102868 <__alltraps>

c0102031 <vector65>:
.globl vector65
vector65:
  pushl $0
c0102031:	6a 00                	push   $0x0
  pushl $65
c0102033:	6a 41                	push   $0x41
  jmp __alltraps
c0102035:	e9 2e 08 00 00       	jmp    c0102868 <__alltraps>

c010203a <vector66>:
.globl vector66
vector66:
  pushl $0
c010203a:	6a 00                	push   $0x0
  pushl $66
c010203c:	6a 42                	push   $0x42
  jmp __alltraps
c010203e:	e9 25 08 00 00       	jmp    c0102868 <__alltraps>

c0102043 <vector67>:
.globl vector67
vector67:
  pushl $0
c0102043:	6a 00                	push   $0x0
  pushl $67
c0102045:	6a 43                	push   $0x43
  jmp __alltraps
c0102047:	e9 1c 08 00 00       	jmp    c0102868 <__alltraps>

c010204c <vector68>:
.globl vector68
vector68:
  pushl $0
c010204c:	6a 00                	push   $0x0
  pushl $68
c010204e:	6a 44                	push   $0x44
  jmp __alltraps
c0102050:	e9 13 08 00 00       	jmp    c0102868 <__alltraps>

c0102055 <vector69>:
.globl vector69
vector69:
  pushl $0
c0102055:	6a 00                	push   $0x0
  pushl $69
c0102057:	6a 45                	push   $0x45
  jmp __alltraps
c0102059:	e9 0a 08 00 00       	jmp    c0102868 <__alltraps>

c010205e <vector70>:
.globl vector70
vector70:
  pushl $0
c010205e:	6a 00                	push   $0x0
  pushl $70
c0102060:	6a 46                	push   $0x46
  jmp __alltraps
c0102062:	e9 01 08 00 00       	jmp    c0102868 <__alltraps>

c0102067 <vector71>:
.globl vector71
vector71:
  pushl $0
c0102067:	6a 00                	push   $0x0
  pushl $71
c0102069:	6a 47                	push   $0x47
  jmp __alltraps
c010206b:	e9 f8 07 00 00       	jmp    c0102868 <__alltraps>

c0102070 <vector72>:
.globl vector72
vector72:
  pushl $0
c0102070:	6a 00                	push   $0x0
  pushl $72
c0102072:	6a 48                	push   $0x48
  jmp __alltraps
c0102074:	e9 ef 07 00 00       	jmp    c0102868 <__alltraps>

c0102079 <vector73>:
.globl vector73
vector73:
  pushl $0
c0102079:	6a 00                	push   $0x0
  pushl $73
c010207b:	6a 49                	push   $0x49
  jmp __alltraps
c010207d:	e9 e6 07 00 00       	jmp    c0102868 <__alltraps>

c0102082 <vector74>:
.globl vector74
vector74:
  pushl $0
c0102082:	6a 00                	push   $0x0
  pushl $74
c0102084:	6a 4a                	push   $0x4a
  jmp __alltraps
c0102086:	e9 dd 07 00 00       	jmp    c0102868 <__alltraps>

c010208b <vector75>:
.globl vector75
vector75:
  pushl $0
c010208b:	6a 00                	push   $0x0
  pushl $75
c010208d:	6a 4b                	push   $0x4b
  jmp __alltraps
c010208f:	e9 d4 07 00 00       	jmp    c0102868 <__alltraps>

c0102094 <vector76>:
.globl vector76
vector76:
  pushl $0
c0102094:	6a 00                	push   $0x0
  pushl $76
c0102096:	6a 4c                	push   $0x4c
  jmp __alltraps
c0102098:	e9 cb 07 00 00       	jmp    c0102868 <__alltraps>

c010209d <vector77>:
.globl vector77
vector77:
  pushl $0
c010209d:	6a 00                	push   $0x0
  pushl $77
c010209f:	6a 4d                	push   $0x4d
  jmp __alltraps
c01020a1:	e9 c2 07 00 00       	jmp    c0102868 <__alltraps>

c01020a6 <vector78>:
.globl vector78
vector78:
  pushl $0
c01020a6:	6a 00                	push   $0x0
  pushl $78
c01020a8:	6a 4e                	push   $0x4e
  jmp __alltraps
c01020aa:	e9 b9 07 00 00       	jmp    c0102868 <__alltraps>

c01020af <vector79>:
.globl vector79
vector79:
  pushl $0
c01020af:	6a 00                	push   $0x0
  pushl $79
c01020b1:	6a 4f                	push   $0x4f
  jmp __alltraps
c01020b3:	e9 b0 07 00 00       	jmp    c0102868 <__alltraps>

c01020b8 <vector80>:
.globl vector80
vector80:
  pushl $0
c01020b8:	6a 00                	push   $0x0
  pushl $80
c01020ba:	6a 50                	push   $0x50
  jmp __alltraps
c01020bc:	e9 a7 07 00 00       	jmp    c0102868 <__alltraps>

c01020c1 <vector81>:
.globl vector81
vector81:
  pushl $0
c01020c1:	6a 00                	push   $0x0
  pushl $81
c01020c3:	6a 51                	push   $0x51
  jmp __alltraps
c01020c5:	e9 9e 07 00 00       	jmp    c0102868 <__alltraps>

c01020ca <vector82>:
.globl vector82
vector82:
  pushl $0
c01020ca:	6a 00                	push   $0x0
  pushl $82
c01020cc:	6a 52                	push   $0x52
  jmp __alltraps
c01020ce:	e9 95 07 00 00       	jmp    c0102868 <__alltraps>

c01020d3 <vector83>:
.globl vector83
vector83:
  pushl $0
c01020d3:	6a 00                	push   $0x0
  pushl $83
c01020d5:	6a 53                	push   $0x53
  jmp __alltraps
c01020d7:	e9 8c 07 00 00       	jmp    c0102868 <__alltraps>

c01020dc <vector84>:
.globl vector84
vector84:
  pushl $0
c01020dc:	6a 00                	push   $0x0
  pushl $84
c01020de:	6a 54                	push   $0x54
  jmp __alltraps
c01020e0:	e9 83 07 00 00       	jmp    c0102868 <__alltraps>

c01020e5 <vector85>:
.globl vector85
vector85:
  pushl $0
c01020e5:	6a 00                	push   $0x0
  pushl $85
c01020e7:	6a 55                	push   $0x55
  jmp __alltraps
c01020e9:	e9 7a 07 00 00       	jmp    c0102868 <__alltraps>

c01020ee <vector86>:
.globl vector86
vector86:
  pushl $0
c01020ee:	6a 00                	push   $0x0
  pushl $86
c01020f0:	6a 56                	push   $0x56
  jmp __alltraps
c01020f2:	e9 71 07 00 00       	jmp    c0102868 <__alltraps>

c01020f7 <vector87>:
.globl vector87
vector87:
  pushl $0
c01020f7:	6a 00                	push   $0x0
  pushl $87
c01020f9:	6a 57                	push   $0x57
  jmp __alltraps
c01020fb:	e9 68 07 00 00       	jmp    c0102868 <__alltraps>

c0102100 <vector88>:
.globl vector88
vector88:
  pushl $0
c0102100:	6a 00                	push   $0x0
  pushl $88
c0102102:	6a 58                	push   $0x58
  jmp __alltraps
c0102104:	e9 5f 07 00 00       	jmp    c0102868 <__alltraps>

c0102109 <vector89>:
.globl vector89
vector89:
  pushl $0
c0102109:	6a 00                	push   $0x0
  pushl $89
c010210b:	6a 59                	push   $0x59
  jmp __alltraps
c010210d:	e9 56 07 00 00       	jmp    c0102868 <__alltraps>

c0102112 <vector90>:
.globl vector90
vector90:
  pushl $0
c0102112:	6a 00                	push   $0x0
  pushl $90
c0102114:	6a 5a                	push   $0x5a
  jmp __alltraps
c0102116:	e9 4d 07 00 00       	jmp    c0102868 <__alltraps>

c010211b <vector91>:
.globl vector91
vector91:
  pushl $0
c010211b:	6a 00                	push   $0x0
  pushl $91
c010211d:	6a 5b                	push   $0x5b
  jmp __alltraps
c010211f:	e9 44 07 00 00       	jmp    c0102868 <__alltraps>

c0102124 <vector92>:
.globl vector92
vector92:
  pushl $0
c0102124:	6a 00                	push   $0x0
  pushl $92
c0102126:	6a 5c                	push   $0x5c
  jmp __alltraps
c0102128:	e9 3b 07 00 00       	jmp    c0102868 <__alltraps>

c010212d <vector93>:
.globl vector93
vector93:
  pushl $0
c010212d:	6a 00                	push   $0x0
  pushl $93
c010212f:	6a 5d                	push   $0x5d
  jmp __alltraps
c0102131:	e9 32 07 00 00       	jmp    c0102868 <__alltraps>

c0102136 <vector94>:
.globl vector94
vector94:
  pushl $0
c0102136:	6a 00                	push   $0x0
  pushl $94
c0102138:	6a 5e                	push   $0x5e
  jmp __alltraps
c010213a:	e9 29 07 00 00       	jmp    c0102868 <__alltraps>

c010213f <vector95>:
.globl vector95
vector95:
  pushl $0
c010213f:	6a 00                	push   $0x0
  pushl $95
c0102141:	6a 5f                	push   $0x5f
  jmp __alltraps
c0102143:	e9 20 07 00 00       	jmp    c0102868 <__alltraps>

c0102148 <vector96>:
.globl vector96
vector96:
  pushl $0
c0102148:	6a 00                	push   $0x0
  pushl $96
c010214a:	6a 60                	push   $0x60
  jmp __alltraps
c010214c:	e9 17 07 00 00       	jmp    c0102868 <__alltraps>

c0102151 <vector97>:
.globl vector97
vector97:
  pushl $0
c0102151:	6a 00                	push   $0x0
  pushl $97
c0102153:	6a 61                	push   $0x61
  jmp __alltraps
c0102155:	e9 0e 07 00 00       	jmp    c0102868 <__alltraps>

c010215a <vector98>:
.globl vector98
vector98:
  pushl $0
c010215a:	6a 00                	push   $0x0
  pushl $98
c010215c:	6a 62                	push   $0x62
  jmp __alltraps
c010215e:	e9 05 07 00 00       	jmp    c0102868 <__alltraps>

c0102163 <vector99>:
.globl vector99
vector99:
  pushl $0
c0102163:	6a 00                	push   $0x0
  pushl $99
c0102165:	6a 63                	push   $0x63
  jmp __alltraps
c0102167:	e9 fc 06 00 00       	jmp    c0102868 <__alltraps>

c010216c <vector100>:
.globl vector100
vector100:
  pushl $0
c010216c:	6a 00                	push   $0x0
  pushl $100
c010216e:	6a 64                	push   $0x64
  jmp __alltraps
c0102170:	e9 f3 06 00 00       	jmp    c0102868 <__alltraps>

c0102175 <vector101>:
.globl vector101
vector101:
  pushl $0
c0102175:	6a 00                	push   $0x0
  pushl $101
c0102177:	6a 65                	push   $0x65
  jmp __alltraps
c0102179:	e9 ea 06 00 00       	jmp    c0102868 <__alltraps>

c010217e <vector102>:
.globl vector102
vector102:
  pushl $0
c010217e:	6a 00                	push   $0x0
  pushl $102
c0102180:	6a 66                	push   $0x66
  jmp __alltraps
c0102182:	e9 e1 06 00 00       	jmp    c0102868 <__alltraps>

c0102187 <vector103>:
.globl vector103
vector103:
  pushl $0
c0102187:	6a 00                	push   $0x0
  pushl $103
c0102189:	6a 67                	push   $0x67
  jmp __alltraps
c010218b:	e9 d8 06 00 00       	jmp    c0102868 <__alltraps>

c0102190 <vector104>:
.globl vector104
vector104:
  pushl $0
c0102190:	6a 00                	push   $0x0
  pushl $104
c0102192:	6a 68                	push   $0x68
  jmp __alltraps
c0102194:	e9 cf 06 00 00       	jmp    c0102868 <__alltraps>

c0102199 <vector105>:
.globl vector105
vector105:
  pushl $0
c0102199:	6a 00                	push   $0x0
  pushl $105
c010219b:	6a 69                	push   $0x69
  jmp __alltraps
c010219d:	e9 c6 06 00 00       	jmp    c0102868 <__alltraps>

c01021a2 <vector106>:
.globl vector106
vector106:
  pushl $0
c01021a2:	6a 00                	push   $0x0
  pushl $106
c01021a4:	6a 6a                	push   $0x6a
  jmp __alltraps
c01021a6:	e9 bd 06 00 00       	jmp    c0102868 <__alltraps>

c01021ab <vector107>:
.globl vector107
vector107:
  pushl $0
c01021ab:	6a 00                	push   $0x0
  pushl $107
c01021ad:	6a 6b                	push   $0x6b
  jmp __alltraps
c01021af:	e9 b4 06 00 00       	jmp    c0102868 <__alltraps>

c01021b4 <vector108>:
.globl vector108
vector108:
  pushl $0
c01021b4:	6a 00                	push   $0x0
  pushl $108
c01021b6:	6a 6c                	push   $0x6c
  jmp __alltraps
c01021b8:	e9 ab 06 00 00       	jmp    c0102868 <__alltraps>

c01021bd <vector109>:
.globl vector109
vector109:
  pushl $0
c01021bd:	6a 00                	push   $0x0
  pushl $109
c01021bf:	6a 6d                	push   $0x6d
  jmp __alltraps
c01021c1:	e9 a2 06 00 00       	jmp    c0102868 <__alltraps>

c01021c6 <vector110>:
.globl vector110
vector110:
  pushl $0
c01021c6:	6a 00                	push   $0x0
  pushl $110
c01021c8:	6a 6e                	push   $0x6e
  jmp __alltraps
c01021ca:	e9 99 06 00 00       	jmp    c0102868 <__alltraps>

c01021cf <vector111>:
.globl vector111
vector111:
  pushl $0
c01021cf:	6a 00                	push   $0x0
  pushl $111
c01021d1:	6a 6f                	push   $0x6f
  jmp __alltraps
c01021d3:	e9 90 06 00 00       	jmp    c0102868 <__alltraps>

c01021d8 <vector112>:
.globl vector112
vector112:
  pushl $0
c01021d8:	6a 00                	push   $0x0
  pushl $112
c01021da:	6a 70                	push   $0x70
  jmp __alltraps
c01021dc:	e9 87 06 00 00       	jmp    c0102868 <__alltraps>

c01021e1 <vector113>:
.globl vector113
vector113:
  pushl $0
c01021e1:	6a 00                	push   $0x0
  pushl $113
c01021e3:	6a 71                	push   $0x71
  jmp __alltraps
c01021e5:	e9 7e 06 00 00       	jmp    c0102868 <__alltraps>

c01021ea <vector114>:
.globl vector114
vector114:
  pushl $0
c01021ea:	6a 00                	push   $0x0
  pushl $114
c01021ec:	6a 72                	push   $0x72
  jmp __alltraps
c01021ee:	e9 75 06 00 00       	jmp    c0102868 <__alltraps>

c01021f3 <vector115>:
.globl vector115
vector115:
  pushl $0
c01021f3:	6a 00                	push   $0x0
  pushl $115
c01021f5:	6a 73                	push   $0x73
  jmp __alltraps
c01021f7:	e9 6c 06 00 00       	jmp    c0102868 <__alltraps>

c01021fc <vector116>:
.globl vector116
vector116:
  pushl $0
c01021fc:	6a 00                	push   $0x0
  pushl $116
c01021fe:	6a 74                	push   $0x74
  jmp __alltraps
c0102200:	e9 63 06 00 00       	jmp    c0102868 <__alltraps>

c0102205 <vector117>:
.globl vector117
vector117:
  pushl $0
c0102205:	6a 00                	push   $0x0
  pushl $117
c0102207:	6a 75                	push   $0x75
  jmp __alltraps
c0102209:	e9 5a 06 00 00       	jmp    c0102868 <__alltraps>

c010220e <vector118>:
.globl vector118
vector118:
  pushl $0
c010220e:	6a 00                	push   $0x0
  pushl $118
c0102210:	6a 76                	push   $0x76
  jmp __alltraps
c0102212:	e9 51 06 00 00       	jmp    c0102868 <__alltraps>

c0102217 <vector119>:
.globl vector119
vector119:
  pushl $0
c0102217:	6a 00                	push   $0x0
  pushl $119
c0102219:	6a 77                	push   $0x77
  jmp __alltraps
c010221b:	e9 48 06 00 00       	jmp    c0102868 <__alltraps>

c0102220 <vector120>:
.globl vector120
vector120:
  pushl $0
c0102220:	6a 00                	push   $0x0
  pushl $120
c0102222:	6a 78                	push   $0x78
  jmp __alltraps
c0102224:	e9 3f 06 00 00       	jmp    c0102868 <__alltraps>

c0102229 <vector121>:
.globl vector121
vector121:
  pushl $0
c0102229:	6a 00                	push   $0x0
  pushl $121
c010222b:	6a 79                	push   $0x79
  jmp __alltraps
c010222d:	e9 36 06 00 00       	jmp    c0102868 <__alltraps>

c0102232 <vector122>:
.globl vector122
vector122:
  pushl $0
c0102232:	6a 00                	push   $0x0
  pushl $122
c0102234:	6a 7a                	push   $0x7a
  jmp __alltraps
c0102236:	e9 2d 06 00 00       	jmp    c0102868 <__alltraps>

c010223b <vector123>:
.globl vector123
vector123:
  pushl $0
c010223b:	6a 00                	push   $0x0
  pushl $123
c010223d:	6a 7b                	push   $0x7b
  jmp __alltraps
c010223f:	e9 24 06 00 00       	jmp    c0102868 <__alltraps>

c0102244 <vector124>:
.globl vector124
vector124:
  pushl $0
c0102244:	6a 00                	push   $0x0
  pushl $124
c0102246:	6a 7c                	push   $0x7c
  jmp __alltraps
c0102248:	e9 1b 06 00 00       	jmp    c0102868 <__alltraps>

c010224d <vector125>:
.globl vector125
vector125:
  pushl $0
c010224d:	6a 00                	push   $0x0
  pushl $125
c010224f:	6a 7d                	push   $0x7d
  jmp __alltraps
c0102251:	e9 12 06 00 00       	jmp    c0102868 <__alltraps>

c0102256 <vector126>:
.globl vector126
vector126:
  pushl $0
c0102256:	6a 00                	push   $0x0
  pushl $126
c0102258:	6a 7e                	push   $0x7e
  jmp __alltraps
c010225a:	e9 09 06 00 00       	jmp    c0102868 <__alltraps>

c010225f <vector127>:
.globl vector127
vector127:
  pushl $0
c010225f:	6a 00                	push   $0x0
  pushl $127
c0102261:	6a 7f                	push   $0x7f
  jmp __alltraps
c0102263:	e9 00 06 00 00       	jmp    c0102868 <__alltraps>

c0102268 <vector128>:
.globl vector128
vector128:
  pushl $0
c0102268:	6a 00                	push   $0x0
  pushl $128
c010226a:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c010226f:	e9 f4 05 00 00       	jmp    c0102868 <__alltraps>

c0102274 <vector129>:
.globl vector129
vector129:
  pushl $0
c0102274:	6a 00                	push   $0x0
  pushl $129
c0102276:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c010227b:	e9 e8 05 00 00       	jmp    c0102868 <__alltraps>

c0102280 <vector130>:
.globl vector130
vector130:
  pushl $0
c0102280:	6a 00                	push   $0x0
  pushl $130
c0102282:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c0102287:	e9 dc 05 00 00       	jmp    c0102868 <__alltraps>

c010228c <vector131>:
.globl vector131
vector131:
  pushl $0
c010228c:	6a 00                	push   $0x0
  pushl $131
c010228e:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c0102293:	e9 d0 05 00 00       	jmp    c0102868 <__alltraps>

c0102298 <vector132>:
.globl vector132
vector132:
  pushl $0
c0102298:	6a 00                	push   $0x0
  pushl $132
c010229a:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c010229f:	e9 c4 05 00 00       	jmp    c0102868 <__alltraps>

c01022a4 <vector133>:
.globl vector133
vector133:
  pushl $0
c01022a4:	6a 00                	push   $0x0
  pushl $133
c01022a6:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c01022ab:	e9 b8 05 00 00       	jmp    c0102868 <__alltraps>

c01022b0 <vector134>:
.globl vector134
vector134:
  pushl $0
c01022b0:	6a 00                	push   $0x0
  pushl $134
c01022b2:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c01022b7:	e9 ac 05 00 00       	jmp    c0102868 <__alltraps>

c01022bc <vector135>:
.globl vector135
vector135:
  pushl $0
c01022bc:	6a 00                	push   $0x0
  pushl $135
c01022be:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c01022c3:	e9 a0 05 00 00       	jmp    c0102868 <__alltraps>

c01022c8 <vector136>:
.globl vector136
vector136:
  pushl $0
c01022c8:	6a 00                	push   $0x0
  pushl $136
c01022ca:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c01022cf:	e9 94 05 00 00       	jmp    c0102868 <__alltraps>

c01022d4 <vector137>:
.globl vector137
vector137:
  pushl $0
c01022d4:	6a 00                	push   $0x0
  pushl $137
c01022d6:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c01022db:	e9 88 05 00 00       	jmp    c0102868 <__alltraps>

c01022e0 <vector138>:
.globl vector138
vector138:
  pushl $0
c01022e0:	6a 00                	push   $0x0
  pushl $138
c01022e2:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c01022e7:	e9 7c 05 00 00       	jmp    c0102868 <__alltraps>

c01022ec <vector139>:
.globl vector139
vector139:
  pushl $0
c01022ec:	6a 00                	push   $0x0
  pushl $139
c01022ee:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c01022f3:	e9 70 05 00 00       	jmp    c0102868 <__alltraps>

c01022f8 <vector140>:
.globl vector140
vector140:
  pushl $0
c01022f8:	6a 00                	push   $0x0
  pushl $140
c01022fa:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c01022ff:	e9 64 05 00 00       	jmp    c0102868 <__alltraps>

c0102304 <vector141>:
.globl vector141
vector141:
  pushl $0
c0102304:	6a 00                	push   $0x0
  pushl $141
c0102306:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c010230b:	e9 58 05 00 00       	jmp    c0102868 <__alltraps>

c0102310 <vector142>:
.globl vector142
vector142:
  pushl $0
c0102310:	6a 00                	push   $0x0
  pushl $142
c0102312:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c0102317:	e9 4c 05 00 00       	jmp    c0102868 <__alltraps>

c010231c <vector143>:
.globl vector143
vector143:
  pushl $0
c010231c:	6a 00                	push   $0x0
  pushl $143
c010231e:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c0102323:	e9 40 05 00 00       	jmp    c0102868 <__alltraps>

c0102328 <vector144>:
.globl vector144
vector144:
  pushl $0
c0102328:	6a 00                	push   $0x0
  pushl $144
c010232a:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c010232f:	e9 34 05 00 00       	jmp    c0102868 <__alltraps>

c0102334 <vector145>:
.globl vector145
vector145:
  pushl $0
c0102334:	6a 00                	push   $0x0
  pushl $145
c0102336:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c010233b:	e9 28 05 00 00       	jmp    c0102868 <__alltraps>

c0102340 <vector146>:
.globl vector146
vector146:
  pushl $0
c0102340:	6a 00                	push   $0x0
  pushl $146
c0102342:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c0102347:	e9 1c 05 00 00       	jmp    c0102868 <__alltraps>

c010234c <vector147>:
.globl vector147
vector147:
  pushl $0
c010234c:	6a 00                	push   $0x0
  pushl $147
c010234e:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c0102353:	e9 10 05 00 00       	jmp    c0102868 <__alltraps>

c0102358 <vector148>:
.globl vector148
vector148:
  pushl $0
c0102358:	6a 00                	push   $0x0
  pushl $148
c010235a:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c010235f:	e9 04 05 00 00       	jmp    c0102868 <__alltraps>

c0102364 <vector149>:
.globl vector149
vector149:
  pushl $0
c0102364:	6a 00                	push   $0x0
  pushl $149
c0102366:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c010236b:	e9 f8 04 00 00       	jmp    c0102868 <__alltraps>

c0102370 <vector150>:
.globl vector150
vector150:
  pushl $0
c0102370:	6a 00                	push   $0x0
  pushl $150
c0102372:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c0102377:	e9 ec 04 00 00       	jmp    c0102868 <__alltraps>

c010237c <vector151>:
.globl vector151
vector151:
  pushl $0
c010237c:	6a 00                	push   $0x0
  pushl $151
c010237e:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c0102383:	e9 e0 04 00 00       	jmp    c0102868 <__alltraps>

c0102388 <vector152>:
.globl vector152
vector152:
  pushl $0
c0102388:	6a 00                	push   $0x0
  pushl $152
c010238a:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c010238f:	e9 d4 04 00 00       	jmp    c0102868 <__alltraps>

c0102394 <vector153>:
.globl vector153
vector153:
  pushl $0
c0102394:	6a 00                	push   $0x0
  pushl $153
c0102396:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c010239b:	e9 c8 04 00 00       	jmp    c0102868 <__alltraps>

c01023a0 <vector154>:
.globl vector154
vector154:
  pushl $0
c01023a0:	6a 00                	push   $0x0
  pushl $154
c01023a2:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c01023a7:	e9 bc 04 00 00       	jmp    c0102868 <__alltraps>

c01023ac <vector155>:
.globl vector155
vector155:
  pushl $0
c01023ac:	6a 00                	push   $0x0
  pushl $155
c01023ae:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c01023b3:	e9 b0 04 00 00       	jmp    c0102868 <__alltraps>

c01023b8 <vector156>:
.globl vector156
vector156:
  pushl $0
c01023b8:	6a 00                	push   $0x0
  pushl $156
c01023ba:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c01023bf:	e9 a4 04 00 00       	jmp    c0102868 <__alltraps>

c01023c4 <vector157>:
.globl vector157
vector157:
  pushl $0
c01023c4:	6a 00                	push   $0x0
  pushl $157
c01023c6:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c01023cb:	e9 98 04 00 00       	jmp    c0102868 <__alltraps>

c01023d0 <vector158>:
.globl vector158
vector158:
  pushl $0
c01023d0:	6a 00                	push   $0x0
  pushl $158
c01023d2:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c01023d7:	e9 8c 04 00 00       	jmp    c0102868 <__alltraps>

c01023dc <vector159>:
.globl vector159
vector159:
  pushl $0
c01023dc:	6a 00                	push   $0x0
  pushl $159
c01023de:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c01023e3:	e9 80 04 00 00       	jmp    c0102868 <__alltraps>

c01023e8 <vector160>:
.globl vector160
vector160:
  pushl $0
c01023e8:	6a 00                	push   $0x0
  pushl $160
c01023ea:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c01023ef:	e9 74 04 00 00       	jmp    c0102868 <__alltraps>

c01023f4 <vector161>:
.globl vector161
vector161:
  pushl $0
c01023f4:	6a 00                	push   $0x0
  pushl $161
c01023f6:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c01023fb:	e9 68 04 00 00       	jmp    c0102868 <__alltraps>

c0102400 <vector162>:
.globl vector162
vector162:
  pushl $0
c0102400:	6a 00                	push   $0x0
  pushl $162
c0102402:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c0102407:	e9 5c 04 00 00       	jmp    c0102868 <__alltraps>

c010240c <vector163>:
.globl vector163
vector163:
  pushl $0
c010240c:	6a 00                	push   $0x0
  pushl $163
c010240e:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c0102413:	e9 50 04 00 00       	jmp    c0102868 <__alltraps>

c0102418 <vector164>:
.globl vector164
vector164:
  pushl $0
c0102418:	6a 00                	push   $0x0
  pushl $164
c010241a:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c010241f:	e9 44 04 00 00       	jmp    c0102868 <__alltraps>

c0102424 <vector165>:
.globl vector165
vector165:
  pushl $0
c0102424:	6a 00                	push   $0x0
  pushl $165
c0102426:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c010242b:	e9 38 04 00 00       	jmp    c0102868 <__alltraps>

c0102430 <vector166>:
.globl vector166
vector166:
  pushl $0
c0102430:	6a 00                	push   $0x0
  pushl $166
c0102432:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c0102437:	e9 2c 04 00 00       	jmp    c0102868 <__alltraps>

c010243c <vector167>:
.globl vector167
vector167:
  pushl $0
c010243c:	6a 00                	push   $0x0
  pushl $167
c010243e:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c0102443:	e9 20 04 00 00       	jmp    c0102868 <__alltraps>

c0102448 <vector168>:
.globl vector168
vector168:
  pushl $0
c0102448:	6a 00                	push   $0x0
  pushl $168
c010244a:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c010244f:	e9 14 04 00 00       	jmp    c0102868 <__alltraps>

c0102454 <vector169>:
.globl vector169
vector169:
  pushl $0
c0102454:	6a 00                	push   $0x0
  pushl $169
c0102456:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c010245b:	e9 08 04 00 00       	jmp    c0102868 <__alltraps>

c0102460 <vector170>:
.globl vector170
vector170:
  pushl $0
c0102460:	6a 00                	push   $0x0
  pushl $170
c0102462:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c0102467:	e9 fc 03 00 00       	jmp    c0102868 <__alltraps>

c010246c <vector171>:
.globl vector171
vector171:
  pushl $0
c010246c:	6a 00                	push   $0x0
  pushl $171
c010246e:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c0102473:	e9 f0 03 00 00       	jmp    c0102868 <__alltraps>

c0102478 <vector172>:
.globl vector172
vector172:
  pushl $0
c0102478:	6a 00                	push   $0x0
  pushl $172
c010247a:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c010247f:	e9 e4 03 00 00       	jmp    c0102868 <__alltraps>

c0102484 <vector173>:
.globl vector173
vector173:
  pushl $0
c0102484:	6a 00                	push   $0x0
  pushl $173
c0102486:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c010248b:	e9 d8 03 00 00       	jmp    c0102868 <__alltraps>

c0102490 <vector174>:
.globl vector174
vector174:
  pushl $0
c0102490:	6a 00                	push   $0x0
  pushl $174
c0102492:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c0102497:	e9 cc 03 00 00       	jmp    c0102868 <__alltraps>

c010249c <vector175>:
.globl vector175
vector175:
  pushl $0
c010249c:	6a 00                	push   $0x0
  pushl $175
c010249e:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c01024a3:	e9 c0 03 00 00       	jmp    c0102868 <__alltraps>

c01024a8 <vector176>:
.globl vector176
vector176:
  pushl $0
c01024a8:	6a 00                	push   $0x0
  pushl $176
c01024aa:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c01024af:	e9 b4 03 00 00       	jmp    c0102868 <__alltraps>

c01024b4 <vector177>:
.globl vector177
vector177:
  pushl $0
c01024b4:	6a 00                	push   $0x0
  pushl $177
c01024b6:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c01024bb:	e9 a8 03 00 00       	jmp    c0102868 <__alltraps>

c01024c0 <vector178>:
.globl vector178
vector178:
  pushl $0
c01024c0:	6a 00                	push   $0x0
  pushl $178
c01024c2:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c01024c7:	e9 9c 03 00 00       	jmp    c0102868 <__alltraps>

c01024cc <vector179>:
.globl vector179
vector179:
  pushl $0
c01024cc:	6a 00                	push   $0x0
  pushl $179
c01024ce:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c01024d3:	e9 90 03 00 00       	jmp    c0102868 <__alltraps>

c01024d8 <vector180>:
.globl vector180
vector180:
  pushl $0
c01024d8:	6a 00                	push   $0x0
  pushl $180
c01024da:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c01024df:	e9 84 03 00 00       	jmp    c0102868 <__alltraps>

c01024e4 <vector181>:
.globl vector181
vector181:
  pushl $0
c01024e4:	6a 00                	push   $0x0
  pushl $181
c01024e6:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c01024eb:	e9 78 03 00 00       	jmp    c0102868 <__alltraps>

c01024f0 <vector182>:
.globl vector182
vector182:
  pushl $0
c01024f0:	6a 00                	push   $0x0
  pushl $182
c01024f2:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c01024f7:	e9 6c 03 00 00       	jmp    c0102868 <__alltraps>

c01024fc <vector183>:
.globl vector183
vector183:
  pushl $0
c01024fc:	6a 00                	push   $0x0
  pushl $183
c01024fe:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c0102503:	e9 60 03 00 00       	jmp    c0102868 <__alltraps>

c0102508 <vector184>:
.globl vector184
vector184:
  pushl $0
c0102508:	6a 00                	push   $0x0
  pushl $184
c010250a:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c010250f:	e9 54 03 00 00       	jmp    c0102868 <__alltraps>

c0102514 <vector185>:
.globl vector185
vector185:
  pushl $0
c0102514:	6a 00                	push   $0x0
  pushl $185
c0102516:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c010251b:	e9 48 03 00 00       	jmp    c0102868 <__alltraps>

c0102520 <vector186>:
.globl vector186
vector186:
  pushl $0
c0102520:	6a 00                	push   $0x0
  pushl $186
c0102522:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c0102527:	e9 3c 03 00 00       	jmp    c0102868 <__alltraps>

c010252c <vector187>:
.globl vector187
vector187:
  pushl $0
c010252c:	6a 00                	push   $0x0
  pushl $187
c010252e:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c0102533:	e9 30 03 00 00       	jmp    c0102868 <__alltraps>

c0102538 <vector188>:
.globl vector188
vector188:
  pushl $0
c0102538:	6a 00                	push   $0x0
  pushl $188
c010253a:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c010253f:	e9 24 03 00 00       	jmp    c0102868 <__alltraps>

c0102544 <vector189>:
.globl vector189
vector189:
  pushl $0
c0102544:	6a 00                	push   $0x0
  pushl $189
c0102546:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c010254b:	e9 18 03 00 00       	jmp    c0102868 <__alltraps>

c0102550 <vector190>:
.globl vector190
vector190:
  pushl $0
c0102550:	6a 00                	push   $0x0
  pushl $190
c0102552:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c0102557:	e9 0c 03 00 00       	jmp    c0102868 <__alltraps>

c010255c <vector191>:
.globl vector191
vector191:
  pushl $0
c010255c:	6a 00                	push   $0x0
  pushl $191
c010255e:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c0102563:	e9 00 03 00 00       	jmp    c0102868 <__alltraps>

c0102568 <vector192>:
.globl vector192
vector192:
  pushl $0
c0102568:	6a 00                	push   $0x0
  pushl $192
c010256a:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c010256f:	e9 f4 02 00 00       	jmp    c0102868 <__alltraps>

c0102574 <vector193>:
.globl vector193
vector193:
  pushl $0
c0102574:	6a 00                	push   $0x0
  pushl $193
c0102576:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c010257b:	e9 e8 02 00 00       	jmp    c0102868 <__alltraps>

c0102580 <vector194>:
.globl vector194
vector194:
  pushl $0
c0102580:	6a 00                	push   $0x0
  pushl $194
c0102582:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c0102587:	e9 dc 02 00 00       	jmp    c0102868 <__alltraps>

c010258c <vector195>:
.globl vector195
vector195:
  pushl $0
c010258c:	6a 00                	push   $0x0
  pushl $195
c010258e:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c0102593:	e9 d0 02 00 00       	jmp    c0102868 <__alltraps>

c0102598 <vector196>:
.globl vector196
vector196:
  pushl $0
c0102598:	6a 00                	push   $0x0
  pushl $196
c010259a:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c010259f:	e9 c4 02 00 00       	jmp    c0102868 <__alltraps>

c01025a4 <vector197>:
.globl vector197
vector197:
  pushl $0
c01025a4:	6a 00                	push   $0x0
  pushl $197
c01025a6:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c01025ab:	e9 b8 02 00 00       	jmp    c0102868 <__alltraps>

c01025b0 <vector198>:
.globl vector198
vector198:
  pushl $0
c01025b0:	6a 00                	push   $0x0
  pushl $198
c01025b2:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c01025b7:	e9 ac 02 00 00       	jmp    c0102868 <__alltraps>

c01025bc <vector199>:
.globl vector199
vector199:
  pushl $0
c01025bc:	6a 00                	push   $0x0
  pushl $199
c01025be:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c01025c3:	e9 a0 02 00 00       	jmp    c0102868 <__alltraps>

c01025c8 <vector200>:
.globl vector200
vector200:
  pushl $0
c01025c8:	6a 00                	push   $0x0
  pushl $200
c01025ca:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c01025cf:	e9 94 02 00 00       	jmp    c0102868 <__alltraps>

c01025d4 <vector201>:
.globl vector201
vector201:
  pushl $0
c01025d4:	6a 00                	push   $0x0
  pushl $201
c01025d6:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c01025db:	e9 88 02 00 00       	jmp    c0102868 <__alltraps>

c01025e0 <vector202>:
.globl vector202
vector202:
  pushl $0
c01025e0:	6a 00                	push   $0x0
  pushl $202
c01025e2:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c01025e7:	e9 7c 02 00 00       	jmp    c0102868 <__alltraps>

c01025ec <vector203>:
.globl vector203
vector203:
  pushl $0
c01025ec:	6a 00                	push   $0x0
  pushl $203
c01025ee:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c01025f3:	e9 70 02 00 00       	jmp    c0102868 <__alltraps>

c01025f8 <vector204>:
.globl vector204
vector204:
  pushl $0
c01025f8:	6a 00                	push   $0x0
  pushl $204
c01025fa:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c01025ff:	e9 64 02 00 00       	jmp    c0102868 <__alltraps>

c0102604 <vector205>:
.globl vector205
vector205:
  pushl $0
c0102604:	6a 00                	push   $0x0
  pushl $205
c0102606:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c010260b:	e9 58 02 00 00       	jmp    c0102868 <__alltraps>

c0102610 <vector206>:
.globl vector206
vector206:
  pushl $0
c0102610:	6a 00                	push   $0x0
  pushl $206
c0102612:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c0102617:	e9 4c 02 00 00       	jmp    c0102868 <__alltraps>

c010261c <vector207>:
.globl vector207
vector207:
  pushl $0
c010261c:	6a 00                	push   $0x0
  pushl $207
c010261e:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c0102623:	e9 40 02 00 00       	jmp    c0102868 <__alltraps>

c0102628 <vector208>:
.globl vector208
vector208:
  pushl $0
c0102628:	6a 00                	push   $0x0
  pushl $208
c010262a:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c010262f:	e9 34 02 00 00       	jmp    c0102868 <__alltraps>

c0102634 <vector209>:
.globl vector209
vector209:
  pushl $0
c0102634:	6a 00                	push   $0x0
  pushl $209
c0102636:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c010263b:	e9 28 02 00 00       	jmp    c0102868 <__alltraps>

c0102640 <vector210>:
.globl vector210
vector210:
  pushl $0
c0102640:	6a 00                	push   $0x0
  pushl $210
c0102642:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c0102647:	e9 1c 02 00 00       	jmp    c0102868 <__alltraps>

c010264c <vector211>:
.globl vector211
vector211:
  pushl $0
c010264c:	6a 00                	push   $0x0
  pushl $211
c010264e:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c0102653:	e9 10 02 00 00       	jmp    c0102868 <__alltraps>

c0102658 <vector212>:
.globl vector212
vector212:
  pushl $0
c0102658:	6a 00                	push   $0x0
  pushl $212
c010265a:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c010265f:	e9 04 02 00 00       	jmp    c0102868 <__alltraps>

c0102664 <vector213>:
.globl vector213
vector213:
  pushl $0
c0102664:	6a 00                	push   $0x0
  pushl $213
c0102666:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c010266b:	e9 f8 01 00 00       	jmp    c0102868 <__alltraps>

c0102670 <vector214>:
.globl vector214
vector214:
  pushl $0
c0102670:	6a 00                	push   $0x0
  pushl $214
c0102672:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c0102677:	e9 ec 01 00 00       	jmp    c0102868 <__alltraps>

c010267c <vector215>:
.globl vector215
vector215:
  pushl $0
c010267c:	6a 00                	push   $0x0
  pushl $215
c010267e:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c0102683:	e9 e0 01 00 00       	jmp    c0102868 <__alltraps>

c0102688 <vector216>:
.globl vector216
vector216:
  pushl $0
c0102688:	6a 00                	push   $0x0
  pushl $216
c010268a:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c010268f:	e9 d4 01 00 00       	jmp    c0102868 <__alltraps>

c0102694 <vector217>:
.globl vector217
vector217:
  pushl $0
c0102694:	6a 00                	push   $0x0
  pushl $217
c0102696:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c010269b:	e9 c8 01 00 00       	jmp    c0102868 <__alltraps>

c01026a0 <vector218>:
.globl vector218
vector218:
  pushl $0
c01026a0:	6a 00                	push   $0x0
  pushl $218
c01026a2:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c01026a7:	e9 bc 01 00 00       	jmp    c0102868 <__alltraps>

c01026ac <vector219>:
.globl vector219
vector219:
  pushl $0
c01026ac:	6a 00                	push   $0x0
  pushl $219
c01026ae:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c01026b3:	e9 b0 01 00 00       	jmp    c0102868 <__alltraps>

c01026b8 <vector220>:
.globl vector220
vector220:
  pushl $0
c01026b8:	6a 00                	push   $0x0
  pushl $220
c01026ba:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c01026bf:	e9 a4 01 00 00       	jmp    c0102868 <__alltraps>

c01026c4 <vector221>:
.globl vector221
vector221:
  pushl $0
c01026c4:	6a 00                	push   $0x0
  pushl $221
c01026c6:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c01026cb:	e9 98 01 00 00       	jmp    c0102868 <__alltraps>

c01026d0 <vector222>:
.globl vector222
vector222:
  pushl $0
c01026d0:	6a 00                	push   $0x0
  pushl $222
c01026d2:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c01026d7:	e9 8c 01 00 00       	jmp    c0102868 <__alltraps>

c01026dc <vector223>:
.globl vector223
vector223:
  pushl $0
c01026dc:	6a 00                	push   $0x0
  pushl $223
c01026de:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c01026e3:	e9 80 01 00 00       	jmp    c0102868 <__alltraps>

c01026e8 <vector224>:
.globl vector224
vector224:
  pushl $0
c01026e8:	6a 00                	push   $0x0
  pushl $224
c01026ea:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c01026ef:	e9 74 01 00 00       	jmp    c0102868 <__alltraps>

c01026f4 <vector225>:
.globl vector225
vector225:
  pushl $0
c01026f4:	6a 00                	push   $0x0
  pushl $225
c01026f6:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c01026fb:	e9 68 01 00 00       	jmp    c0102868 <__alltraps>

c0102700 <vector226>:
.globl vector226
vector226:
  pushl $0
c0102700:	6a 00                	push   $0x0
  pushl $226
c0102702:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c0102707:	e9 5c 01 00 00       	jmp    c0102868 <__alltraps>

c010270c <vector227>:
.globl vector227
vector227:
  pushl $0
c010270c:	6a 00                	push   $0x0
  pushl $227
c010270e:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c0102713:	e9 50 01 00 00       	jmp    c0102868 <__alltraps>

c0102718 <vector228>:
.globl vector228
vector228:
  pushl $0
c0102718:	6a 00                	push   $0x0
  pushl $228
c010271a:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c010271f:	e9 44 01 00 00       	jmp    c0102868 <__alltraps>

c0102724 <vector229>:
.globl vector229
vector229:
  pushl $0
c0102724:	6a 00                	push   $0x0
  pushl $229
c0102726:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c010272b:	e9 38 01 00 00       	jmp    c0102868 <__alltraps>

c0102730 <vector230>:
.globl vector230
vector230:
  pushl $0
c0102730:	6a 00                	push   $0x0
  pushl $230
c0102732:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c0102737:	e9 2c 01 00 00       	jmp    c0102868 <__alltraps>

c010273c <vector231>:
.globl vector231
vector231:
  pushl $0
c010273c:	6a 00                	push   $0x0
  pushl $231
c010273e:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c0102743:	e9 20 01 00 00       	jmp    c0102868 <__alltraps>

c0102748 <vector232>:
.globl vector232
vector232:
  pushl $0
c0102748:	6a 00                	push   $0x0
  pushl $232
c010274a:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c010274f:	e9 14 01 00 00       	jmp    c0102868 <__alltraps>

c0102754 <vector233>:
.globl vector233
vector233:
  pushl $0
c0102754:	6a 00                	push   $0x0
  pushl $233
c0102756:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c010275b:	e9 08 01 00 00       	jmp    c0102868 <__alltraps>

c0102760 <vector234>:
.globl vector234
vector234:
  pushl $0
c0102760:	6a 00                	push   $0x0
  pushl $234
c0102762:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c0102767:	e9 fc 00 00 00       	jmp    c0102868 <__alltraps>

c010276c <vector235>:
.globl vector235
vector235:
  pushl $0
c010276c:	6a 00                	push   $0x0
  pushl $235
c010276e:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c0102773:	e9 f0 00 00 00       	jmp    c0102868 <__alltraps>

c0102778 <vector236>:
.globl vector236
vector236:
  pushl $0
c0102778:	6a 00                	push   $0x0
  pushl $236
c010277a:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c010277f:	e9 e4 00 00 00       	jmp    c0102868 <__alltraps>

c0102784 <vector237>:
.globl vector237
vector237:
  pushl $0
c0102784:	6a 00                	push   $0x0
  pushl $237
c0102786:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c010278b:	e9 d8 00 00 00       	jmp    c0102868 <__alltraps>

c0102790 <vector238>:
.globl vector238
vector238:
  pushl $0
c0102790:	6a 00                	push   $0x0
  pushl $238
c0102792:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c0102797:	e9 cc 00 00 00       	jmp    c0102868 <__alltraps>

c010279c <vector239>:
.globl vector239
vector239:
  pushl $0
c010279c:	6a 00                	push   $0x0
  pushl $239
c010279e:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c01027a3:	e9 c0 00 00 00       	jmp    c0102868 <__alltraps>

c01027a8 <vector240>:
.globl vector240
vector240:
  pushl $0
c01027a8:	6a 00                	push   $0x0
  pushl $240
c01027aa:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c01027af:	e9 b4 00 00 00       	jmp    c0102868 <__alltraps>

c01027b4 <vector241>:
.globl vector241
vector241:
  pushl $0
c01027b4:	6a 00                	push   $0x0
  pushl $241
c01027b6:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c01027bb:	e9 a8 00 00 00       	jmp    c0102868 <__alltraps>

c01027c0 <vector242>:
.globl vector242
vector242:
  pushl $0
c01027c0:	6a 00                	push   $0x0
  pushl $242
c01027c2:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c01027c7:	e9 9c 00 00 00       	jmp    c0102868 <__alltraps>

c01027cc <vector243>:
.globl vector243
vector243:
  pushl $0
c01027cc:	6a 00                	push   $0x0
  pushl $243
c01027ce:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c01027d3:	e9 90 00 00 00       	jmp    c0102868 <__alltraps>

c01027d8 <vector244>:
.globl vector244
vector244:
  pushl $0
c01027d8:	6a 00                	push   $0x0
  pushl $244
c01027da:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c01027df:	e9 84 00 00 00       	jmp    c0102868 <__alltraps>

c01027e4 <vector245>:
.globl vector245
vector245:
  pushl $0
c01027e4:	6a 00                	push   $0x0
  pushl $245
c01027e6:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c01027eb:	e9 78 00 00 00       	jmp    c0102868 <__alltraps>

c01027f0 <vector246>:
.globl vector246
vector246:
  pushl $0
c01027f0:	6a 00                	push   $0x0
  pushl $246
c01027f2:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c01027f7:	e9 6c 00 00 00       	jmp    c0102868 <__alltraps>

c01027fc <vector247>:
.globl vector247
vector247:
  pushl $0
c01027fc:	6a 00                	push   $0x0
  pushl $247
c01027fe:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c0102803:	e9 60 00 00 00       	jmp    c0102868 <__alltraps>

c0102808 <vector248>:
.globl vector248
vector248:
  pushl $0
c0102808:	6a 00                	push   $0x0
  pushl $248
c010280a:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c010280f:	e9 54 00 00 00       	jmp    c0102868 <__alltraps>

c0102814 <vector249>:
.globl vector249
vector249:
  pushl $0
c0102814:	6a 00                	push   $0x0
  pushl $249
c0102816:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c010281b:	e9 48 00 00 00       	jmp    c0102868 <__alltraps>

c0102820 <vector250>:
.globl vector250
vector250:
  pushl $0
c0102820:	6a 00                	push   $0x0
  pushl $250
c0102822:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c0102827:	e9 3c 00 00 00       	jmp    c0102868 <__alltraps>

c010282c <vector251>:
.globl vector251
vector251:
  pushl $0
c010282c:	6a 00                	push   $0x0
  pushl $251
c010282e:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c0102833:	e9 30 00 00 00       	jmp    c0102868 <__alltraps>

c0102838 <vector252>:
.globl vector252
vector252:
  pushl $0
c0102838:	6a 00                	push   $0x0
  pushl $252
c010283a:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c010283f:	e9 24 00 00 00       	jmp    c0102868 <__alltraps>

c0102844 <vector253>:
.globl vector253
vector253:
  pushl $0
c0102844:	6a 00                	push   $0x0
  pushl $253
c0102846:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c010284b:	e9 18 00 00 00       	jmp    c0102868 <__alltraps>

c0102850 <vector254>:
.globl vector254
vector254:
  pushl $0
c0102850:	6a 00                	push   $0x0
  pushl $254
c0102852:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c0102857:	e9 0c 00 00 00       	jmp    c0102868 <__alltraps>

c010285c <vector255>:
.globl vector255
vector255:
  pushl $0
c010285c:	6a 00                	push   $0x0
  pushl $255
c010285e:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c0102863:	e9 00 00 00 00       	jmp    c0102868 <__alltraps>

c0102868 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0102868:	1e                   	push   %ds
    pushl %es
c0102869:	06                   	push   %es
    pushl %fs
c010286a:	0f a0                	push   %fs
    pushl %gs
c010286c:	0f a8                	push   %gs
    pushal
c010286e:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c010286f:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0102874:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0102876:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0102878:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0102879:	e8 63 f5 ff ff       	call   c0101de1 <trap>

    # pop the pushed stack pointer
    popl %esp
c010287e:	5c                   	pop    %esp

c010287f <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c010287f:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0102880:	0f a9                	pop    %gs
    popl %fs
c0102882:	0f a1                	pop    %fs
    popl %es
c0102884:	07                   	pop    %es
    popl %ds
c0102885:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0102886:	83 c4 08             	add    $0x8,%esp
    iret
c0102889:	cf                   	iret   

c010288a <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c010288a:	55                   	push   %ebp
c010288b:	89 e5                	mov    %esp,%ebp
    return page - pages;
c010288d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102890:	8b 15 58 89 11 c0    	mov    0xc0118958,%edx
c0102896:	29 d0                	sub    %edx,%eax
c0102898:	c1 f8 02             	sar    $0x2,%eax
c010289b:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c01028a1:	5d                   	pop    %ebp
c01028a2:	c3                   	ret    

c01028a3 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c01028a3:	55                   	push   %ebp
c01028a4:	89 e5                	mov    %esp,%ebp
    return page2ppn(page) << PGSHIFT;
c01028a6:	ff 75 08             	pushl  0x8(%ebp)
c01028a9:	e8 dc ff ff ff       	call   c010288a <page2ppn>
c01028ae:	83 c4 04             	add    $0x4,%esp
c01028b1:	c1 e0 0c             	shl    $0xc,%eax
}
c01028b4:	c9                   	leave  
c01028b5:	c3                   	ret    

c01028b6 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c01028b6:	55                   	push   %ebp
c01028b7:	89 e5                	mov    %esp,%ebp
c01028b9:	83 ec 08             	sub    $0x8,%esp
    if (PPN(pa) >= npage) {
c01028bc:	8b 45 08             	mov    0x8(%ebp),%eax
c01028bf:	c1 e8 0c             	shr    $0xc,%eax
c01028c2:	89 c2                	mov    %eax,%edx
c01028c4:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c01028c9:	39 c2                	cmp    %eax,%edx
c01028cb:	72 14                	jb     c01028e1 <pa2page+0x2b>
        panic("pa2page called with invalid pa");
c01028cd:	83 ec 04             	sub    $0x4,%esp
c01028d0:	68 70 61 10 c0       	push   $0xc0106170
c01028d5:	6a 5a                	push   $0x5a
c01028d7:	68 8f 61 10 c0       	push   $0xc010618f
c01028dc:	e8 ec da ff ff       	call   c01003cd <__panic>
    }
    return &pages[PPN(pa)];
c01028e1:	8b 0d 58 89 11 c0    	mov    0xc0118958,%ecx
c01028e7:	8b 45 08             	mov    0x8(%ebp),%eax
c01028ea:	c1 e8 0c             	shr    $0xc,%eax
c01028ed:	89 c2                	mov    %eax,%edx
c01028ef:	89 d0                	mov    %edx,%eax
c01028f1:	c1 e0 02             	shl    $0x2,%eax
c01028f4:	01 d0                	add    %edx,%eax
c01028f6:	c1 e0 02             	shl    $0x2,%eax
c01028f9:	01 c8                	add    %ecx,%eax
}
c01028fb:	c9                   	leave  
c01028fc:	c3                   	ret    

c01028fd <page2kva>:

static inline void *
page2kva(struct Page *page) {
c01028fd:	55                   	push   %ebp
c01028fe:	89 e5                	mov    %esp,%ebp
c0102900:	83 ec 18             	sub    $0x18,%esp
    return KADDR(page2pa(page));
c0102903:	ff 75 08             	pushl  0x8(%ebp)
c0102906:	e8 98 ff ff ff       	call   c01028a3 <page2pa>
c010290b:	83 c4 04             	add    $0x4,%esp
c010290e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102911:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102914:	c1 e8 0c             	shr    $0xc,%eax
c0102917:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010291a:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c010291f:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0102922:	72 14                	jb     c0102938 <page2kva+0x3b>
c0102924:	ff 75 f4             	pushl  -0xc(%ebp)
c0102927:	68 a0 61 10 c0       	push   $0xc01061a0
c010292c:	6a 61                	push   $0x61
c010292e:	68 8f 61 10 c0       	push   $0xc010618f
c0102933:	e8 95 da ff ff       	call   c01003cd <__panic>
c0102938:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010293b:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0102940:	c9                   	leave  
c0102941:	c3                   	ret    

c0102942 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0102942:	55                   	push   %ebp
c0102943:	89 e5                	mov    %esp,%ebp
c0102945:	83 ec 08             	sub    $0x8,%esp
    if (!(pte & PTE_P)) {
c0102948:	8b 45 08             	mov    0x8(%ebp),%eax
c010294b:	83 e0 01             	and    $0x1,%eax
c010294e:	85 c0                	test   %eax,%eax
c0102950:	75 14                	jne    c0102966 <pte2page+0x24>
        panic("pte2page called with invalid pte");
c0102952:	83 ec 04             	sub    $0x4,%esp
c0102955:	68 c4 61 10 c0       	push   $0xc01061c4
c010295a:	6a 6c                	push   $0x6c
c010295c:	68 8f 61 10 c0       	push   $0xc010618f
c0102961:	e8 67 da ff ff       	call   c01003cd <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0102966:	8b 45 08             	mov    0x8(%ebp),%eax
c0102969:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010296e:	83 ec 0c             	sub    $0xc,%esp
c0102971:	50                   	push   %eax
c0102972:	e8 3f ff ff ff       	call   c01028b6 <pa2page>
c0102977:	83 c4 10             	add    $0x10,%esp
}
c010297a:	c9                   	leave  
c010297b:	c3                   	ret    

c010297c <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
c010297c:	55                   	push   %ebp
c010297d:	89 e5                	mov    %esp,%ebp
c010297f:	83 ec 08             	sub    $0x8,%esp
    return pa2page(PDE_ADDR(pde));
c0102982:	8b 45 08             	mov    0x8(%ebp),%eax
c0102985:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010298a:	83 ec 0c             	sub    $0xc,%esp
c010298d:	50                   	push   %eax
c010298e:	e8 23 ff ff ff       	call   c01028b6 <pa2page>
c0102993:	83 c4 10             	add    $0x10,%esp
}
c0102996:	c9                   	leave  
c0102997:	c3                   	ret    

c0102998 <page_ref>:

static inline int
page_ref(struct Page *page) {
c0102998:	55                   	push   %ebp
c0102999:	89 e5                	mov    %esp,%ebp
    return page->ref;
c010299b:	8b 45 08             	mov    0x8(%ebp),%eax
c010299e:	8b 00                	mov    (%eax),%eax
}
c01029a0:	5d                   	pop    %ebp
c01029a1:	c3                   	ret    

c01029a2 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c01029a2:	55                   	push   %ebp
c01029a3:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c01029a5:	8b 45 08             	mov    0x8(%ebp),%eax
c01029a8:	8b 55 0c             	mov    0xc(%ebp),%edx
c01029ab:	89 10                	mov    %edx,(%eax)
}
c01029ad:	90                   	nop
c01029ae:	5d                   	pop    %ebp
c01029af:	c3                   	ret    

c01029b0 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c01029b0:	55                   	push   %ebp
c01029b1:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c01029b3:	8b 45 08             	mov    0x8(%ebp),%eax
c01029b6:	8b 00                	mov    (%eax),%eax
c01029b8:	8d 50 01             	lea    0x1(%eax),%edx
c01029bb:	8b 45 08             	mov    0x8(%ebp),%eax
c01029be:	89 10                	mov    %edx,(%eax)
    return page->ref;
c01029c0:	8b 45 08             	mov    0x8(%ebp),%eax
c01029c3:	8b 00                	mov    (%eax),%eax
}
c01029c5:	5d                   	pop    %ebp
c01029c6:	c3                   	ret    

c01029c7 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c01029c7:	55                   	push   %ebp
c01029c8:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c01029ca:	8b 45 08             	mov    0x8(%ebp),%eax
c01029cd:	8b 00                	mov    (%eax),%eax
c01029cf:	8d 50 ff             	lea    -0x1(%eax),%edx
c01029d2:	8b 45 08             	mov    0x8(%ebp),%eax
c01029d5:	89 10                	mov    %edx,(%eax)
    return page->ref;
c01029d7:	8b 45 08             	mov    0x8(%ebp),%eax
c01029da:	8b 00                	mov    (%eax),%eax
}
c01029dc:	5d                   	pop    %ebp
c01029dd:	c3                   	ret    

c01029de <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c01029de:	55                   	push   %ebp
c01029df:	89 e5                	mov    %esp,%ebp
c01029e1:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c01029e4:	9c                   	pushf  
c01029e5:	58                   	pop    %eax
c01029e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c01029e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c01029ec:	25 00 02 00 00       	and    $0x200,%eax
c01029f1:	85 c0                	test   %eax,%eax
c01029f3:	74 0c                	je     c0102a01 <__intr_save+0x23>
        intr_disable();
c01029f5:	e8 5a ee ff ff       	call   c0101854 <intr_disable>
        return 1;
c01029fa:	b8 01 00 00 00       	mov    $0x1,%eax
c01029ff:	eb 05                	jmp    c0102a06 <__intr_save+0x28>
    }
    return 0;
c0102a01:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0102a06:	c9                   	leave  
c0102a07:	c3                   	ret    

c0102a08 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0102a08:	55                   	push   %ebp
c0102a09:	89 e5                	mov    %esp,%ebp
c0102a0b:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0102a0e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0102a12:	74 05                	je     c0102a19 <__intr_restore+0x11>
        intr_enable();
c0102a14:	e8 34 ee ff ff       	call   c010184d <intr_enable>
    }
}
c0102a19:	90                   	nop
c0102a1a:	c9                   	leave  
c0102a1b:	c3                   	ret    

c0102a1c <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0102a1c:	55                   	push   %ebp
c0102a1d:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0102a1f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a22:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0102a25:	b8 23 00 00 00       	mov    $0x23,%eax
c0102a2a:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0102a2c:	b8 23 00 00 00       	mov    $0x23,%eax
c0102a31:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0102a33:	b8 10 00 00 00       	mov    $0x10,%eax
c0102a38:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0102a3a:	b8 10 00 00 00       	mov    $0x10,%eax
c0102a3f:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0102a41:	b8 10 00 00 00       	mov    $0x10,%eax
c0102a46:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0102a48:	ea 4f 2a 10 c0 08 00 	ljmp   $0x8,$0xc0102a4f
}
c0102a4f:	90                   	nop
c0102a50:	5d                   	pop    %ebp
c0102a51:	c3                   	ret    

c0102a52 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0102a52:	55                   	push   %ebp
c0102a53:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0102a55:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a58:	a3 e4 88 11 c0       	mov    %eax,0xc01188e4
}
c0102a5d:	90                   	nop
c0102a5e:	5d                   	pop    %ebp
c0102a5f:	c3                   	ret    

c0102a60 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0102a60:	55                   	push   %ebp
c0102a61:	89 e5                	mov    %esp,%ebp
c0102a63:	83 ec 10             	sub    $0x10,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0102a66:	b8 00 70 11 c0       	mov    $0xc0117000,%eax
c0102a6b:	50                   	push   %eax
c0102a6c:	e8 e1 ff ff ff       	call   c0102a52 <load_esp0>
c0102a71:	83 c4 04             	add    $0x4,%esp
    ts.ts_ss0 = KERNEL_DS;
c0102a74:	66 c7 05 e8 88 11 c0 	movw   $0x10,0xc01188e8
c0102a7b:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0102a7d:	66 c7 05 28 7a 11 c0 	movw   $0x68,0xc0117a28
c0102a84:	68 00 
c0102a86:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0102a8b:	66 a3 2a 7a 11 c0    	mov    %ax,0xc0117a2a
c0102a91:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0102a96:	c1 e8 10             	shr    $0x10,%eax
c0102a99:	a2 2c 7a 11 c0       	mov    %al,0xc0117a2c
c0102a9e:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0102aa5:	83 e0 f0             	and    $0xfffffff0,%eax
c0102aa8:	83 c8 09             	or     $0x9,%eax
c0102aab:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0102ab0:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0102ab7:	83 e0 ef             	and    $0xffffffef,%eax
c0102aba:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0102abf:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0102ac6:	83 e0 9f             	and    $0xffffff9f,%eax
c0102ac9:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0102ace:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0102ad5:	83 c8 80             	or     $0xffffff80,%eax
c0102ad8:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0102add:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0102ae4:	83 e0 f0             	and    $0xfffffff0,%eax
c0102ae7:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0102aec:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0102af3:	83 e0 ef             	and    $0xffffffef,%eax
c0102af6:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0102afb:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0102b02:	83 e0 df             	and    $0xffffffdf,%eax
c0102b05:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0102b0a:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0102b11:	83 c8 40             	or     $0x40,%eax
c0102b14:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0102b19:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0102b20:	83 e0 7f             	and    $0x7f,%eax
c0102b23:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0102b28:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0102b2d:	c1 e8 18             	shr    $0x18,%eax
c0102b30:	a2 2f 7a 11 c0       	mov    %al,0xc0117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0102b35:	68 30 7a 11 c0       	push   $0xc0117a30
c0102b3a:	e8 dd fe ff ff       	call   c0102a1c <lgdt>
c0102b3f:	83 c4 04             	add    $0x4,%esp
c0102b42:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0102b48:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0102b4c:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0102b4f:	90                   	nop
c0102b50:	c9                   	leave  
c0102b51:	c3                   	ret    

c0102b52 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0102b52:	55                   	push   %ebp
c0102b53:	89 e5                	mov    %esp,%ebp
c0102b55:	83 ec 08             	sub    $0x8,%esp
    pmm_manager = &default_pmm_manager;
c0102b58:	c7 05 50 89 11 c0 38 	movl   $0xc0106b38,0xc0118950
c0102b5f:	6b 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0102b62:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c0102b67:	8b 00                	mov    (%eax),%eax
c0102b69:	83 ec 08             	sub    $0x8,%esp
c0102b6c:	50                   	push   %eax
c0102b6d:	68 f0 61 10 c0       	push   $0xc01061f0
c0102b72:	e8 f0 d6 ff ff       	call   c0100267 <cprintf>
c0102b77:	83 c4 10             	add    $0x10,%esp
    pmm_manager->init();
c0102b7a:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c0102b7f:	8b 40 04             	mov    0x4(%eax),%eax
c0102b82:	ff d0                	call   *%eax
}
c0102b84:	90                   	nop
c0102b85:	c9                   	leave  
c0102b86:	c3                   	ret    

c0102b87 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0102b87:	55                   	push   %ebp
c0102b88:	89 e5                	mov    %esp,%ebp
c0102b8a:	83 ec 08             	sub    $0x8,%esp
    pmm_manager->init_memmap(base, n);
c0102b8d:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c0102b92:	8b 40 08             	mov    0x8(%eax),%eax
c0102b95:	83 ec 08             	sub    $0x8,%esp
c0102b98:	ff 75 0c             	pushl  0xc(%ebp)
c0102b9b:	ff 75 08             	pushl  0x8(%ebp)
c0102b9e:	ff d0                	call   *%eax
c0102ba0:	83 c4 10             	add    $0x10,%esp
}
c0102ba3:	90                   	nop
c0102ba4:	c9                   	leave  
c0102ba5:	c3                   	ret    

c0102ba6 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0102ba6:	55                   	push   %ebp
c0102ba7:	89 e5                	mov    %esp,%ebp
c0102ba9:	83 ec 18             	sub    $0x18,%esp
    struct Page *page=NULL;
c0102bac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0102bb3:	e8 26 fe ff ff       	call   c01029de <__intr_save>
c0102bb8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0102bbb:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c0102bc0:	8b 40 0c             	mov    0xc(%eax),%eax
c0102bc3:	83 ec 0c             	sub    $0xc,%esp
c0102bc6:	ff 75 08             	pushl  0x8(%ebp)
c0102bc9:	ff d0                	call   *%eax
c0102bcb:	83 c4 10             	add    $0x10,%esp
c0102bce:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0102bd1:	83 ec 0c             	sub    $0xc,%esp
c0102bd4:	ff 75 f0             	pushl  -0x10(%ebp)
c0102bd7:	e8 2c fe ff ff       	call   c0102a08 <__intr_restore>
c0102bdc:	83 c4 10             	add    $0x10,%esp
    return page;
c0102bdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0102be2:	c9                   	leave  
c0102be3:	c3                   	ret    

c0102be4 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0102be4:	55                   	push   %ebp
c0102be5:	89 e5                	mov    %esp,%ebp
c0102be7:	83 ec 18             	sub    $0x18,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0102bea:	e8 ef fd ff ff       	call   c01029de <__intr_save>
c0102bef:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0102bf2:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c0102bf7:	8b 40 10             	mov    0x10(%eax),%eax
c0102bfa:	83 ec 08             	sub    $0x8,%esp
c0102bfd:	ff 75 0c             	pushl  0xc(%ebp)
c0102c00:	ff 75 08             	pushl  0x8(%ebp)
c0102c03:	ff d0                	call   *%eax
c0102c05:	83 c4 10             	add    $0x10,%esp
    }
    local_intr_restore(intr_flag);
c0102c08:	83 ec 0c             	sub    $0xc,%esp
c0102c0b:	ff 75 f4             	pushl  -0xc(%ebp)
c0102c0e:	e8 f5 fd ff ff       	call   c0102a08 <__intr_restore>
c0102c13:	83 c4 10             	add    $0x10,%esp
}
c0102c16:	90                   	nop
c0102c17:	c9                   	leave  
c0102c18:	c3                   	ret    

c0102c19 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0102c19:	55                   	push   %ebp
c0102c1a:	89 e5                	mov    %esp,%ebp
c0102c1c:	83 ec 18             	sub    $0x18,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0102c1f:	e8 ba fd ff ff       	call   c01029de <__intr_save>
c0102c24:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0102c27:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c0102c2c:	8b 40 14             	mov    0x14(%eax),%eax
c0102c2f:	ff d0                	call   *%eax
c0102c31:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0102c34:	83 ec 0c             	sub    $0xc,%esp
c0102c37:	ff 75 f4             	pushl  -0xc(%ebp)
c0102c3a:	e8 c9 fd ff ff       	call   c0102a08 <__intr_restore>
c0102c3f:	83 c4 10             	add    $0x10,%esp
    return ret;
c0102c42:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0102c45:	c9                   	leave  
c0102c46:	c3                   	ret    

c0102c47 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0102c47:	55                   	push   %ebp
c0102c48:	89 e5                	mov    %esp,%ebp
c0102c4a:	57                   	push   %edi
c0102c4b:	56                   	push   %esi
c0102c4c:	53                   	push   %ebx
c0102c4d:	83 ec 7c             	sub    $0x7c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0102c50:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0102c57:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0102c5e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0102c65:	83 ec 0c             	sub    $0xc,%esp
c0102c68:	68 07 62 10 c0       	push   $0xc0106207
c0102c6d:	e8 f5 d5 ff ff       	call   c0100267 <cprintf>
c0102c72:	83 c4 10             	add    $0x10,%esp
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0102c75:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102c7c:	e9 fc 00 00 00       	jmp    c0102d7d <page_init+0x136>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0102c81:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102c84:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102c87:	89 d0                	mov    %edx,%eax
c0102c89:	c1 e0 02             	shl    $0x2,%eax
c0102c8c:	01 d0                	add    %edx,%eax
c0102c8e:	c1 e0 02             	shl    $0x2,%eax
c0102c91:	01 c8                	add    %ecx,%eax
c0102c93:	8b 50 08             	mov    0x8(%eax),%edx
c0102c96:	8b 40 04             	mov    0x4(%eax),%eax
c0102c99:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0102c9c:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0102c9f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102ca2:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102ca5:	89 d0                	mov    %edx,%eax
c0102ca7:	c1 e0 02             	shl    $0x2,%eax
c0102caa:	01 d0                	add    %edx,%eax
c0102cac:	c1 e0 02             	shl    $0x2,%eax
c0102caf:	01 c8                	add    %ecx,%eax
c0102cb1:	8b 48 0c             	mov    0xc(%eax),%ecx
c0102cb4:	8b 58 10             	mov    0x10(%eax),%ebx
c0102cb7:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102cba:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102cbd:	01 c8                	add    %ecx,%eax
c0102cbf:	11 da                	adc    %ebx,%edx
c0102cc1:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0102cc4:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0102cc7:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102cca:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102ccd:	89 d0                	mov    %edx,%eax
c0102ccf:	c1 e0 02             	shl    $0x2,%eax
c0102cd2:	01 d0                	add    %edx,%eax
c0102cd4:	c1 e0 02             	shl    $0x2,%eax
c0102cd7:	01 c8                	add    %ecx,%eax
c0102cd9:	83 c0 14             	add    $0x14,%eax
c0102cdc:	8b 00                	mov    (%eax),%eax
c0102cde:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0102ce1:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0102ce4:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0102ce7:	83 c0 ff             	add    $0xffffffff,%eax
c0102cea:	83 d2 ff             	adc    $0xffffffff,%edx
c0102ced:	89 c1                	mov    %eax,%ecx
c0102cef:	89 d3                	mov    %edx,%ebx
c0102cf1:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102cf4:	89 55 80             	mov    %edx,-0x80(%ebp)
c0102cf7:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102cfa:	89 d0                	mov    %edx,%eax
c0102cfc:	c1 e0 02             	shl    $0x2,%eax
c0102cff:	01 d0                	add    %edx,%eax
c0102d01:	c1 e0 02             	shl    $0x2,%eax
c0102d04:	03 45 80             	add    -0x80(%ebp),%eax
c0102d07:	8b 50 10             	mov    0x10(%eax),%edx
c0102d0a:	8b 40 0c             	mov    0xc(%eax),%eax
c0102d0d:	ff 75 84             	pushl  -0x7c(%ebp)
c0102d10:	53                   	push   %ebx
c0102d11:	51                   	push   %ecx
c0102d12:	ff 75 bc             	pushl  -0x44(%ebp)
c0102d15:	ff 75 b8             	pushl  -0x48(%ebp)
c0102d18:	52                   	push   %edx
c0102d19:	50                   	push   %eax
c0102d1a:	68 14 62 10 c0       	push   $0xc0106214
c0102d1f:	e8 43 d5 ff ff       	call   c0100267 <cprintf>
c0102d24:	83 c4 20             	add    $0x20,%esp
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0102d27:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102d2a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102d2d:	89 d0                	mov    %edx,%eax
c0102d2f:	c1 e0 02             	shl    $0x2,%eax
c0102d32:	01 d0                	add    %edx,%eax
c0102d34:	c1 e0 02             	shl    $0x2,%eax
c0102d37:	01 c8                	add    %ecx,%eax
c0102d39:	83 c0 14             	add    $0x14,%eax
c0102d3c:	8b 00                	mov    (%eax),%eax
c0102d3e:	83 f8 01             	cmp    $0x1,%eax
c0102d41:	75 36                	jne    c0102d79 <page_init+0x132>
            if (maxpa < end && begin < KMEMSIZE) {
c0102d43:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102d46:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102d49:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0102d4c:	77 2b                	ja     c0102d79 <page_init+0x132>
c0102d4e:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0102d51:	72 05                	jb     c0102d58 <page_init+0x111>
c0102d53:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c0102d56:	73 21                	jae    c0102d79 <page_init+0x132>
c0102d58:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0102d5c:	77 1b                	ja     c0102d79 <page_init+0x132>
c0102d5e:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0102d62:	72 09                	jb     c0102d6d <page_init+0x126>
c0102d64:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c0102d6b:	77 0c                	ja     c0102d79 <page_init+0x132>
                maxpa = end;
c0102d6d:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0102d70:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0102d73:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0102d76:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0102d79:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0102d7d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102d80:	8b 00                	mov    (%eax),%eax
c0102d82:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0102d85:	0f 8f f6 fe ff ff    	jg     c0102c81 <page_init+0x3a>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0102d8b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0102d8f:	72 1d                	jb     c0102dae <page_init+0x167>
c0102d91:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0102d95:	77 09                	ja     c0102da0 <page_init+0x159>
c0102d97:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c0102d9e:	76 0e                	jbe    c0102dae <page_init+0x167>
        maxpa = KMEMSIZE;
c0102da0:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0102da7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0102dae:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102db1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102db4:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0102db8:	c1 ea 0c             	shr    $0xc,%edx
c0102dbb:	a3 c0 88 11 c0       	mov    %eax,0xc01188c0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0102dc0:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c0102dc7:	b8 68 89 11 c0       	mov    $0xc0118968,%eax
c0102dcc:	8d 50 ff             	lea    -0x1(%eax),%edx
c0102dcf:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0102dd2:	01 d0                	add    %edx,%eax
c0102dd4:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0102dd7:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0102dda:	ba 00 00 00 00       	mov    $0x0,%edx
c0102ddf:	f7 75 ac             	divl   -0x54(%ebp)
c0102de2:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0102de5:	29 d0                	sub    %edx,%eax
c0102de7:	a3 58 89 11 c0       	mov    %eax,0xc0118958

    for (i = 0; i < npage; i ++) {
c0102dec:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102df3:	eb 2f                	jmp    c0102e24 <page_init+0x1dd>
        SetPageReserved(pages + i);
c0102df5:	8b 0d 58 89 11 c0    	mov    0xc0118958,%ecx
c0102dfb:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102dfe:	89 d0                	mov    %edx,%eax
c0102e00:	c1 e0 02             	shl    $0x2,%eax
c0102e03:	01 d0                	add    %edx,%eax
c0102e05:	c1 e0 02             	shl    $0x2,%eax
c0102e08:	01 c8                	add    %ecx,%eax
c0102e0a:	83 c0 04             	add    $0x4,%eax
c0102e0d:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c0102e14:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102e17:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0102e1a:	8b 55 90             	mov    -0x70(%ebp),%edx
c0102e1d:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
c0102e20:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0102e24:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102e27:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0102e2c:	39 c2                	cmp    %eax,%edx
c0102e2e:	72 c5                	jb     c0102df5 <page_init+0x1ae>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0102e30:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0102e36:	89 d0                	mov    %edx,%eax
c0102e38:	c1 e0 02             	shl    $0x2,%eax
c0102e3b:	01 d0                	add    %edx,%eax
c0102e3d:	c1 e0 02             	shl    $0x2,%eax
c0102e40:	89 c2                	mov    %eax,%edx
c0102e42:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0102e47:	01 d0                	add    %edx,%eax
c0102e49:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c0102e4c:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c0102e53:	77 17                	ja     c0102e6c <page_init+0x225>
c0102e55:	ff 75 a4             	pushl  -0x5c(%ebp)
c0102e58:	68 44 62 10 c0       	push   $0xc0106244
c0102e5d:	68 db 00 00 00       	push   $0xdb
c0102e62:	68 68 62 10 c0       	push   $0xc0106268
c0102e67:	e8 61 d5 ff ff       	call   c01003cd <__panic>
c0102e6c:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0102e6f:	05 00 00 00 40       	add    $0x40000000,%eax
c0102e74:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0102e77:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102e7e:	e9 69 01 00 00       	jmp    c0102fec <page_init+0x3a5>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0102e83:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102e86:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102e89:	89 d0                	mov    %edx,%eax
c0102e8b:	c1 e0 02             	shl    $0x2,%eax
c0102e8e:	01 d0                	add    %edx,%eax
c0102e90:	c1 e0 02             	shl    $0x2,%eax
c0102e93:	01 c8                	add    %ecx,%eax
c0102e95:	8b 50 08             	mov    0x8(%eax),%edx
c0102e98:	8b 40 04             	mov    0x4(%eax),%eax
c0102e9b:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102e9e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0102ea1:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102ea4:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102ea7:	89 d0                	mov    %edx,%eax
c0102ea9:	c1 e0 02             	shl    $0x2,%eax
c0102eac:	01 d0                	add    %edx,%eax
c0102eae:	c1 e0 02             	shl    $0x2,%eax
c0102eb1:	01 c8                	add    %ecx,%eax
c0102eb3:	8b 48 0c             	mov    0xc(%eax),%ecx
c0102eb6:	8b 58 10             	mov    0x10(%eax),%ebx
c0102eb9:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102ebc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102ebf:	01 c8                	add    %ecx,%eax
c0102ec1:	11 da                	adc    %ebx,%edx
c0102ec3:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0102ec6:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c0102ec9:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102ecc:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102ecf:	89 d0                	mov    %edx,%eax
c0102ed1:	c1 e0 02             	shl    $0x2,%eax
c0102ed4:	01 d0                	add    %edx,%eax
c0102ed6:	c1 e0 02             	shl    $0x2,%eax
c0102ed9:	01 c8                	add    %ecx,%eax
c0102edb:	83 c0 14             	add    $0x14,%eax
c0102ede:	8b 00                	mov    (%eax),%eax
c0102ee0:	83 f8 01             	cmp    $0x1,%eax
c0102ee3:	0f 85 ff 00 00 00    	jne    c0102fe8 <page_init+0x3a1>
            if (begin < freemem) {
c0102ee9:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0102eec:	ba 00 00 00 00       	mov    $0x0,%edx
c0102ef1:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0102ef4:	72 17                	jb     c0102f0d <page_init+0x2c6>
c0102ef6:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0102ef9:	77 05                	ja     c0102f00 <page_init+0x2b9>
c0102efb:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0102efe:	76 0d                	jbe    c0102f0d <page_init+0x2c6>
                begin = freemem;
c0102f00:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0102f03:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102f06:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c0102f0d:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0102f11:	72 1d                	jb     c0102f30 <page_init+0x2e9>
c0102f13:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0102f17:	77 09                	ja     c0102f22 <page_init+0x2db>
c0102f19:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c0102f20:	76 0e                	jbe    c0102f30 <page_init+0x2e9>
                end = KMEMSIZE;
c0102f22:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c0102f29:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c0102f30:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102f33:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102f36:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0102f39:	0f 87 a9 00 00 00    	ja     c0102fe8 <page_init+0x3a1>
c0102f3f:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0102f42:	72 09                	jb     c0102f4d <page_init+0x306>
c0102f44:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0102f47:	0f 83 9b 00 00 00    	jae    c0102fe8 <page_init+0x3a1>
                begin = ROUNDUP(begin, PGSIZE);
c0102f4d:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c0102f54:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102f57:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0102f5a:	01 d0                	add    %edx,%eax
c0102f5c:	83 e8 01             	sub    $0x1,%eax
c0102f5f:	89 45 98             	mov    %eax,-0x68(%ebp)
c0102f62:	8b 45 98             	mov    -0x68(%ebp),%eax
c0102f65:	ba 00 00 00 00       	mov    $0x0,%edx
c0102f6a:	f7 75 9c             	divl   -0x64(%ebp)
c0102f6d:	8b 45 98             	mov    -0x68(%ebp),%eax
c0102f70:	29 d0                	sub    %edx,%eax
c0102f72:	ba 00 00 00 00       	mov    $0x0,%edx
c0102f77:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102f7a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c0102f7d:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102f80:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0102f83:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0102f86:	ba 00 00 00 00       	mov    $0x0,%edx
c0102f8b:	89 c3                	mov    %eax,%ebx
c0102f8d:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
c0102f93:	89 de                	mov    %ebx,%esi
c0102f95:	89 d0                	mov    %edx,%eax
c0102f97:	83 e0 00             	and    $0x0,%eax
c0102f9a:	89 c7                	mov    %eax,%edi
c0102f9c:	89 75 c8             	mov    %esi,-0x38(%ebp)
c0102f9f:	89 7d cc             	mov    %edi,-0x34(%ebp)
                if (begin < end) {
c0102fa2:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102fa5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102fa8:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0102fab:	77 3b                	ja     c0102fe8 <page_init+0x3a1>
c0102fad:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0102fb0:	72 05                	jb     c0102fb7 <page_init+0x370>
c0102fb2:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0102fb5:	73 31                	jae    c0102fe8 <page_init+0x3a1>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c0102fb7:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102fba:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102fbd:	2b 45 d0             	sub    -0x30(%ebp),%eax
c0102fc0:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
c0102fc3:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0102fc7:	c1 ea 0c             	shr    $0xc,%edx
c0102fca:	89 c3                	mov    %eax,%ebx
c0102fcc:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102fcf:	83 ec 0c             	sub    $0xc,%esp
c0102fd2:	50                   	push   %eax
c0102fd3:	e8 de f8 ff ff       	call   c01028b6 <pa2page>
c0102fd8:	83 c4 10             	add    $0x10,%esp
c0102fdb:	83 ec 08             	sub    $0x8,%esp
c0102fde:	53                   	push   %ebx
c0102fdf:	50                   	push   %eax
c0102fe0:	e8 a2 fb ff ff       	call   c0102b87 <init_memmap>
c0102fe5:	83 c4 10             	add    $0x10,%esp
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
c0102fe8:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0102fec:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102fef:	8b 00                	mov    (%eax),%eax
c0102ff1:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0102ff4:	0f 8f 89 fe ff ff    	jg     c0102e83 <page_init+0x23c>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c0102ffa:	90                   	nop
c0102ffb:	8d 65 f4             	lea    -0xc(%ebp),%esp
c0102ffe:	5b                   	pop    %ebx
c0102fff:	5e                   	pop    %esi
c0103000:	5f                   	pop    %edi
c0103001:	5d                   	pop    %ebp
c0103002:	c3                   	ret    

c0103003 <enable_paging>:

static void
enable_paging(void) {
c0103003:	55                   	push   %ebp
c0103004:	89 e5                	mov    %esp,%ebp
c0103006:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
c0103009:	a1 54 89 11 c0       	mov    0xc0118954,%eax
c010300e:	89 45 fc             	mov    %eax,-0x4(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c0103011:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103014:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
c0103017:	0f 20 c0             	mov    %cr0,%eax
c010301a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
c010301d:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
c0103020:	89 45 f8             	mov    %eax,-0x8(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
c0103023:	81 4d f8 2f 00 05 80 	orl    $0x8005002f,-0x8(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
c010302a:	83 65 f8 f3          	andl   $0xfffffff3,-0x8(%ebp)
c010302e:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103031:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
c0103034:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103037:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
c010303a:	90                   	nop
c010303b:	c9                   	leave  
c010303c:	c3                   	ret    

c010303d <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c010303d:	55                   	push   %ebp
c010303e:	89 e5                	mov    %esp,%ebp
c0103040:	83 ec 28             	sub    $0x28,%esp
    assert(PGOFF(la) == PGOFF(pa));
c0103043:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103046:	33 45 14             	xor    0x14(%ebp),%eax
c0103049:	25 ff 0f 00 00       	and    $0xfff,%eax
c010304e:	85 c0                	test   %eax,%eax
c0103050:	74 19                	je     c010306b <boot_map_segment+0x2e>
c0103052:	68 76 62 10 c0       	push   $0xc0106276
c0103057:	68 8d 62 10 c0       	push   $0xc010628d
c010305c:	68 04 01 00 00       	push   $0x104
c0103061:	68 68 62 10 c0       	push   $0xc0106268
c0103066:	e8 62 d3 ff ff       	call   c01003cd <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c010306b:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c0103072:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103075:	25 ff 0f 00 00       	and    $0xfff,%eax
c010307a:	89 c2                	mov    %eax,%edx
c010307c:	8b 45 10             	mov    0x10(%ebp),%eax
c010307f:	01 c2                	add    %eax,%edx
c0103081:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103084:	01 d0                	add    %edx,%eax
c0103086:	83 e8 01             	sub    $0x1,%eax
c0103089:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010308c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010308f:	ba 00 00 00 00       	mov    $0x0,%edx
c0103094:	f7 75 f0             	divl   -0x10(%ebp)
c0103097:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010309a:	29 d0                	sub    %edx,%eax
c010309c:	c1 e8 0c             	shr    $0xc,%eax
c010309f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c01030a2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01030a5:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01030a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01030ab:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01030b0:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c01030b3:	8b 45 14             	mov    0x14(%ebp),%eax
c01030b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01030b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01030bc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01030c1:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01030c4:	eb 57                	jmp    c010311d <boot_map_segment+0xe0>
        pte_t *ptep = get_pte(pgdir, la, 1);
c01030c6:	83 ec 04             	sub    $0x4,%esp
c01030c9:	6a 01                	push   $0x1
c01030cb:	ff 75 0c             	pushl  0xc(%ebp)
c01030ce:	ff 75 08             	pushl  0x8(%ebp)
c01030d1:	e8 98 01 00 00       	call   c010326e <get_pte>
c01030d6:	83 c4 10             	add    $0x10,%esp
c01030d9:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c01030dc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01030e0:	75 19                	jne    c01030fb <boot_map_segment+0xbe>
c01030e2:	68 a2 62 10 c0       	push   $0xc01062a2
c01030e7:	68 8d 62 10 c0       	push   $0xc010628d
c01030ec:	68 0a 01 00 00       	push   $0x10a
c01030f1:	68 68 62 10 c0       	push   $0xc0106268
c01030f6:	e8 d2 d2 ff ff       	call   c01003cd <__panic>
        *ptep = pa | PTE_P | perm;
c01030fb:	8b 45 14             	mov    0x14(%ebp),%eax
c01030fe:	0b 45 18             	or     0x18(%ebp),%eax
c0103101:	83 c8 01             	or     $0x1,%eax
c0103104:	89 c2                	mov    %eax,%edx
c0103106:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103109:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c010310b:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c010310f:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c0103116:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c010311d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103121:	75 a3                	jne    c01030c6 <boot_map_segment+0x89>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c0103123:	90                   	nop
c0103124:	c9                   	leave  
c0103125:	c3                   	ret    

c0103126 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c0103126:	55                   	push   %ebp
c0103127:	89 e5                	mov    %esp,%ebp
c0103129:	83 ec 18             	sub    $0x18,%esp
    struct Page *p = alloc_page();
c010312c:	83 ec 0c             	sub    $0xc,%esp
c010312f:	6a 01                	push   $0x1
c0103131:	e8 70 fa ff ff       	call   c0102ba6 <alloc_pages>
c0103136:	83 c4 10             	add    $0x10,%esp
c0103139:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c010313c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103140:	75 17                	jne    c0103159 <boot_alloc_page+0x33>
        panic("boot_alloc_page failed.\n");
c0103142:	83 ec 04             	sub    $0x4,%esp
c0103145:	68 af 62 10 c0       	push   $0xc01062af
c010314a:	68 16 01 00 00       	push   $0x116
c010314f:	68 68 62 10 c0       	push   $0xc0106268
c0103154:	e8 74 d2 ff ff       	call   c01003cd <__panic>
    }
    return page2kva(p);
c0103159:	83 ec 0c             	sub    $0xc,%esp
c010315c:	ff 75 f4             	pushl  -0xc(%ebp)
c010315f:	e8 99 f7 ff ff       	call   c01028fd <page2kva>
c0103164:	83 c4 10             	add    $0x10,%esp
}
c0103167:	c9                   	leave  
c0103168:	c3                   	ret    

c0103169 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c0103169:	55                   	push   %ebp
c010316a:	89 e5                	mov    %esp,%ebp
c010316c:	83 ec 18             	sub    $0x18,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c010316f:	e8 de f9 ff ff       	call   c0102b52 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c0103174:	e8 ce fa ff ff       	call   c0102c47 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c0103179:	e8 0a 04 00 00       	call   c0103588 <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
c010317e:	e8 a3 ff ff ff       	call   c0103126 <boot_alloc_page>
c0103183:	a3 c4 88 11 c0       	mov    %eax,0xc01188c4
    memset(boot_pgdir, 0, PGSIZE);
c0103188:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010318d:	83 ec 04             	sub    $0x4,%esp
c0103190:	68 00 10 00 00       	push   $0x1000
c0103195:	6a 00                	push   $0x0
c0103197:	50                   	push   %eax
c0103198:	e8 1b 21 00 00       	call   c01052b8 <memset>
c010319d:	83 c4 10             	add    $0x10,%esp
    boot_cr3 = PADDR(boot_pgdir);
c01031a0:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01031a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01031a8:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01031af:	77 17                	ja     c01031c8 <pmm_init+0x5f>
c01031b1:	ff 75 f4             	pushl  -0xc(%ebp)
c01031b4:	68 44 62 10 c0       	push   $0xc0106244
c01031b9:	68 30 01 00 00       	push   $0x130
c01031be:	68 68 62 10 c0       	push   $0xc0106268
c01031c3:	e8 05 d2 ff ff       	call   c01003cd <__panic>
c01031c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01031cb:	05 00 00 00 40       	add    $0x40000000,%eax
c01031d0:	a3 54 89 11 c0       	mov    %eax,0xc0118954

    check_pgdir();
c01031d5:	e8 d1 03 00 00       	call   c01035ab <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c01031da:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01031df:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c01031e5:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01031ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01031ed:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c01031f4:	77 17                	ja     c010320d <pmm_init+0xa4>
c01031f6:	ff 75 f0             	pushl  -0x10(%ebp)
c01031f9:	68 44 62 10 c0       	push   $0xc0106244
c01031fe:	68 38 01 00 00       	push   $0x138
c0103203:	68 68 62 10 c0       	push   $0xc0106268
c0103208:	e8 c0 d1 ff ff       	call   c01003cd <__panic>
c010320d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103210:	05 00 00 00 40       	add    $0x40000000,%eax
c0103215:	83 c8 03             	or     $0x3,%eax
c0103218:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c010321a:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010321f:	83 ec 0c             	sub    $0xc,%esp
c0103222:	6a 02                	push   $0x2
c0103224:	6a 00                	push   $0x0
c0103226:	68 00 00 00 38       	push   $0x38000000
c010322b:	68 00 00 00 c0       	push   $0xc0000000
c0103230:	50                   	push   %eax
c0103231:	e8 07 fe ff ff       	call   c010303d <boot_map_segment>
c0103236:	83 c4 20             	add    $0x20,%esp

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
c0103239:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010323e:	8b 15 c4 88 11 c0    	mov    0xc01188c4,%edx
c0103244:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
c010324a:	89 10                	mov    %edx,(%eax)

    enable_paging();
c010324c:	e8 b2 fd ff ff       	call   c0103003 <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c0103251:	e8 0a f8 ff ff       	call   c0102a60 <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
c0103256:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010325b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c0103261:	e8 ab 08 00 00       	call   c0103b11 <check_boot_pgdir>

    print_pgdir();
c0103266:	e8 a1 0c 00 00       	call   c0103f0c <print_pgdir>

}
c010326b:	90                   	nop
c010326c:	c9                   	leave  
c010326d:	c3                   	ret    

c010326e <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c010326e:	55                   	push   %ebp
c010326f:	89 e5                	mov    %esp,%ebp
c0103271:	83 ec 28             	sub    $0x28,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    pde_t *pdep = &pgdir[PDX(la)];              //由PDX(la)找到pdt的index，从而得知该线性地址的二级页表的起始地址pde
c0103274:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103277:	c1 e8 16             	shr    $0x16,%eax
c010327a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0103281:	8b 45 08             	mov    0x8(%ebp),%eax
c0103284:	01 d0                	add    %edx,%eax
c0103286:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(!(*pdep & PTE_P))                        //驻留位，若该页不在内存中，则创建页 
c0103289:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010328c:	8b 00                	mov    (%eax),%eax
c010328e:	83 e0 01             	and    $0x1,%eax
c0103291:	85 c0                	test   %eax,%eax
c0103293:	0f 85 9f 00 00 00    	jne    c0103338 <get_pte+0xca>
    {
            struct Page *p;                     //创建页表p
            if(!create || (p = alloc_page()) == NULL)
c0103299:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010329d:	74 16                	je     c01032b5 <get_pte+0x47>
c010329f:	83 ec 0c             	sub    $0xc,%esp
c01032a2:	6a 01                	push   $0x1
c01032a4:	e8 fd f8 ff ff       	call   c0102ba6 <alloc_pages>
c01032a9:	83 c4 10             	add    $0x10,%esp
c01032ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01032af:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01032b3:	75 0a                	jne    c01032bf <get_pte+0x51>
                    return NULL;
c01032b5:	b8 00 00 00 00       	mov    $0x0,%eax
c01032ba:	e9 ca 00 00 00       	jmp    c0103389 <get_pte+0x11b>
            set_page_ref(p, 1);              //设置该页被引用过一次
c01032bf:	83 ec 08             	sub    $0x8,%esp
c01032c2:	6a 01                	push   $0x1
c01032c4:	ff 75 f0             	pushl  -0x10(%ebp)
c01032c7:	e8 d6 f6 ff ff       	call   c01029a2 <set_page_ref>
c01032cc:	83 c4 10             	add    $0x10,%esp
            uintptr_t pa = page2pa(p);          //获得页表p的物理地址
c01032cf:	83 ec 0c             	sub    $0xc,%esp
c01032d2:	ff 75 f0             	pushl  -0x10(%ebp)
c01032d5:	e8 c9 f5 ff ff       	call   c01028a3 <page2pa>
c01032da:	83 c4 10             	add    $0x10,%esp
c01032dd:	89 45 ec             	mov    %eax,-0x14(%ebp)
            memset(KADDR(pa), 0, PGSIZE);       //清空页表
c01032e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01032e3:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01032e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01032e9:	c1 e8 0c             	shr    $0xc,%eax
c01032ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01032ef:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c01032f4:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c01032f7:	72 17                	jb     c0103310 <get_pte+0xa2>
c01032f9:	ff 75 e8             	pushl  -0x18(%ebp)
c01032fc:	68 a0 61 10 c0       	push   $0xc01061a0
c0103301:	68 87 01 00 00       	push   $0x187
c0103306:	68 68 62 10 c0       	push   $0xc0106268
c010330b:	e8 bd d0 ff ff       	call   c01003cd <__panic>
c0103310:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103313:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0103318:	83 ec 04             	sub    $0x4,%esp
c010331b:	68 00 10 00 00       	push   $0x1000
c0103320:	6a 00                	push   $0x0
c0103322:	50                   	push   %eax
c0103323:	e8 90 1f 00 00       	call   c01052b8 <memset>
c0103328:	83 c4 10             	add    $0x10,%esp
            *pdep = pa | PTE_U | PTE_W | PTE_P;
c010332b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010332e:	83 c8 07             	or     $0x7,%eax
c0103331:	89 c2                	mov    %eax,%edx
c0103333:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103336:	89 10                	mov    %edx,(%eax)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];  //由PTX(la)找到页表的index,结合pde，得到页帧起始地址pte
c0103338:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010333b:	8b 00                	mov    (%eax),%eax
c010333d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103342:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103345:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103348:	c1 e8 0c             	shr    $0xc,%eax
c010334b:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010334e:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0103353:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0103356:	72 17                	jb     c010336f <get_pte+0x101>
c0103358:	ff 75 e0             	pushl  -0x20(%ebp)
c010335b:	68 a0 61 10 c0       	push   $0xc01061a0
c0103360:	68 8a 01 00 00       	push   $0x18a
c0103365:	68 68 62 10 c0       	push   $0xc0106268
c010336a:	e8 5e d0 ff ff       	call   c01003cd <__panic>
c010336f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103372:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0103377:	89 c2                	mov    %eax,%edx
c0103379:	8b 45 0c             	mov    0xc(%ebp),%eax
c010337c:	c1 e8 0c             	shr    $0xc,%eax
c010337f:	25 ff 03 00 00       	and    $0x3ff,%eax
c0103384:	c1 e0 02             	shl    $0x2,%eax
c0103387:	01 d0                	add    %edx,%eax
}
c0103389:	c9                   	leave  
c010338a:	c3                   	ret    

c010338b <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c010338b:	55                   	push   %ebp
c010338c:	89 e5                	mov    %esp,%ebp
c010338e:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0103391:	83 ec 04             	sub    $0x4,%esp
c0103394:	6a 00                	push   $0x0
c0103396:	ff 75 0c             	pushl  0xc(%ebp)
c0103399:	ff 75 08             	pushl  0x8(%ebp)
c010339c:	e8 cd fe ff ff       	call   c010326e <get_pte>
c01033a1:	83 c4 10             	add    $0x10,%esp
c01033a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c01033a7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01033ab:	74 08                	je     c01033b5 <get_page+0x2a>
        *ptep_store = ptep;
c01033ad:	8b 45 10             	mov    0x10(%ebp),%eax
c01033b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01033b3:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c01033b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01033b9:	74 1f                	je     c01033da <get_page+0x4f>
c01033bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01033be:	8b 00                	mov    (%eax),%eax
c01033c0:	83 e0 01             	and    $0x1,%eax
c01033c3:	85 c0                	test   %eax,%eax
c01033c5:	74 13                	je     c01033da <get_page+0x4f>
        return pte2page(*ptep);
c01033c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01033ca:	8b 00                	mov    (%eax),%eax
c01033cc:	83 ec 0c             	sub    $0xc,%esp
c01033cf:	50                   	push   %eax
c01033d0:	e8 6d f5 ff ff       	call   c0102942 <pte2page>
c01033d5:	83 c4 10             	add    $0x10,%esp
c01033d8:	eb 05                	jmp    c01033df <get_page+0x54>
    }
    return NULL;
c01033da:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01033df:	c9                   	leave  
c01033e0:	c3                   	ret    

c01033e1 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c01033e1:	55                   	push   %ebp
c01033e2:	89 e5                	mov    %esp,%ebp
c01033e4:	83 ec 18             	sub    $0x18,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    if(*ptep & PTE_P)
c01033e7:	8b 45 10             	mov    0x10(%ebp),%eax
c01033ea:	8b 00                	mov    (%eax),%eax
c01033ec:	83 e0 01             	and    $0x1,%eax
c01033ef:	85 c0                	test   %eax,%eax
c01033f1:	74 50                	je     c0103443 <page_remove_pte+0x62>
    {
            struct Page *p = pte2page(*ptep);       //找到放该ptep的页表p
c01033f3:	8b 45 10             	mov    0x10(%ebp),%eax
c01033f6:	8b 00                	mov    (%eax),%eax
c01033f8:	83 ec 0c             	sub    $0xc,%esp
c01033fb:	50                   	push   %eax
c01033fc:	e8 41 f5 ff ff       	call   c0102942 <pte2page>
c0103401:	83 c4 10             	add    $0x10,%esp
c0103404:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if(page_ref_dec(p) == 0)
c0103407:	83 ec 0c             	sub    $0xc,%esp
c010340a:	ff 75 f4             	pushl  -0xc(%ebp)
c010340d:	e8 b5 f5 ff ff       	call   c01029c7 <page_ref_dec>
c0103412:	83 c4 10             	add    $0x10,%esp
c0103415:	85 c0                	test   %eax,%eax
c0103417:	75 10                	jne    c0103429 <page_remove_pte+0x48>
                    free_page(p);
c0103419:	83 ec 08             	sub    $0x8,%esp
c010341c:	6a 01                	push   $0x1
c010341e:	ff 75 f4             	pushl  -0xc(%ebp)
c0103421:	e8 be f7 ff ff       	call   c0102be4 <free_pages>
c0103426:	83 c4 10             	add    $0x10,%esp
            *ptep = 0;                              //清空pte
c0103429:	8b 45 10             	mov    0x10(%ebp),%eax
c010342c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            tlb_invalidate(pgdir, la);
c0103432:	83 ec 08             	sub    $0x8,%esp
c0103435:	ff 75 0c             	pushl  0xc(%ebp)
c0103438:	ff 75 08             	pushl  0x8(%ebp)
c010343b:	e8 f8 00 00 00       	call   c0103538 <tlb_invalidate>
c0103440:	83 c4 10             	add    $0x10,%esp
    }
}
c0103443:	90                   	nop
c0103444:	c9                   	leave  
c0103445:	c3                   	ret    

c0103446 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c0103446:	55                   	push   %ebp
c0103447:	89 e5                	mov    %esp,%ebp
c0103449:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c010344c:	83 ec 04             	sub    $0x4,%esp
c010344f:	6a 00                	push   $0x0
c0103451:	ff 75 0c             	pushl  0xc(%ebp)
c0103454:	ff 75 08             	pushl  0x8(%ebp)
c0103457:	e8 12 fe ff ff       	call   c010326e <get_pte>
c010345c:	83 c4 10             	add    $0x10,%esp
c010345f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c0103462:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103466:	74 14                	je     c010347c <page_remove+0x36>
        page_remove_pte(pgdir, la, ptep);
c0103468:	83 ec 04             	sub    $0x4,%esp
c010346b:	ff 75 f4             	pushl  -0xc(%ebp)
c010346e:	ff 75 0c             	pushl  0xc(%ebp)
c0103471:	ff 75 08             	pushl  0x8(%ebp)
c0103474:	e8 68 ff ff ff       	call   c01033e1 <page_remove_pte>
c0103479:	83 c4 10             	add    $0x10,%esp
    }
}
c010347c:	90                   	nop
c010347d:	c9                   	leave  
c010347e:	c3                   	ret    

c010347f <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c010347f:	55                   	push   %ebp
c0103480:	89 e5                	mov    %esp,%ebp
c0103482:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c0103485:	83 ec 04             	sub    $0x4,%esp
c0103488:	6a 01                	push   $0x1
c010348a:	ff 75 10             	pushl  0x10(%ebp)
c010348d:	ff 75 08             	pushl  0x8(%ebp)
c0103490:	e8 d9 fd ff ff       	call   c010326e <get_pte>
c0103495:	83 c4 10             	add    $0x10,%esp
c0103498:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c010349b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010349f:	75 0a                	jne    c01034ab <page_insert+0x2c>
        return -E_NO_MEM;
c01034a1:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c01034a6:	e9 8b 00 00 00       	jmp    c0103536 <page_insert+0xb7>
    }
    page_ref_inc(page);
c01034ab:	83 ec 0c             	sub    $0xc,%esp
c01034ae:	ff 75 0c             	pushl  0xc(%ebp)
c01034b1:	e8 fa f4 ff ff       	call   c01029b0 <page_ref_inc>
c01034b6:	83 c4 10             	add    $0x10,%esp
    if (*ptep & PTE_P) {
c01034b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034bc:	8b 00                	mov    (%eax),%eax
c01034be:	83 e0 01             	and    $0x1,%eax
c01034c1:	85 c0                	test   %eax,%eax
c01034c3:	74 40                	je     c0103505 <page_insert+0x86>
        struct Page *p = pte2page(*ptep);
c01034c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034c8:	8b 00                	mov    (%eax),%eax
c01034ca:	83 ec 0c             	sub    $0xc,%esp
c01034cd:	50                   	push   %eax
c01034ce:	e8 6f f4 ff ff       	call   c0102942 <pte2page>
c01034d3:	83 c4 10             	add    $0x10,%esp
c01034d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c01034d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01034dc:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01034df:	75 10                	jne    c01034f1 <page_insert+0x72>
            page_ref_dec(page);
c01034e1:	83 ec 0c             	sub    $0xc,%esp
c01034e4:	ff 75 0c             	pushl  0xc(%ebp)
c01034e7:	e8 db f4 ff ff       	call   c01029c7 <page_ref_dec>
c01034ec:	83 c4 10             	add    $0x10,%esp
c01034ef:	eb 14                	jmp    c0103505 <page_insert+0x86>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c01034f1:	83 ec 04             	sub    $0x4,%esp
c01034f4:	ff 75 f4             	pushl  -0xc(%ebp)
c01034f7:	ff 75 10             	pushl  0x10(%ebp)
c01034fa:	ff 75 08             	pushl  0x8(%ebp)
c01034fd:	e8 df fe ff ff       	call   c01033e1 <page_remove_pte>
c0103502:	83 c4 10             	add    $0x10,%esp
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c0103505:	83 ec 0c             	sub    $0xc,%esp
c0103508:	ff 75 0c             	pushl  0xc(%ebp)
c010350b:	e8 93 f3 ff ff       	call   c01028a3 <page2pa>
c0103510:	83 c4 10             	add    $0x10,%esp
c0103513:	0b 45 14             	or     0x14(%ebp),%eax
c0103516:	83 c8 01             	or     $0x1,%eax
c0103519:	89 c2                	mov    %eax,%edx
c010351b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010351e:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c0103520:	83 ec 08             	sub    $0x8,%esp
c0103523:	ff 75 10             	pushl  0x10(%ebp)
c0103526:	ff 75 08             	pushl  0x8(%ebp)
c0103529:	e8 0a 00 00 00       	call   c0103538 <tlb_invalidate>
c010352e:	83 c4 10             	add    $0x10,%esp
    return 0;
c0103531:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103536:	c9                   	leave  
c0103537:	c3                   	ret    

c0103538 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c0103538:	55                   	push   %ebp
c0103539:	89 e5                	mov    %esp,%ebp
c010353b:	83 ec 18             	sub    $0x18,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c010353e:	0f 20 d8             	mov    %cr3,%eax
c0103541:	89 45 ec             	mov    %eax,-0x14(%ebp)
    return cr3;
c0103544:	8b 55 ec             	mov    -0x14(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
c0103547:	8b 45 08             	mov    0x8(%ebp),%eax
c010354a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010354d:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0103554:	77 17                	ja     c010356d <tlb_invalidate+0x35>
c0103556:	ff 75 f0             	pushl  -0x10(%ebp)
c0103559:	68 44 62 10 c0       	push   $0xc0106244
c010355e:	68 ec 01 00 00       	push   $0x1ec
c0103563:	68 68 62 10 c0       	push   $0xc0106268
c0103568:	e8 60 ce ff ff       	call   c01003cd <__panic>
c010356d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103570:	05 00 00 00 40       	add    $0x40000000,%eax
c0103575:	39 c2                	cmp    %eax,%edx
c0103577:	75 0c                	jne    c0103585 <tlb_invalidate+0x4d>
        invlpg((void *)la);
c0103579:	8b 45 0c             	mov    0xc(%ebp),%eax
c010357c:	89 45 f4             	mov    %eax,-0xc(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c010357f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103582:	0f 01 38             	invlpg (%eax)
    }
}
c0103585:	90                   	nop
c0103586:	c9                   	leave  
c0103587:	c3                   	ret    

c0103588 <check_alloc_page>:

static void
check_alloc_page(void) {
c0103588:	55                   	push   %ebp
c0103589:	89 e5                	mov    %esp,%ebp
c010358b:	83 ec 08             	sub    $0x8,%esp
    pmm_manager->check();
c010358e:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c0103593:	8b 40 18             	mov    0x18(%eax),%eax
c0103596:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c0103598:	83 ec 0c             	sub    $0xc,%esp
c010359b:	68 c8 62 10 c0       	push   $0xc01062c8
c01035a0:	e8 c2 cc ff ff       	call   c0100267 <cprintf>
c01035a5:	83 c4 10             	add    $0x10,%esp
}
c01035a8:	90                   	nop
c01035a9:	c9                   	leave  
c01035aa:	c3                   	ret    

c01035ab <check_pgdir>:

static void
check_pgdir(void) {
c01035ab:	55                   	push   %ebp
c01035ac:	89 e5                	mov    %esp,%ebp
c01035ae:	83 ec 28             	sub    $0x28,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c01035b1:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c01035b6:	3d 00 80 03 00       	cmp    $0x38000,%eax
c01035bb:	76 19                	jbe    c01035d6 <check_pgdir+0x2b>
c01035bd:	68 e7 62 10 c0       	push   $0xc01062e7
c01035c2:	68 8d 62 10 c0       	push   $0xc010628d
c01035c7:	68 f9 01 00 00       	push   $0x1f9
c01035cc:	68 68 62 10 c0       	push   $0xc0106268
c01035d1:	e8 f7 cd ff ff       	call   c01003cd <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c01035d6:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01035db:	85 c0                	test   %eax,%eax
c01035dd:	74 0e                	je     c01035ed <check_pgdir+0x42>
c01035df:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01035e4:	25 ff 0f 00 00       	and    $0xfff,%eax
c01035e9:	85 c0                	test   %eax,%eax
c01035eb:	74 19                	je     c0103606 <check_pgdir+0x5b>
c01035ed:	68 04 63 10 c0       	push   $0xc0106304
c01035f2:	68 8d 62 10 c0       	push   $0xc010628d
c01035f7:	68 fa 01 00 00       	push   $0x1fa
c01035fc:	68 68 62 10 c0       	push   $0xc0106268
c0103601:	e8 c7 cd ff ff       	call   c01003cd <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c0103606:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010360b:	83 ec 04             	sub    $0x4,%esp
c010360e:	6a 00                	push   $0x0
c0103610:	6a 00                	push   $0x0
c0103612:	50                   	push   %eax
c0103613:	e8 73 fd ff ff       	call   c010338b <get_page>
c0103618:	83 c4 10             	add    $0x10,%esp
c010361b:	85 c0                	test   %eax,%eax
c010361d:	74 19                	je     c0103638 <check_pgdir+0x8d>
c010361f:	68 3c 63 10 c0       	push   $0xc010633c
c0103624:	68 8d 62 10 c0       	push   $0xc010628d
c0103629:	68 fb 01 00 00       	push   $0x1fb
c010362e:	68 68 62 10 c0       	push   $0xc0106268
c0103633:	e8 95 cd ff ff       	call   c01003cd <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c0103638:	83 ec 0c             	sub    $0xc,%esp
c010363b:	6a 01                	push   $0x1
c010363d:	e8 64 f5 ff ff       	call   c0102ba6 <alloc_pages>
c0103642:	83 c4 10             	add    $0x10,%esp
c0103645:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c0103648:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010364d:	6a 00                	push   $0x0
c010364f:	6a 00                	push   $0x0
c0103651:	ff 75 f4             	pushl  -0xc(%ebp)
c0103654:	50                   	push   %eax
c0103655:	e8 25 fe ff ff       	call   c010347f <page_insert>
c010365a:	83 c4 10             	add    $0x10,%esp
c010365d:	85 c0                	test   %eax,%eax
c010365f:	74 19                	je     c010367a <check_pgdir+0xcf>
c0103661:	68 64 63 10 c0       	push   $0xc0106364
c0103666:	68 8d 62 10 c0       	push   $0xc010628d
c010366b:	68 ff 01 00 00       	push   $0x1ff
c0103670:	68 68 62 10 c0       	push   $0xc0106268
c0103675:	e8 53 cd ff ff       	call   c01003cd <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c010367a:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010367f:	83 ec 04             	sub    $0x4,%esp
c0103682:	6a 00                	push   $0x0
c0103684:	6a 00                	push   $0x0
c0103686:	50                   	push   %eax
c0103687:	e8 e2 fb ff ff       	call   c010326e <get_pte>
c010368c:	83 c4 10             	add    $0x10,%esp
c010368f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103692:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103696:	75 19                	jne    c01036b1 <check_pgdir+0x106>
c0103698:	68 90 63 10 c0       	push   $0xc0106390
c010369d:	68 8d 62 10 c0       	push   $0xc010628d
c01036a2:	68 02 02 00 00       	push   $0x202
c01036a7:	68 68 62 10 c0       	push   $0xc0106268
c01036ac:	e8 1c cd ff ff       	call   c01003cd <__panic>
    assert(pte2page(*ptep) == p1);
c01036b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01036b4:	8b 00                	mov    (%eax),%eax
c01036b6:	83 ec 0c             	sub    $0xc,%esp
c01036b9:	50                   	push   %eax
c01036ba:	e8 83 f2 ff ff       	call   c0102942 <pte2page>
c01036bf:	83 c4 10             	add    $0x10,%esp
c01036c2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01036c5:	74 19                	je     c01036e0 <check_pgdir+0x135>
c01036c7:	68 bd 63 10 c0       	push   $0xc01063bd
c01036cc:	68 8d 62 10 c0       	push   $0xc010628d
c01036d1:	68 03 02 00 00       	push   $0x203
c01036d6:	68 68 62 10 c0       	push   $0xc0106268
c01036db:	e8 ed cc ff ff       	call   c01003cd <__panic>
    assert(page_ref(p1) == 1);
c01036e0:	83 ec 0c             	sub    $0xc,%esp
c01036e3:	ff 75 f4             	pushl  -0xc(%ebp)
c01036e6:	e8 ad f2 ff ff       	call   c0102998 <page_ref>
c01036eb:	83 c4 10             	add    $0x10,%esp
c01036ee:	83 f8 01             	cmp    $0x1,%eax
c01036f1:	74 19                	je     c010370c <check_pgdir+0x161>
c01036f3:	68 d3 63 10 c0       	push   $0xc01063d3
c01036f8:	68 8d 62 10 c0       	push   $0xc010628d
c01036fd:	68 04 02 00 00       	push   $0x204
c0103702:	68 68 62 10 c0       	push   $0xc0106268
c0103707:	e8 c1 cc ff ff       	call   c01003cd <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c010370c:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103711:	8b 00                	mov    (%eax),%eax
c0103713:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103718:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010371b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010371e:	c1 e8 0c             	shr    $0xc,%eax
c0103721:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103724:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0103729:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c010372c:	72 17                	jb     c0103745 <check_pgdir+0x19a>
c010372e:	ff 75 ec             	pushl  -0x14(%ebp)
c0103731:	68 a0 61 10 c0       	push   $0xc01061a0
c0103736:	68 06 02 00 00       	push   $0x206
c010373b:	68 68 62 10 c0       	push   $0xc0106268
c0103740:	e8 88 cc ff ff       	call   c01003cd <__panic>
c0103745:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103748:	2d 00 00 00 40       	sub    $0x40000000,%eax
c010374d:	83 c0 04             	add    $0x4,%eax
c0103750:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c0103753:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103758:	83 ec 04             	sub    $0x4,%esp
c010375b:	6a 00                	push   $0x0
c010375d:	68 00 10 00 00       	push   $0x1000
c0103762:	50                   	push   %eax
c0103763:	e8 06 fb ff ff       	call   c010326e <get_pte>
c0103768:	83 c4 10             	add    $0x10,%esp
c010376b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c010376e:	74 19                	je     c0103789 <check_pgdir+0x1de>
c0103770:	68 e8 63 10 c0       	push   $0xc01063e8
c0103775:	68 8d 62 10 c0       	push   $0xc010628d
c010377a:	68 07 02 00 00       	push   $0x207
c010377f:	68 68 62 10 c0       	push   $0xc0106268
c0103784:	e8 44 cc ff ff       	call   c01003cd <__panic>

    p2 = alloc_page();
c0103789:	83 ec 0c             	sub    $0xc,%esp
c010378c:	6a 01                	push   $0x1
c010378e:	e8 13 f4 ff ff       	call   c0102ba6 <alloc_pages>
c0103793:	83 c4 10             	add    $0x10,%esp
c0103796:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0103799:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010379e:	6a 06                	push   $0x6
c01037a0:	68 00 10 00 00       	push   $0x1000
c01037a5:	ff 75 e4             	pushl  -0x1c(%ebp)
c01037a8:	50                   	push   %eax
c01037a9:	e8 d1 fc ff ff       	call   c010347f <page_insert>
c01037ae:	83 c4 10             	add    $0x10,%esp
c01037b1:	85 c0                	test   %eax,%eax
c01037b3:	74 19                	je     c01037ce <check_pgdir+0x223>
c01037b5:	68 10 64 10 c0       	push   $0xc0106410
c01037ba:	68 8d 62 10 c0       	push   $0xc010628d
c01037bf:	68 0a 02 00 00       	push   $0x20a
c01037c4:	68 68 62 10 c0       	push   $0xc0106268
c01037c9:	e8 ff cb ff ff       	call   c01003cd <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c01037ce:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01037d3:	83 ec 04             	sub    $0x4,%esp
c01037d6:	6a 00                	push   $0x0
c01037d8:	68 00 10 00 00       	push   $0x1000
c01037dd:	50                   	push   %eax
c01037de:	e8 8b fa ff ff       	call   c010326e <get_pte>
c01037e3:	83 c4 10             	add    $0x10,%esp
c01037e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01037e9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01037ed:	75 19                	jne    c0103808 <check_pgdir+0x25d>
c01037ef:	68 48 64 10 c0       	push   $0xc0106448
c01037f4:	68 8d 62 10 c0       	push   $0xc010628d
c01037f9:	68 0b 02 00 00       	push   $0x20b
c01037fe:	68 68 62 10 c0       	push   $0xc0106268
c0103803:	e8 c5 cb ff ff       	call   c01003cd <__panic>
    assert(*ptep & PTE_U);
c0103808:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010380b:	8b 00                	mov    (%eax),%eax
c010380d:	83 e0 04             	and    $0x4,%eax
c0103810:	85 c0                	test   %eax,%eax
c0103812:	75 19                	jne    c010382d <check_pgdir+0x282>
c0103814:	68 78 64 10 c0       	push   $0xc0106478
c0103819:	68 8d 62 10 c0       	push   $0xc010628d
c010381e:	68 0c 02 00 00       	push   $0x20c
c0103823:	68 68 62 10 c0       	push   $0xc0106268
c0103828:	e8 a0 cb ff ff       	call   c01003cd <__panic>
    assert(*ptep & PTE_W);
c010382d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103830:	8b 00                	mov    (%eax),%eax
c0103832:	83 e0 02             	and    $0x2,%eax
c0103835:	85 c0                	test   %eax,%eax
c0103837:	75 19                	jne    c0103852 <check_pgdir+0x2a7>
c0103839:	68 86 64 10 c0       	push   $0xc0106486
c010383e:	68 8d 62 10 c0       	push   $0xc010628d
c0103843:	68 0d 02 00 00       	push   $0x20d
c0103848:	68 68 62 10 c0       	push   $0xc0106268
c010384d:	e8 7b cb ff ff       	call   c01003cd <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0103852:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103857:	8b 00                	mov    (%eax),%eax
c0103859:	83 e0 04             	and    $0x4,%eax
c010385c:	85 c0                	test   %eax,%eax
c010385e:	75 19                	jne    c0103879 <check_pgdir+0x2ce>
c0103860:	68 94 64 10 c0       	push   $0xc0106494
c0103865:	68 8d 62 10 c0       	push   $0xc010628d
c010386a:	68 0e 02 00 00       	push   $0x20e
c010386f:	68 68 62 10 c0       	push   $0xc0106268
c0103874:	e8 54 cb ff ff       	call   c01003cd <__panic>
    assert(page_ref(p2) == 1);
c0103879:	83 ec 0c             	sub    $0xc,%esp
c010387c:	ff 75 e4             	pushl  -0x1c(%ebp)
c010387f:	e8 14 f1 ff ff       	call   c0102998 <page_ref>
c0103884:	83 c4 10             	add    $0x10,%esp
c0103887:	83 f8 01             	cmp    $0x1,%eax
c010388a:	74 19                	je     c01038a5 <check_pgdir+0x2fa>
c010388c:	68 aa 64 10 c0       	push   $0xc01064aa
c0103891:	68 8d 62 10 c0       	push   $0xc010628d
c0103896:	68 0f 02 00 00       	push   $0x20f
c010389b:	68 68 62 10 c0       	push   $0xc0106268
c01038a0:	e8 28 cb ff ff       	call   c01003cd <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c01038a5:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01038aa:	6a 00                	push   $0x0
c01038ac:	68 00 10 00 00       	push   $0x1000
c01038b1:	ff 75 f4             	pushl  -0xc(%ebp)
c01038b4:	50                   	push   %eax
c01038b5:	e8 c5 fb ff ff       	call   c010347f <page_insert>
c01038ba:	83 c4 10             	add    $0x10,%esp
c01038bd:	85 c0                	test   %eax,%eax
c01038bf:	74 19                	je     c01038da <check_pgdir+0x32f>
c01038c1:	68 bc 64 10 c0       	push   $0xc01064bc
c01038c6:	68 8d 62 10 c0       	push   $0xc010628d
c01038cb:	68 11 02 00 00       	push   $0x211
c01038d0:	68 68 62 10 c0       	push   $0xc0106268
c01038d5:	e8 f3 ca ff ff       	call   c01003cd <__panic>
    assert(page_ref(p1) == 2);
c01038da:	83 ec 0c             	sub    $0xc,%esp
c01038dd:	ff 75 f4             	pushl  -0xc(%ebp)
c01038e0:	e8 b3 f0 ff ff       	call   c0102998 <page_ref>
c01038e5:	83 c4 10             	add    $0x10,%esp
c01038e8:	83 f8 02             	cmp    $0x2,%eax
c01038eb:	74 19                	je     c0103906 <check_pgdir+0x35b>
c01038ed:	68 e8 64 10 c0       	push   $0xc01064e8
c01038f2:	68 8d 62 10 c0       	push   $0xc010628d
c01038f7:	68 12 02 00 00       	push   $0x212
c01038fc:	68 68 62 10 c0       	push   $0xc0106268
c0103901:	e8 c7 ca ff ff       	call   c01003cd <__panic>
    assert(page_ref(p2) == 0);
c0103906:	83 ec 0c             	sub    $0xc,%esp
c0103909:	ff 75 e4             	pushl  -0x1c(%ebp)
c010390c:	e8 87 f0 ff ff       	call   c0102998 <page_ref>
c0103911:	83 c4 10             	add    $0x10,%esp
c0103914:	85 c0                	test   %eax,%eax
c0103916:	74 19                	je     c0103931 <check_pgdir+0x386>
c0103918:	68 fa 64 10 c0       	push   $0xc01064fa
c010391d:	68 8d 62 10 c0       	push   $0xc010628d
c0103922:	68 13 02 00 00       	push   $0x213
c0103927:	68 68 62 10 c0       	push   $0xc0106268
c010392c:	e8 9c ca ff ff       	call   c01003cd <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0103931:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103936:	83 ec 04             	sub    $0x4,%esp
c0103939:	6a 00                	push   $0x0
c010393b:	68 00 10 00 00       	push   $0x1000
c0103940:	50                   	push   %eax
c0103941:	e8 28 f9 ff ff       	call   c010326e <get_pte>
c0103946:	83 c4 10             	add    $0x10,%esp
c0103949:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010394c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103950:	75 19                	jne    c010396b <check_pgdir+0x3c0>
c0103952:	68 48 64 10 c0       	push   $0xc0106448
c0103957:	68 8d 62 10 c0       	push   $0xc010628d
c010395c:	68 14 02 00 00       	push   $0x214
c0103961:	68 68 62 10 c0       	push   $0xc0106268
c0103966:	e8 62 ca ff ff       	call   c01003cd <__panic>
    assert(pte2page(*ptep) == p1);
c010396b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010396e:	8b 00                	mov    (%eax),%eax
c0103970:	83 ec 0c             	sub    $0xc,%esp
c0103973:	50                   	push   %eax
c0103974:	e8 c9 ef ff ff       	call   c0102942 <pte2page>
c0103979:	83 c4 10             	add    $0x10,%esp
c010397c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010397f:	74 19                	je     c010399a <check_pgdir+0x3ef>
c0103981:	68 bd 63 10 c0       	push   $0xc01063bd
c0103986:	68 8d 62 10 c0       	push   $0xc010628d
c010398b:	68 15 02 00 00       	push   $0x215
c0103990:	68 68 62 10 c0       	push   $0xc0106268
c0103995:	e8 33 ca ff ff       	call   c01003cd <__panic>
    assert((*ptep & PTE_U) == 0);
c010399a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010399d:	8b 00                	mov    (%eax),%eax
c010399f:	83 e0 04             	and    $0x4,%eax
c01039a2:	85 c0                	test   %eax,%eax
c01039a4:	74 19                	je     c01039bf <check_pgdir+0x414>
c01039a6:	68 0c 65 10 c0       	push   $0xc010650c
c01039ab:	68 8d 62 10 c0       	push   $0xc010628d
c01039b0:	68 16 02 00 00       	push   $0x216
c01039b5:	68 68 62 10 c0       	push   $0xc0106268
c01039ba:	e8 0e ca ff ff       	call   c01003cd <__panic>

    page_remove(boot_pgdir, 0x0);
c01039bf:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01039c4:	83 ec 08             	sub    $0x8,%esp
c01039c7:	6a 00                	push   $0x0
c01039c9:	50                   	push   %eax
c01039ca:	e8 77 fa ff ff       	call   c0103446 <page_remove>
c01039cf:	83 c4 10             	add    $0x10,%esp
    assert(page_ref(p1) == 1);
c01039d2:	83 ec 0c             	sub    $0xc,%esp
c01039d5:	ff 75 f4             	pushl  -0xc(%ebp)
c01039d8:	e8 bb ef ff ff       	call   c0102998 <page_ref>
c01039dd:	83 c4 10             	add    $0x10,%esp
c01039e0:	83 f8 01             	cmp    $0x1,%eax
c01039e3:	74 19                	je     c01039fe <check_pgdir+0x453>
c01039e5:	68 d3 63 10 c0       	push   $0xc01063d3
c01039ea:	68 8d 62 10 c0       	push   $0xc010628d
c01039ef:	68 19 02 00 00       	push   $0x219
c01039f4:	68 68 62 10 c0       	push   $0xc0106268
c01039f9:	e8 cf c9 ff ff       	call   c01003cd <__panic>
    assert(page_ref(p2) == 0);
c01039fe:	83 ec 0c             	sub    $0xc,%esp
c0103a01:	ff 75 e4             	pushl  -0x1c(%ebp)
c0103a04:	e8 8f ef ff ff       	call   c0102998 <page_ref>
c0103a09:	83 c4 10             	add    $0x10,%esp
c0103a0c:	85 c0                	test   %eax,%eax
c0103a0e:	74 19                	je     c0103a29 <check_pgdir+0x47e>
c0103a10:	68 fa 64 10 c0       	push   $0xc01064fa
c0103a15:	68 8d 62 10 c0       	push   $0xc010628d
c0103a1a:	68 1a 02 00 00       	push   $0x21a
c0103a1f:	68 68 62 10 c0       	push   $0xc0106268
c0103a24:	e8 a4 c9 ff ff       	call   c01003cd <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0103a29:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103a2e:	83 ec 08             	sub    $0x8,%esp
c0103a31:	68 00 10 00 00       	push   $0x1000
c0103a36:	50                   	push   %eax
c0103a37:	e8 0a fa ff ff       	call   c0103446 <page_remove>
c0103a3c:	83 c4 10             	add    $0x10,%esp
    assert(page_ref(p1) == 0);
c0103a3f:	83 ec 0c             	sub    $0xc,%esp
c0103a42:	ff 75 f4             	pushl  -0xc(%ebp)
c0103a45:	e8 4e ef ff ff       	call   c0102998 <page_ref>
c0103a4a:	83 c4 10             	add    $0x10,%esp
c0103a4d:	85 c0                	test   %eax,%eax
c0103a4f:	74 19                	je     c0103a6a <check_pgdir+0x4bf>
c0103a51:	68 21 65 10 c0       	push   $0xc0106521
c0103a56:	68 8d 62 10 c0       	push   $0xc010628d
c0103a5b:	68 1d 02 00 00       	push   $0x21d
c0103a60:	68 68 62 10 c0       	push   $0xc0106268
c0103a65:	e8 63 c9 ff ff       	call   c01003cd <__panic>
    assert(page_ref(p2) == 0);
c0103a6a:	83 ec 0c             	sub    $0xc,%esp
c0103a6d:	ff 75 e4             	pushl  -0x1c(%ebp)
c0103a70:	e8 23 ef ff ff       	call   c0102998 <page_ref>
c0103a75:	83 c4 10             	add    $0x10,%esp
c0103a78:	85 c0                	test   %eax,%eax
c0103a7a:	74 19                	je     c0103a95 <check_pgdir+0x4ea>
c0103a7c:	68 fa 64 10 c0       	push   $0xc01064fa
c0103a81:	68 8d 62 10 c0       	push   $0xc010628d
c0103a86:	68 1e 02 00 00       	push   $0x21e
c0103a8b:	68 68 62 10 c0       	push   $0xc0106268
c0103a90:	e8 38 c9 ff ff       	call   c01003cd <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c0103a95:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103a9a:	8b 00                	mov    (%eax),%eax
c0103a9c:	83 ec 0c             	sub    $0xc,%esp
c0103a9f:	50                   	push   %eax
c0103aa0:	e8 d7 ee ff ff       	call   c010297c <pde2page>
c0103aa5:	83 c4 10             	add    $0x10,%esp
c0103aa8:	83 ec 0c             	sub    $0xc,%esp
c0103aab:	50                   	push   %eax
c0103aac:	e8 e7 ee ff ff       	call   c0102998 <page_ref>
c0103ab1:	83 c4 10             	add    $0x10,%esp
c0103ab4:	83 f8 01             	cmp    $0x1,%eax
c0103ab7:	74 19                	je     c0103ad2 <check_pgdir+0x527>
c0103ab9:	68 34 65 10 c0       	push   $0xc0106534
c0103abe:	68 8d 62 10 c0       	push   $0xc010628d
c0103ac3:	68 20 02 00 00       	push   $0x220
c0103ac8:	68 68 62 10 c0       	push   $0xc0106268
c0103acd:	e8 fb c8 ff ff       	call   c01003cd <__panic>
    free_page(pde2page(boot_pgdir[0]));
c0103ad2:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103ad7:	8b 00                	mov    (%eax),%eax
c0103ad9:	83 ec 0c             	sub    $0xc,%esp
c0103adc:	50                   	push   %eax
c0103add:	e8 9a ee ff ff       	call   c010297c <pde2page>
c0103ae2:	83 c4 10             	add    $0x10,%esp
c0103ae5:	83 ec 08             	sub    $0x8,%esp
c0103ae8:	6a 01                	push   $0x1
c0103aea:	50                   	push   %eax
c0103aeb:	e8 f4 f0 ff ff       	call   c0102be4 <free_pages>
c0103af0:	83 c4 10             	add    $0x10,%esp
    boot_pgdir[0] = 0;
c0103af3:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103af8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0103afe:	83 ec 0c             	sub    $0xc,%esp
c0103b01:	68 5b 65 10 c0       	push   $0xc010655b
c0103b06:	e8 5c c7 ff ff       	call   c0100267 <cprintf>
c0103b0b:	83 c4 10             	add    $0x10,%esp
}
c0103b0e:	90                   	nop
c0103b0f:	c9                   	leave  
c0103b10:	c3                   	ret    

c0103b11 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0103b11:	55                   	push   %ebp
c0103b12:	89 e5                	mov    %esp,%ebp
c0103b14:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0103b17:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103b1e:	e9 a3 00 00 00       	jmp    c0103bc6 <check_boot_pgdir+0xb5>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0103b23:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b26:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103b29:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103b2c:	c1 e8 0c             	shr    $0xc,%eax
c0103b2f:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103b32:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0103b37:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0103b3a:	72 17                	jb     c0103b53 <check_boot_pgdir+0x42>
c0103b3c:	ff 75 f0             	pushl  -0x10(%ebp)
c0103b3f:	68 a0 61 10 c0       	push   $0xc01061a0
c0103b44:	68 2c 02 00 00       	push   $0x22c
c0103b49:	68 68 62 10 c0       	push   $0xc0106268
c0103b4e:	e8 7a c8 ff ff       	call   c01003cd <__panic>
c0103b53:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103b56:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0103b5b:	89 c2                	mov    %eax,%edx
c0103b5d:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103b62:	83 ec 04             	sub    $0x4,%esp
c0103b65:	6a 00                	push   $0x0
c0103b67:	52                   	push   %edx
c0103b68:	50                   	push   %eax
c0103b69:	e8 00 f7 ff ff       	call   c010326e <get_pte>
c0103b6e:	83 c4 10             	add    $0x10,%esp
c0103b71:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103b74:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0103b78:	75 19                	jne    c0103b93 <check_boot_pgdir+0x82>
c0103b7a:	68 78 65 10 c0       	push   $0xc0106578
c0103b7f:	68 8d 62 10 c0       	push   $0xc010628d
c0103b84:	68 2c 02 00 00       	push   $0x22c
c0103b89:	68 68 62 10 c0       	push   $0xc0106268
c0103b8e:	e8 3a c8 ff ff       	call   c01003cd <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0103b93:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103b96:	8b 00                	mov    (%eax),%eax
c0103b98:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103b9d:	89 c2                	mov    %eax,%edx
c0103b9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ba2:	39 c2                	cmp    %eax,%edx
c0103ba4:	74 19                	je     c0103bbf <check_boot_pgdir+0xae>
c0103ba6:	68 b5 65 10 c0       	push   $0xc01065b5
c0103bab:	68 8d 62 10 c0       	push   $0xc010628d
c0103bb0:	68 2d 02 00 00       	push   $0x22d
c0103bb5:	68 68 62 10 c0       	push   $0xc0106268
c0103bba:	e8 0e c8 ff ff       	call   c01003cd <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0103bbf:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0103bc6:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103bc9:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0103bce:	39 c2                	cmp    %eax,%edx
c0103bd0:	0f 82 4d ff ff ff    	jb     c0103b23 <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0103bd6:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103bdb:	05 ac 0f 00 00       	add    $0xfac,%eax
c0103be0:	8b 00                	mov    (%eax),%eax
c0103be2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103be7:	89 c2                	mov    %eax,%edx
c0103be9:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103bee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103bf1:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c0103bf8:	77 17                	ja     c0103c11 <check_boot_pgdir+0x100>
c0103bfa:	ff 75 e4             	pushl  -0x1c(%ebp)
c0103bfd:	68 44 62 10 c0       	push   $0xc0106244
c0103c02:	68 30 02 00 00       	push   $0x230
c0103c07:	68 68 62 10 c0       	push   $0xc0106268
c0103c0c:	e8 bc c7 ff ff       	call   c01003cd <__panic>
c0103c11:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103c14:	05 00 00 00 40       	add    $0x40000000,%eax
c0103c19:	39 c2                	cmp    %eax,%edx
c0103c1b:	74 19                	je     c0103c36 <check_boot_pgdir+0x125>
c0103c1d:	68 cc 65 10 c0       	push   $0xc01065cc
c0103c22:	68 8d 62 10 c0       	push   $0xc010628d
c0103c27:	68 30 02 00 00       	push   $0x230
c0103c2c:	68 68 62 10 c0       	push   $0xc0106268
c0103c31:	e8 97 c7 ff ff       	call   c01003cd <__panic>

    assert(boot_pgdir[0] == 0);
c0103c36:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103c3b:	8b 00                	mov    (%eax),%eax
c0103c3d:	85 c0                	test   %eax,%eax
c0103c3f:	74 19                	je     c0103c5a <check_boot_pgdir+0x149>
c0103c41:	68 00 66 10 c0       	push   $0xc0106600
c0103c46:	68 8d 62 10 c0       	push   $0xc010628d
c0103c4b:	68 32 02 00 00       	push   $0x232
c0103c50:	68 68 62 10 c0       	push   $0xc0106268
c0103c55:	e8 73 c7 ff ff       	call   c01003cd <__panic>

    struct Page *p;
    p = alloc_page();
c0103c5a:	83 ec 0c             	sub    $0xc,%esp
c0103c5d:	6a 01                	push   $0x1
c0103c5f:	e8 42 ef ff ff       	call   c0102ba6 <alloc_pages>
c0103c64:	83 c4 10             	add    $0x10,%esp
c0103c67:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0103c6a:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103c6f:	6a 02                	push   $0x2
c0103c71:	68 00 01 00 00       	push   $0x100
c0103c76:	ff 75 e0             	pushl  -0x20(%ebp)
c0103c79:	50                   	push   %eax
c0103c7a:	e8 00 f8 ff ff       	call   c010347f <page_insert>
c0103c7f:	83 c4 10             	add    $0x10,%esp
c0103c82:	85 c0                	test   %eax,%eax
c0103c84:	74 19                	je     c0103c9f <check_boot_pgdir+0x18e>
c0103c86:	68 14 66 10 c0       	push   $0xc0106614
c0103c8b:	68 8d 62 10 c0       	push   $0xc010628d
c0103c90:	68 36 02 00 00       	push   $0x236
c0103c95:	68 68 62 10 c0       	push   $0xc0106268
c0103c9a:	e8 2e c7 ff ff       	call   c01003cd <__panic>
    assert(page_ref(p) == 1);
c0103c9f:	83 ec 0c             	sub    $0xc,%esp
c0103ca2:	ff 75 e0             	pushl  -0x20(%ebp)
c0103ca5:	e8 ee ec ff ff       	call   c0102998 <page_ref>
c0103caa:	83 c4 10             	add    $0x10,%esp
c0103cad:	83 f8 01             	cmp    $0x1,%eax
c0103cb0:	74 19                	je     c0103ccb <check_boot_pgdir+0x1ba>
c0103cb2:	68 42 66 10 c0       	push   $0xc0106642
c0103cb7:	68 8d 62 10 c0       	push   $0xc010628d
c0103cbc:	68 37 02 00 00       	push   $0x237
c0103cc1:	68 68 62 10 c0       	push   $0xc0106268
c0103cc6:	e8 02 c7 ff ff       	call   c01003cd <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0103ccb:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103cd0:	6a 02                	push   $0x2
c0103cd2:	68 00 11 00 00       	push   $0x1100
c0103cd7:	ff 75 e0             	pushl  -0x20(%ebp)
c0103cda:	50                   	push   %eax
c0103cdb:	e8 9f f7 ff ff       	call   c010347f <page_insert>
c0103ce0:	83 c4 10             	add    $0x10,%esp
c0103ce3:	85 c0                	test   %eax,%eax
c0103ce5:	74 19                	je     c0103d00 <check_boot_pgdir+0x1ef>
c0103ce7:	68 54 66 10 c0       	push   $0xc0106654
c0103cec:	68 8d 62 10 c0       	push   $0xc010628d
c0103cf1:	68 38 02 00 00       	push   $0x238
c0103cf6:	68 68 62 10 c0       	push   $0xc0106268
c0103cfb:	e8 cd c6 ff ff       	call   c01003cd <__panic>
    assert(page_ref(p) == 2);
c0103d00:	83 ec 0c             	sub    $0xc,%esp
c0103d03:	ff 75 e0             	pushl  -0x20(%ebp)
c0103d06:	e8 8d ec ff ff       	call   c0102998 <page_ref>
c0103d0b:	83 c4 10             	add    $0x10,%esp
c0103d0e:	83 f8 02             	cmp    $0x2,%eax
c0103d11:	74 19                	je     c0103d2c <check_boot_pgdir+0x21b>
c0103d13:	68 8b 66 10 c0       	push   $0xc010668b
c0103d18:	68 8d 62 10 c0       	push   $0xc010628d
c0103d1d:	68 39 02 00 00       	push   $0x239
c0103d22:	68 68 62 10 c0       	push   $0xc0106268
c0103d27:	e8 a1 c6 ff ff       	call   c01003cd <__panic>

    const char *str = "ucore: Hello world!!";
c0103d2c:	c7 45 dc 9c 66 10 c0 	movl   $0xc010669c,-0x24(%ebp)
    strcpy((void *)0x100, str);
c0103d33:	83 ec 08             	sub    $0x8,%esp
c0103d36:	ff 75 dc             	pushl  -0x24(%ebp)
c0103d39:	68 00 01 00 00       	push   $0x100
c0103d3e:	e8 9c 12 00 00       	call   c0104fdf <strcpy>
c0103d43:	83 c4 10             	add    $0x10,%esp
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0103d46:	83 ec 08             	sub    $0x8,%esp
c0103d49:	68 00 11 00 00       	push   $0x1100
c0103d4e:	68 00 01 00 00       	push   $0x100
c0103d53:	e8 01 13 00 00       	call   c0105059 <strcmp>
c0103d58:	83 c4 10             	add    $0x10,%esp
c0103d5b:	85 c0                	test   %eax,%eax
c0103d5d:	74 19                	je     c0103d78 <check_boot_pgdir+0x267>
c0103d5f:	68 b4 66 10 c0       	push   $0xc01066b4
c0103d64:	68 8d 62 10 c0       	push   $0xc010628d
c0103d69:	68 3d 02 00 00       	push   $0x23d
c0103d6e:	68 68 62 10 c0       	push   $0xc0106268
c0103d73:	e8 55 c6 ff ff       	call   c01003cd <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0103d78:	83 ec 0c             	sub    $0xc,%esp
c0103d7b:	ff 75 e0             	pushl  -0x20(%ebp)
c0103d7e:	e8 7a eb ff ff       	call   c01028fd <page2kva>
c0103d83:	83 c4 10             	add    $0x10,%esp
c0103d86:	05 00 01 00 00       	add    $0x100,%eax
c0103d8b:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0103d8e:	83 ec 0c             	sub    $0xc,%esp
c0103d91:	68 00 01 00 00       	push   $0x100
c0103d96:	e8 ec 11 00 00       	call   c0104f87 <strlen>
c0103d9b:	83 c4 10             	add    $0x10,%esp
c0103d9e:	85 c0                	test   %eax,%eax
c0103da0:	74 19                	je     c0103dbb <check_boot_pgdir+0x2aa>
c0103da2:	68 ec 66 10 c0       	push   $0xc01066ec
c0103da7:	68 8d 62 10 c0       	push   $0xc010628d
c0103dac:	68 40 02 00 00       	push   $0x240
c0103db1:	68 68 62 10 c0       	push   $0xc0106268
c0103db6:	e8 12 c6 ff ff       	call   c01003cd <__panic>

    free_page(p);
c0103dbb:	83 ec 08             	sub    $0x8,%esp
c0103dbe:	6a 01                	push   $0x1
c0103dc0:	ff 75 e0             	pushl  -0x20(%ebp)
c0103dc3:	e8 1c ee ff ff       	call   c0102be4 <free_pages>
c0103dc8:	83 c4 10             	add    $0x10,%esp
    free_page(pde2page(boot_pgdir[0]));
c0103dcb:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103dd0:	8b 00                	mov    (%eax),%eax
c0103dd2:	83 ec 0c             	sub    $0xc,%esp
c0103dd5:	50                   	push   %eax
c0103dd6:	e8 a1 eb ff ff       	call   c010297c <pde2page>
c0103ddb:	83 c4 10             	add    $0x10,%esp
c0103dde:	83 ec 08             	sub    $0x8,%esp
c0103de1:	6a 01                	push   $0x1
c0103de3:	50                   	push   %eax
c0103de4:	e8 fb ed ff ff       	call   c0102be4 <free_pages>
c0103de9:	83 c4 10             	add    $0x10,%esp
    boot_pgdir[0] = 0;
c0103dec:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103df1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0103df7:	83 ec 0c             	sub    $0xc,%esp
c0103dfa:	68 10 67 10 c0       	push   $0xc0106710
c0103dff:	e8 63 c4 ff ff       	call   c0100267 <cprintf>
c0103e04:	83 c4 10             	add    $0x10,%esp
}
c0103e07:	90                   	nop
c0103e08:	c9                   	leave  
c0103e09:	c3                   	ret    

c0103e0a <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c0103e0a:	55                   	push   %ebp
c0103e0b:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0103e0d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103e10:	83 e0 04             	and    $0x4,%eax
c0103e13:	85 c0                	test   %eax,%eax
c0103e15:	74 07                	je     c0103e1e <perm2str+0x14>
c0103e17:	b8 75 00 00 00       	mov    $0x75,%eax
c0103e1c:	eb 05                	jmp    c0103e23 <perm2str+0x19>
c0103e1e:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0103e23:	a2 48 89 11 c0       	mov    %al,0xc0118948
    str[1] = 'r';
c0103e28:	c6 05 49 89 11 c0 72 	movb   $0x72,0xc0118949
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0103e2f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103e32:	83 e0 02             	and    $0x2,%eax
c0103e35:	85 c0                	test   %eax,%eax
c0103e37:	74 07                	je     c0103e40 <perm2str+0x36>
c0103e39:	b8 77 00 00 00       	mov    $0x77,%eax
c0103e3e:	eb 05                	jmp    c0103e45 <perm2str+0x3b>
c0103e40:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0103e45:	a2 4a 89 11 c0       	mov    %al,0xc011894a
    str[3] = '\0';
c0103e4a:	c6 05 4b 89 11 c0 00 	movb   $0x0,0xc011894b
    return str;
c0103e51:	b8 48 89 11 c0       	mov    $0xc0118948,%eax
}
c0103e56:	5d                   	pop    %ebp
c0103e57:	c3                   	ret    

c0103e58 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c0103e58:	55                   	push   %ebp
c0103e59:	89 e5                	mov    %esp,%ebp
c0103e5b:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c0103e5e:	8b 45 10             	mov    0x10(%ebp),%eax
c0103e61:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103e64:	72 0e                	jb     c0103e74 <get_pgtable_items+0x1c>
        return 0;
c0103e66:	b8 00 00 00 00       	mov    $0x0,%eax
c0103e6b:	e9 9a 00 00 00       	jmp    c0103f0a <get_pgtable_items+0xb2>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
c0103e70:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c0103e74:	8b 45 10             	mov    0x10(%ebp),%eax
c0103e77:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103e7a:	73 18                	jae    c0103e94 <get_pgtable_items+0x3c>
c0103e7c:	8b 45 10             	mov    0x10(%ebp),%eax
c0103e7f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0103e86:	8b 45 14             	mov    0x14(%ebp),%eax
c0103e89:	01 d0                	add    %edx,%eax
c0103e8b:	8b 00                	mov    (%eax),%eax
c0103e8d:	83 e0 01             	and    $0x1,%eax
c0103e90:	85 c0                	test   %eax,%eax
c0103e92:	74 dc                	je     c0103e70 <get_pgtable_items+0x18>
        start ++;
    }
    if (start < right) {
c0103e94:	8b 45 10             	mov    0x10(%ebp),%eax
c0103e97:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103e9a:	73 69                	jae    c0103f05 <get_pgtable_items+0xad>
        if (left_store != NULL) {
c0103e9c:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0103ea0:	74 08                	je     c0103eaa <get_pgtable_items+0x52>
            *left_store = start;
c0103ea2:	8b 45 18             	mov    0x18(%ebp),%eax
c0103ea5:	8b 55 10             	mov    0x10(%ebp),%edx
c0103ea8:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c0103eaa:	8b 45 10             	mov    0x10(%ebp),%eax
c0103ead:	8d 50 01             	lea    0x1(%eax),%edx
c0103eb0:	89 55 10             	mov    %edx,0x10(%ebp)
c0103eb3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0103eba:	8b 45 14             	mov    0x14(%ebp),%eax
c0103ebd:	01 d0                	add    %edx,%eax
c0103ebf:	8b 00                	mov    (%eax),%eax
c0103ec1:	83 e0 07             	and    $0x7,%eax
c0103ec4:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0103ec7:	eb 04                	jmp    c0103ecd <get_pgtable_items+0x75>
            start ++;
c0103ec9:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c0103ecd:	8b 45 10             	mov    0x10(%ebp),%eax
c0103ed0:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103ed3:	73 1d                	jae    c0103ef2 <get_pgtable_items+0x9a>
c0103ed5:	8b 45 10             	mov    0x10(%ebp),%eax
c0103ed8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0103edf:	8b 45 14             	mov    0x14(%ebp),%eax
c0103ee2:	01 d0                	add    %edx,%eax
c0103ee4:	8b 00                	mov    (%eax),%eax
c0103ee6:	83 e0 07             	and    $0x7,%eax
c0103ee9:	89 c2                	mov    %eax,%edx
c0103eeb:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103eee:	39 c2                	cmp    %eax,%edx
c0103ef0:	74 d7                	je     c0103ec9 <get_pgtable_items+0x71>
            start ++;
        }
        if (right_store != NULL) {
c0103ef2:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0103ef6:	74 08                	je     c0103f00 <get_pgtable_items+0xa8>
            *right_store = start;
c0103ef8:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0103efb:	8b 55 10             	mov    0x10(%ebp),%edx
c0103efe:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c0103f00:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103f03:	eb 05                	jmp    c0103f0a <get_pgtable_items+0xb2>
    }
    return 0;
c0103f05:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103f0a:	c9                   	leave  
c0103f0b:	c3                   	ret    

c0103f0c <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c0103f0c:	55                   	push   %ebp
c0103f0d:	89 e5                	mov    %esp,%ebp
c0103f0f:	57                   	push   %edi
c0103f10:	56                   	push   %esi
c0103f11:	53                   	push   %ebx
c0103f12:	83 ec 2c             	sub    $0x2c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c0103f15:	83 ec 0c             	sub    $0xc,%esp
c0103f18:	68 30 67 10 c0       	push   $0xc0106730
c0103f1d:	e8 45 c3 ff ff       	call   c0100267 <cprintf>
c0103f22:	83 c4 10             	add    $0x10,%esp
    size_t left, right = 0, perm;
c0103f25:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0103f2c:	e9 e5 00 00 00       	jmp    c0104016 <print_pgdir+0x10a>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0103f31:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103f34:	83 ec 0c             	sub    $0xc,%esp
c0103f37:	50                   	push   %eax
c0103f38:	e8 cd fe ff ff       	call   c0103e0a <perm2str>
c0103f3d:	83 c4 10             	add    $0x10,%esp
c0103f40:	89 c7                	mov    %eax,%edi
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0103f42:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103f45:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103f48:	29 c2                	sub    %eax,%edx
c0103f4a:	89 d0                	mov    %edx,%eax
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0103f4c:	c1 e0 16             	shl    $0x16,%eax
c0103f4f:	89 c3                	mov    %eax,%ebx
c0103f51:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103f54:	c1 e0 16             	shl    $0x16,%eax
c0103f57:	89 c1                	mov    %eax,%ecx
c0103f59:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103f5c:	c1 e0 16             	shl    $0x16,%eax
c0103f5f:	89 c2                	mov    %eax,%edx
c0103f61:	8b 75 dc             	mov    -0x24(%ebp),%esi
c0103f64:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103f67:	29 c6                	sub    %eax,%esi
c0103f69:	89 f0                	mov    %esi,%eax
c0103f6b:	83 ec 08             	sub    $0x8,%esp
c0103f6e:	57                   	push   %edi
c0103f6f:	53                   	push   %ebx
c0103f70:	51                   	push   %ecx
c0103f71:	52                   	push   %edx
c0103f72:	50                   	push   %eax
c0103f73:	68 61 67 10 c0       	push   $0xc0106761
c0103f78:	e8 ea c2 ff ff       	call   c0100267 <cprintf>
c0103f7d:	83 c4 20             	add    $0x20,%esp
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c0103f80:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103f83:	c1 e0 0a             	shl    $0xa,%eax
c0103f86:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0103f89:	eb 4f                	jmp    c0103fda <print_pgdir+0xce>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0103f8b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103f8e:	83 ec 0c             	sub    $0xc,%esp
c0103f91:	50                   	push   %eax
c0103f92:	e8 73 fe ff ff       	call   c0103e0a <perm2str>
c0103f97:	83 c4 10             	add    $0x10,%esp
c0103f9a:	89 c7                	mov    %eax,%edi
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c0103f9c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103f9f:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103fa2:	29 c2                	sub    %eax,%edx
c0103fa4:	89 d0                	mov    %edx,%eax
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0103fa6:	c1 e0 0c             	shl    $0xc,%eax
c0103fa9:	89 c3                	mov    %eax,%ebx
c0103fab:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103fae:	c1 e0 0c             	shl    $0xc,%eax
c0103fb1:	89 c1                	mov    %eax,%ecx
c0103fb3:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103fb6:	c1 e0 0c             	shl    $0xc,%eax
c0103fb9:	89 c2                	mov    %eax,%edx
c0103fbb:	8b 75 d4             	mov    -0x2c(%ebp),%esi
c0103fbe:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103fc1:	29 c6                	sub    %eax,%esi
c0103fc3:	89 f0                	mov    %esi,%eax
c0103fc5:	83 ec 08             	sub    $0x8,%esp
c0103fc8:	57                   	push   %edi
c0103fc9:	53                   	push   %ebx
c0103fca:	51                   	push   %ecx
c0103fcb:	52                   	push   %edx
c0103fcc:	50                   	push   %eax
c0103fcd:	68 80 67 10 c0       	push   $0xc0106780
c0103fd2:	e8 90 c2 ff ff       	call   c0100267 <cprintf>
c0103fd7:	83 c4 20             	add    $0x20,%esp
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0103fda:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
c0103fdf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103fe2:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103fe5:	89 d3                	mov    %edx,%ebx
c0103fe7:	c1 e3 0a             	shl    $0xa,%ebx
c0103fea:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103fed:	89 d1                	mov    %edx,%ecx
c0103fef:	c1 e1 0a             	shl    $0xa,%ecx
c0103ff2:	83 ec 08             	sub    $0x8,%esp
c0103ff5:	8d 55 d4             	lea    -0x2c(%ebp),%edx
c0103ff8:	52                   	push   %edx
c0103ff9:	8d 55 d8             	lea    -0x28(%ebp),%edx
c0103ffc:	52                   	push   %edx
c0103ffd:	56                   	push   %esi
c0103ffe:	50                   	push   %eax
c0103fff:	53                   	push   %ebx
c0104000:	51                   	push   %ecx
c0104001:	e8 52 fe ff ff       	call   c0103e58 <get_pgtable_items>
c0104006:	83 c4 20             	add    $0x20,%esp
c0104009:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010400c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104010:	0f 85 75 ff ff ff    	jne    c0103f8b <print_pgdir+0x7f>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0104016:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
c010401b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010401e:	83 ec 08             	sub    $0x8,%esp
c0104021:	8d 55 dc             	lea    -0x24(%ebp),%edx
c0104024:	52                   	push   %edx
c0104025:	8d 55 e0             	lea    -0x20(%ebp),%edx
c0104028:	52                   	push   %edx
c0104029:	51                   	push   %ecx
c010402a:	50                   	push   %eax
c010402b:	68 00 04 00 00       	push   $0x400
c0104030:	6a 00                	push   $0x0
c0104032:	e8 21 fe ff ff       	call   c0103e58 <get_pgtable_items>
c0104037:	83 c4 20             	add    $0x20,%esp
c010403a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010403d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104041:	0f 85 ea fe ff ff    	jne    c0103f31 <print_pgdir+0x25>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c0104047:	83 ec 0c             	sub    $0xc,%esp
c010404a:	68 a4 67 10 c0       	push   $0xc01067a4
c010404f:	e8 13 c2 ff ff       	call   c0100267 <cprintf>
c0104054:	83 c4 10             	add    $0x10,%esp
}
c0104057:	90                   	nop
c0104058:	8d 65 f4             	lea    -0xc(%ebp),%esp
c010405b:	5b                   	pop    %ebx
c010405c:	5e                   	pop    %esi
c010405d:	5f                   	pop    %edi
c010405e:	5d                   	pop    %ebp
c010405f:	c3                   	ret    

c0104060 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0104060:	55                   	push   %ebp
c0104061:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0104063:	8b 45 08             	mov    0x8(%ebp),%eax
c0104066:	8b 15 58 89 11 c0    	mov    0xc0118958,%edx
c010406c:	29 d0                	sub    %edx,%eax
c010406e:	c1 f8 02             	sar    $0x2,%eax
c0104071:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0104077:	5d                   	pop    %ebp
c0104078:	c3                   	ret    

c0104079 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0104079:	55                   	push   %ebp
c010407a:	89 e5                	mov    %esp,%ebp
    return page2ppn(page) << PGSHIFT;
c010407c:	ff 75 08             	pushl  0x8(%ebp)
c010407f:	e8 dc ff ff ff       	call   c0104060 <page2ppn>
c0104084:	83 c4 04             	add    $0x4,%esp
c0104087:	c1 e0 0c             	shl    $0xc,%eax
}
c010408a:	c9                   	leave  
c010408b:	c3                   	ret    

c010408c <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c010408c:	55                   	push   %ebp
c010408d:	89 e5                	mov    %esp,%ebp
    return page->ref;
c010408f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104092:	8b 00                	mov    (%eax),%eax
}
c0104094:	5d                   	pop    %ebp
c0104095:	c3                   	ret    

c0104096 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0104096:	55                   	push   %ebp
c0104097:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0104099:	8b 45 08             	mov    0x8(%ebp),%eax
c010409c:	8b 55 0c             	mov    0xc(%ebp),%edx
c010409f:	89 10                	mov    %edx,(%eax)
}
c01040a1:	90                   	nop
c01040a2:	5d                   	pop    %ebp
c01040a3:	c3                   	ret    

c01040a4 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c01040a4:	55                   	push   %ebp
c01040a5:	89 e5                	mov    %esp,%ebp
c01040a7:	83 ec 10             	sub    $0x10,%esp
c01040aa:	c7 45 fc 5c 89 11 c0 	movl   $0xc011895c,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01040b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01040b4:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01040b7:	89 50 04             	mov    %edx,0x4(%eax)
c01040ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01040bd:	8b 50 04             	mov    0x4(%eax),%edx
c01040c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01040c3:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c01040c5:	c7 05 64 89 11 c0 00 	movl   $0x0,0xc0118964
c01040cc:	00 00 00 
}
c01040cf:	90                   	nop
c01040d0:	c9                   	leave  
c01040d1:	c3                   	ret    

c01040d2 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c01040d2:	55                   	push   %ebp
c01040d3:	89 e5                	mov    %esp,%ebp
c01040d5:	83 ec 38             	sub    $0x38,%esp
    assert(n > 0);
c01040d8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01040dc:	75 16                	jne    c01040f4 <default_init_memmap+0x22>
c01040de:	68 d8 67 10 c0       	push   $0xc01067d8
c01040e3:	68 de 67 10 c0       	push   $0xc01067de
c01040e8:	6a 46                	push   $0x46
c01040ea:	68 f3 67 10 c0       	push   $0xc01067f3
c01040ef:	e8 d9 c2 ff ff       	call   c01003cd <__panic>
    struct Page *p = base;
c01040f4:	8b 45 08             	mov    0x8(%ebp),%eax
c01040f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c01040fa:	e9 cb 00 00 00       	jmp    c01041ca <default_init_memmap+0xf8>
        assert(PageReserved(p));    //测试该位置是否被映射，若被映射则报错(reserved=0) 
c01040ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104102:	83 c0 04             	add    $0x4,%eax
c0104105:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c010410c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010410f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104112:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0104115:	0f a3 10             	bt     %edx,(%eax)
c0104118:	19 c0                	sbb    %eax,%eax
c010411a:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return oldbit != 0;
c010411d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0104121:	0f 95 c0             	setne  %al
c0104124:	0f b6 c0             	movzbl %al,%eax
c0104127:	85 c0                	test   %eax,%eax
c0104129:	75 16                	jne    c0104141 <default_init_memmap+0x6f>
c010412b:	68 09 68 10 c0       	push   $0xc0106809
c0104130:	68 de 67 10 c0       	push   $0xc01067de
c0104135:	6a 49                	push   $0x49
c0104137:	68 f3 67 10 c0       	push   $0xc01067f3
c010413c:	e8 8c c2 ff ff       	call   c01003cd <__panic>
        p->flags = 0;               //将flags置0，将PG_reserved改为0，变为已映射状态
c0104141:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104144:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        SetPageProperty(p);         //使page->property valid,从而设置其值
c010414b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010414e:	83 c0 04             	add    $0x4,%eax
c0104151:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
c0104158:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010415b:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010415e:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104161:	0f ab 10             	bts    %edx,(%eax)
        p->property = 0;
c0104164:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104167:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        set_page_ref(p, 0);
c010416e:	83 ec 08             	sub    $0x8,%esp
c0104171:	6a 00                	push   $0x0
c0104173:	ff 75 f4             	pushl  -0xc(%ebp)
c0104176:	e8 1b ff ff ff       	call   c0104096 <set_page_ref>
c010417b:	83 c4 10             	add    $0x10,%esp
        list_add_before(&free_list, &(p->page_link));
c010417e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104181:	83 c0 0c             	add    $0xc,%eax
c0104184:	c7 45 f0 5c 89 11 c0 	movl   $0xc011895c,-0x10(%ebp)
c010418b:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c010418e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104191:	8b 00                	mov    (%eax),%eax
c0104193:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104196:	89 55 d8             	mov    %edx,-0x28(%ebp)
c0104199:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c010419c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010419f:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c01041a2:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01041a5:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01041a8:	89 10                	mov    %edx,(%eax)
c01041aa:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01041ad:	8b 10                	mov    (%eax),%edx
c01041af:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01041b2:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01041b5:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01041b8:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01041bb:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01041be:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01041c1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01041c4:	89 10                	mov    %edx,(%eax)

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c01041c6:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c01041ca:	8b 55 0c             	mov    0xc(%ebp),%edx
c01041cd:	89 d0                	mov    %edx,%eax
c01041cf:	c1 e0 02             	shl    $0x2,%eax
c01041d2:	01 d0                	add    %edx,%eax
c01041d4:	c1 e0 02             	shl    $0x2,%eax
c01041d7:	89 c2                	mov    %eax,%edx
c01041d9:	8b 45 08             	mov    0x8(%ebp),%eax
c01041dc:	01 d0                	add    %edx,%eax
c01041de:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01041e1:	0f 85 18 ff ff ff    	jne    c01040ff <default_init_memmap+0x2d>
    }       
    //仔细观察list_add_before函数可知，实际每次是插入free_list的前面即队列的末尾
    //这波循环结束后，形成了一个环形链表，
    //free_list->1->2->3->……->n->free_list;
    //free_list<-1<-2<-……<-n-1<-n<-free_list;  
    nr_free += n;
c01041e7:	8b 15 64 89 11 c0    	mov    0xc0118964,%edx
c01041ed:	8b 45 0c             	mov    0xc(%ebp),%eax
c01041f0:	01 d0                	add    %edx,%eax
c01041f2:	a3 64 89 11 c0       	mov    %eax,0xc0118964
    base->property = n;
c01041f7:	8b 45 08             	mov    0x8(%ebp),%eax
c01041fa:	8b 55 0c             	mov    0xc(%ebp),%edx
c01041fd:	89 50 08             	mov    %edx,0x8(%eax)
}
c0104200:	90                   	nop
c0104201:	c9                   	leave  
c0104202:	c3                   	ret    

c0104203 <default_alloc_pages>:


//分配页表
static struct Page *
default_alloc_pages(size_t n) {
c0104203:	55                   	push   %ebp
c0104204:	89 e5                	mov    %esp,%ebp
c0104206:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
c0104209:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010420d:	75 16                	jne    c0104225 <default_alloc_pages+0x22>
c010420f:	68 d8 67 10 c0       	push   $0xc01067d8
c0104214:	68 de 67 10 c0       	push   $0xc01067de
c0104219:	6a 5c                	push   $0x5c
c010421b:	68 f3 67 10 c0       	push   $0xc01067f3
c0104220:	e8 a8 c1 ff ff       	call   c01003cd <__panic>
    if (n > nr_free) {
c0104225:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c010422a:	3b 45 08             	cmp    0x8(%ebp),%eax
c010422d:	73 0a                	jae    c0104239 <default_alloc_pages+0x36>
        return NULL;
c010422f:	b8 00 00 00 00       	mov    $0x0,%eax
c0104234:	e9 37 01 00 00       	jmp    c0104370 <default_alloc_pages+0x16d>
    }

    list_entry_t *le = &free_list;
c0104239:	c7 45 f4 5c 89 11 c0 	movl   $0xc011895c,-0xc(%ebp)

    while ((le = list_next(le)) != &free_list) 
c0104240:	e9 0a 01 00 00       	jmp    c010434f <default_alloc_pages+0x14c>
    {
        struct Page *p = le2page(le, page_link);
c0104245:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104248:	83 e8 0c             	sub    $0xc,%eax
c010424b:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) 
c010424e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104251:	8b 40 08             	mov    0x8(%eax),%eax
c0104254:	3b 45 08             	cmp    0x8(%ebp),%eax
c0104257:	0f 82 f2 00 00 00    	jb     c010434f <default_alloc_pages+0x14c>
        {
            int i;
            list_entry_t *len;
            for(i = 0; i < n; i ++)
c010425d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0104264:	eb 7c                	jmp    c01042e2 <default_alloc_pages+0xdf>
c0104266:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104269:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010426c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010426f:	8b 40 04             	mov    0x4(%eax),%eax
            {
                len = list_next(le);
c0104272:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                struct Page *pp = le2page(le, page_link);
c0104275:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104278:	83 e8 0c             	sub    $0xc,%eax
c010427b:	89 45 e0             	mov    %eax,-0x20(%ebp)
                SetPageReserved(pp);
c010427e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104281:	83 c0 04             	add    $0x4,%eax
c0104284:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
c010428b:	89 45 b8             	mov    %eax,-0x48(%ebp)
c010428e:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104291:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0104294:	0f ab 10             	bts    %edx,(%eax)
                ClearPageProperty(pp);
c0104297:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010429a:	83 c0 04             	add    $0x4,%eax
c010429d:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c01042a4:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01042a7:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01042aa:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01042ad:	0f b3 10             	btr    %edx,(%eax)
c01042b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01042b3:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c01042b6:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01042b9:	8b 40 04             	mov    0x4(%eax),%eax
c01042bc:	8b 55 c8             	mov    -0x38(%ebp),%edx
c01042bf:	8b 12                	mov    (%edx),%edx
c01042c1:	89 55 c4             	mov    %edx,-0x3c(%ebp)
c01042c4:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c01042c7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01042ca:	8b 55 c0             	mov    -0x40(%ebp),%edx
c01042cd:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01042d0:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01042d3:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c01042d6:	89 10                	mov    %edx,(%eax)
                list_del(le);   //从free_list中删除le
                le = len;
c01042d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01042db:	89 45 f4             	mov    %eax,-0xc(%ebp)
        struct Page *p = le2page(le, page_link);
        if (p->property >= n) 
        {
            int i;
            list_entry_t *len;
            for(i = 0; i < n; i ++)
c01042de:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
c01042e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01042e5:	3b 45 08             	cmp    0x8(%ebp),%eax
c01042e8:	0f 82 78 ff ff ff    	jb     c0104266 <default_alloc_pages+0x63>
                ClearPageProperty(pp);
                list_del(le);   //从free_list中删除le
                le = len;
            }

            if(p->property > n)
c01042ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01042f1:	8b 40 08             	mov    0x8(%eax),%eax
c01042f4:	3b 45 08             	cmp    0x8(%ebp),%eax
c01042f7:	76 12                	jbe    c010430b <default_alloc_pages+0x108>
                (le2page(le,page_link))->property = p->property - n;
c01042f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01042fc:	8d 50 f4             	lea    -0xc(%eax),%edx
c01042ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104302:	8b 40 08             	mov    0x8(%eax),%eax
c0104305:	2b 45 08             	sub    0x8(%ebp),%eax
c0104308:	89 42 08             	mov    %eax,0x8(%edx)

            ClearPageProperty(p);
c010430b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010430e:	83 c0 04             	add    $0x4,%eax
c0104311:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
c0104318:	89 45 b0             	mov    %eax,-0x50(%ebp)
c010431b:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010431e:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104321:	0f b3 10             	btr    %edx,(%eax)
            SetPageReserved(p);
c0104324:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104327:	83 c0 04             	add    $0x4,%eax
c010432a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0104331:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104334:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104337:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010433a:	0f ab 10             	bts    %edx,(%eax)
            nr_free -= n;
c010433d:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c0104342:	2b 45 08             	sub    0x8(%ebp),%eax
c0104345:	a3 64 89 11 c0       	mov    %eax,0xc0118964

            return p;   //返回分配内存的首地址
c010434a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010434d:	eb 21                	jmp    c0104370 <default_alloc_pages+0x16d>
c010434f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104352:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0104355:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104358:	8b 40 04             	mov    0x4(%eax),%eax
        return NULL;
    }

    list_entry_t *le = &free_list;

    while ((le = list_next(le)) != &free_list) 
c010435b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010435e:	81 7d f4 5c 89 11 c0 	cmpl   $0xc011895c,-0xc(%ebp)
c0104365:	0f 85 da fe ff ff    	jne    c0104245 <default_alloc_pages+0x42>
            nr_free -= n;

            return p;   //返回分配内存的首地址
        }
    }
    return NULL;    //没有找到比n大的块
c010436b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104370:	c9                   	leave  
c0104371:	c3                   	ret    

c0104372 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c0104372:	55                   	push   %ebp
c0104373:	89 e5                	mov    %esp,%ebp
c0104375:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
c0104378:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010437c:	75 19                	jne    c0104397 <default_free_pages+0x25>
c010437e:	68 d8 67 10 c0       	push   $0xc01067d8
c0104383:	68 de 67 10 c0       	push   $0xc01067de
c0104388:	68 83 00 00 00       	push   $0x83
c010438d:	68 f3 67 10 c0       	push   $0xc01067f3
c0104392:	e8 36 c0 ff ff       	call   c01003cd <__panic>
    assert(PageReserved(base));
c0104397:	8b 45 08             	mov    0x8(%ebp),%eax
c010439a:	83 c0 04             	add    $0x4,%eax
c010439d:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
c01043a4:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01043a7:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01043aa:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01043ad:	0f a3 10             	bt     %edx,(%eax)
c01043b0:	19 c0                	sbb    %eax,%eax
c01043b2:	89 45 cc             	mov    %eax,-0x34(%ebp)
    return oldbit != 0;
c01043b5:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c01043b9:	0f 95 c0             	setne  %al
c01043bc:	0f b6 c0             	movzbl %al,%eax
c01043bf:	85 c0                	test   %eax,%eax
c01043c1:	75 19                	jne    c01043dc <default_free_pages+0x6a>
c01043c3:	68 19 68 10 c0       	push   $0xc0106819
c01043c8:	68 de 67 10 c0       	push   $0xc01067de
c01043cd:	68 84 00 00 00       	push   $0x84
c01043d2:	68 f3 67 10 c0       	push   $0xc01067f3
c01043d7:	e8 f1 bf ff ff       	call   c01003cd <__panic>

    list_entry_t *le = &free_list;
c01043dc:	c7 45 f4 5c 89 11 c0 	movl   $0xc011895c,-0xc(%ebp)
    struct Page *p;
    while((le = list_next(le)) != &free_list)
c01043e3:	eb 11                	jmp    c01043f6 <default_free_pages+0x84>
    {
            p = le2page(le, page_link);
c01043e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01043e8:	83 e8 0c             	sub    $0xc,%eax
c01043eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
            if(p > base)
c01043ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01043f1:	3b 45 08             	cmp    0x8(%ebp),%eax
c01043f4:	77 1a                	ja     c0104410 <default_free_pages+0x9e>
c01043f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01043f9:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01043fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01043ff:	8b 40 04             	mov    0x4(%eax),%eax
    assert(n > 0);
    assert(PageReserved(base));

    list_entry_t *le = &free_list;
    struct Page *p;
    while((le = list_next(le)) != &free_list)
c0104402:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104405:	81 7d f4 5c 89 11 c0 	cmpl   $0xc011895c,-0xc(%ebp)
c010440c:	75 d7                	jne    c01043e5 <default_free_pages+0x73>
c010440e:	eb 01                	jmp    c0104411 <default_free_pages+0x9f>
    {
            p = le2page(le, page_link);
            if(p > base)
                    break;  //找到回收位置
c0104410:	90                   	nop
    }

    //插入
    for(p = base; p < base + n; p ++)
c0104411:	8b 45 08             	mov    0x8(%ebp),%eax
c0104414:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104417:	eb 4b                	jmp    c0104464 <default_free_pages+0xf2>
    {
            list_add_before(le, &(p->page_link));
c0104419:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010441c:	8d 50 0c             	lea    0xc(%eax),%edx
c010441f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104422:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104425:	89 55 c8             	mov    %edx,-0x38(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0104428:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010442b:	8b 00                	mov    (%eax),%eax
c010442d:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0104430:	89 55 c4             	mov    %edx,-0x3c(%ebp)
c0104433:	89 45 c0             	mov    %eax,-0x40(%ebp)
c0104436:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104439:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c010443c:	8b 45 bc             	mov    -0x44(%ebp),%eax
c010443f:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0104442:	89 10                	mov    %edx,(%eax)
c0104444:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0104447:	8b 10                	mov    (%eax),%edx
c0104449:	8b 45 c0             	mov    -0x40(%ebp),%eax
c010444c:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c010444f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104452:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0104455:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0104458:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010445b:	8b 55 c0             	mov    -0x40(%ebp),%edx
c010445e:	89 10                	mov    %edx,(%eax)
            if(p > base)
                    break;  //找到回收位置
    }

    //插入
    for(p = base; p < base + n; p ++)
c0104460:	83 45 f0 14          	addl   $0x14,-0x10(%ebp)
c0104464:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104467:	89 d0                	mov    %edx,%eax
c0104469:	c1 e0 02             	shl    $0x2,%eax
c010446c:	01 d0                	add    %edx,%eax
c010446e:	c1 e0 02             	shl    $0x2,%eax
c0104471:	89 c2                	mov    %eax,%edx
c0104473:	8b 45 08             	mov    0x8(%ebp),%eax
c0104476:	01 d0                	add    %edx,%eax
c0104478:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c010447b:	77 9c                	ja     c0104419 <default_free_pages+0xa7>
    {
            list_add_before(le, &(p->page_link));
    }

    //重置pages,flags和refs
    base->flags = 0;
c010447d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104480:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    set_page_ref(base, 0);
c0104487:	83 ec 08             	sub    $0x8,%esp
c010448a:	6a 00                	push   $0x0
c010448c:	ff 75 08             	pushl  0x8(%ebp)
c010448f:	e8 02 fc ff ff       	call   c0104096 <set_page_ref>
c0104494:	83 c4 10             	add    $0x10,%esp
    ClearPageProperty(base);
c0104497:	8b 45 08             	mov    0x8(%ebp),%eax
c010449a:	83 c0 04             	add    $0x4,%eax
c010449d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
c01044a4:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01044a7:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01044aa:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01044ad:	0f b3 10             	btr    %edx,(%eax)
    SetPageProperty(base);
c01044b0:	8b 45 08             	mov    0x8(%ebp),%eax
c01044b3:	83 c0 04             	add    $0x4,%eax
c01044b6:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c01044bd:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01044c0:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01044c3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01044c6:	0f ab 10             	bts    %edx,(%eax)
    base->property = n;
c01044c9:	8b 45 08             	mov    0x8(%ebp),%eax
c01044cc:	8b 55 0c             	mov    0xc(%ebp),%edx
c01044cf:	89 50 08             	mov    %edx,0x8(%eax)
    
    //测试是否可与高位合并
    p = le2page(le, page_link);
c01044d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044d5:	83 e8 0c             	sub    $0xc,%eax
c01044d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((base + n) == p)     //可合并
c01044db:	8b 55 0c             	mov    0xc(%ebp),%edx
c01044de:	89 d0                	mov    %edx,%eax
c01044e0:	c1 e0 02             	shl    $0x2,%eax
c01044e3:	01 d0                	add    %edx,%eax
c01044e5:	c1 e0 02             	shl    $0x2,%eax
c01044e8:	89 c2                	mov    %eax,%edx
c01044ea:	8b 45 08             	mov    0x8(%ebp),%eax
c01044ed:	01 d0                	add    %edx,%eax
c01044ef:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01044f2:	75 1e                	jne    c0104512 <default_free_pages+0x1a0>
    {
            base->property += p->property;
c01044f4:	8b 45 08             	mov    0x8(%ebp),%eax
c01044f7:	8b 50 08             	mov    0x8(%eax),%edx
c01044fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01044fd:	8b 40 08             	mov    0x8(%eax),%eax
c0104500:	01 c2                	add    %eax,%edx
c0104502:	8b 45 08             	mov    0x8(%ebp),%eax
c0104505:	89 50 08             	mov    %edx,0x8(%eax)
            p->property = 0;
c0104508:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010450b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    }

    //测试是否可与低位合并
    le = list_prev((&(base->page_link)));
c0104512:	8b 45 08             	mov    0x8(%ebp),%eax
c0104515:	83 c0 0c             	add    $0xc,%eax
c0104518:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
c010451b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010451e:	8b 00                	mov    (%eax),%eax
c0104520:	89 45 f4             	mov    %eax,-0xc(%ebp)
    p = le2page(le, page_link);
c0104523:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104526:	83 e8 0c             	sub    $0xc,%eax
c0104529:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(le != &free_list && p == base - 1)
c010452c:	81 7d f4 5c 89 11 c0 	cmpl   $0xc011895c,-0xc(%ebp)
c0104533:	74 57                	je     c010458c <default_free_pages+0x21a>
c0104535:	8b 45 08             	mov    0x8(%ebp),%eax
c0104538:	83 e8 14             	sub    $0x14,%eax
c010453b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c010453e:	75 4c                	jne    c010458c <default_free_pages+0x21a>
    {
            while(le != &free_list)
c0104540:	eb 41                	jmp    c0104583 <default_free_pages+0x211>
            {
                    if(p->property)     //可合并
c0104542:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104545:	8b 40 08             	mov    0x8(%eax),%eax
c0104548:	85 c0                	test   %eax,%eax
c010454a:	74 20                	je     c010456c <default_free_pages+0x1fa>
                    {
                            p->property += base->property;
c010454c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010454f:	8b 50 08             	mov    0x8(%eax),%edx
c0104552:	8b 45 08             	mov    0x8(%ebp),%eax
c0104555:	8b 40 08             	mov    0x8(%eax),%eax
c0104558:	01 c2                	add    %eax,%edx
c010455a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010455d:	89 50 08             	mov    %edx,0x8(%eax)
                            base->property = 0;
c0104560:	8b 45 08             	mov    0x8(%ebp),%eax
c0104563:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
                            break;
c010456a:	eb 20                	jmp    c010458c <default_free_pages+0x21a>
c010456c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010456f:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0104572:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104575:	8b 00                	mov    (%eax),%eax
                    }
                    le = list_prev(le);
c0104577:	89 45 f4             	mov    %eax,-0xc(%ebp)
                    p = le2page(le, page_link);
c010457a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010457d:	83 e8 0c             	sub    $0xc,%eax
c0104580:	89 45 f0             	mov    %eax,-0x10(%ebp)
    //测试是否可与低位合并
    le = list_prev((&(base->page_link)));
    p = le2page(le, page_link);
    if(le != &free_list && p == base - 1)
    {
            while(le != &free_list)
c0104583:	81 7d f4 5c 89 11 c0 	cmpl   $0xc011895c,-0xc(%ebp)
c010458a:	75 b6                	jne    c0104542 <default_free_pages+0x1d0>
                    le = list_prev(le);
                    p = le2page(le, page_link);
            }
    }

    nr_free += n;
c010458c:	8b 15 64 89 11 c0    	mov    0xc0118964,%edx
c0104592:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104595:	01 d0                	add    %edx,%eax
c0104597:	a3 64 89 11 c0       	mov    %eax,0xc0118964
    return ;
c010459c:	90                   	nop

}
c010459d:	c9                   	leave  
c010459e:	c3                   	ret    

c010459f <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c010459f:	55                   	push   %ebp
c01045a0:	89 e5                	mov    %esp,%ebp
    return nr_free;
c01045a2:	a1 64 89 11 c0       	mov    0xc0118964,%eax
}
c01045a7:	5d                   	pop    %ebp
c01045a8:	c3                   	ret    

c01045a9 <basic_check>:

static void
basic_check(void) {
c01045a9:	55                   	push   %ebp
c01045aa:	89 e5                	mov    %esp,%ebp
c01045ac:	83 ec 38             	sub    $0x38,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c01045af:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01045b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01045bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01045bf:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c01045c2:	83 ec 0c             	sub    $0xc,%esp
c01045c5:	6a 01                	push   $0x1
c01045c7:	e8 da e5 ff ff       	call   c0102ba6 <alloc_pages>
c01045cc:	83 c4 10             	add    $0x10,%esp
c01045cf:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01045d2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01045d6:	75 19                	jne    c01045f1 <basic_check+0x48>
c01045d8:	68 2c 68 10 c0       	push   $0xc010682c
c01045dd:	68 de 67 10 c0       	push   $0xc01067de
c01045e2:	68 c4 00 00 00       	push   $0xc4
c01045e7:	68 f3 67 10 c0       	push   $0xc01067f3
c01045ec:	e8 dc bd ff ff       	call   c01003cd <__panic>
    assert((p1 = alloc_page()) != NULL);
c01045f1:	83 ec 0c             	sub    $0xc,%esp
c01045f4:	6a 01                	push   $0x1
c01045f6:	e8 ab e5 ff ff       	call   c0102ba6 <alloc_pages>
c01045fb:	83 c4 10             	add    $0x10,%esp
c01045fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104601:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104605:	75 19                	jne    c0104620 <basic_check+0x77>
c0104607:	68 48 68 10 c0       	push   $0xc0106848
c010460c:	68 de 67 10 c0       	push   $0xc01067de
c0104611:	68 c5 00 00 00       	push   $0xc5
c0104616:	68 f3 67 10 c0       	push   $0xc01067f3
c010461b:	e8 ad bd ff ff       	call   c01003cd <__panic>
    assert((p2 = alloc_page()) != NULL);
c0104620:	83 ec 0c             	sub    $0xc,%esp
c0104623:	6a 01                	push   $0x1
c0104625:	e8 7c e5 ff ff       	call   c0102ba6 <alloc_pages>
c010462a:	83 c4 10             	add    $0x10,%esp
c010462d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104630:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104634:	75 19                	jne    c010464f <basic_check+0xa6>
c0104636:	68 64 68 10 c0       	push   $0xc0106864
c010463b:	68 de 67 10 c0       	push   $0xc01067de
c0104640:	68 c6 00 00 00       	push   $0xc6
c0104645:	68 f3 67 10 c0       	push   $0xc01067f3
c010464a:	e8 7e bd ff ff       	call   c01003cd <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c010464f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104652:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0104655:	74 10                	je     c0104667 <basic_check+0xbe>
c0104657:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010465a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010465d:	74 08                	je     c0104667 <basic_check+0xbe>
c010465f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104662:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104665:	75 19                	jne    c0104680 <basic_check+0xd7>
c0104667:	68 80 68 10 c0       	push   $0xc0106880
c010466c:	68 de 67 10 c0       	push   $0xc01067de
c0104671:	68 c8 00 00 00       	push   $0xc8
c0104676:	68 f3 67 10 c0       	push   $0xc01067f3
c010467b:	e8 4d bd ff ff       	call   c01003cd <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0104680:	83 ec 0c             	sub    $0xc,%esp
c0104683:	ff 75 ec             	pushl  -0x14(%ebp)
c0104686:	e8 01 fa ff ff       	call   c010408c <page_ref>
c010468b:	83 c4 10             	add    $0x10,%esp
c010468e:	85 c0                	test   %eax,%eax
c0104690:	75 24                	jne    c01046b6 <basic_check+0x10d>
c0104692:	83 ec 0c             	sub    $0xc,%esp
c0104695:	ff 75 f0             	pushl  -0x10(%ebp)
c0104698:	e8 ef f9 ff ff       	call   c010408c <page_ref>
c010469d:	83 c4 10             	add    $0x10,%esp
c01046a0:	85 c0                	test   %eax,%eax
c01046a2:	75 12                	jne    c01046b6 <basic_check+0x10d>
c01046a4:	83 ec 0c             	sub    $0xc,%esp
c01046a7:	ff 75 f4             	pushl  -0xc(%ebp)
c01046aa:	e8 dd f9 ff ff       	call   c010408c <page_ref>
c01046af:	83 c4 10             	add    $0x10,%esp
c01046b2:	85 c0                	test   %eax,%eax
c01046b4:	74 19                	je     c01046cf <basic_check+0x126>
c01046b6:	68 a4 68 10 c0       	push   $0xc01068a4
c01046bb:	68 de 67 10 c0       	push   $0xc01067de
c01046c0:	68 c9 00 00 00       	push   $0xc9
c01046c5:	68 f3 67 10 c0       	push   $0xc01067f3
c01046ca:	e8 fe bc ff ff       	call   c01003cd <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c01046cf:	83 ec 0c             	sub    $0xc,%esp
c01046d2:	ff 75 ec             	pushl  -0x14(%ebp)
c01046d5:	e8 9f f9 ff ff       	call   c0104079 <page2pa>
c01046da:	83 c4 10             	add    $0x10,%esp
c01046dd:	89 c2                	mov    %eax,%edx
c01046df:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c01046e4:	c1 e0 0c             	shl    $0xc,%eax
c01046e7:	39 c2                	cmp    %eax,%edx
c01046e9:	72 19                	jb     c0104704 <basic_check+0x15b>
c01046eb:	68 e0 68 10 c0       	push   $0xc01068e0
c01046f0:	68 de 67 10 c0       	push   $0xc01067de
c01046f5:	68 cb 00 00 00       	push   $0xcb
c01046fa:	68 f3 67 10 c0       	push   $0xc01067f3
c01046ff:	e8 c9 bc ff ff       	call   c01003cd <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0104704:	83 ec 0c             	sub    $0xc,%esp
c0104707:	ff 75 f0             	pushl  -0x10(%ebp)
c010470a:	e8 6a f9 ff ff       	call   c0104079 <page2pa>
c010470f:	83 c4 10             	add    $0x10,%esp
c0104712:	89 c2                	mov    %eax,%edx
c0104714:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104719:	c1 e0 0c             	shl    $0xc,%eax
c010471c:	39 c2                	cmp    %eax,%edx
c010471e:	72 19                	jb     c0104739 <basic_check+0x190>
c0104720:	68 fd 68 10 c0       	push   $0xc01068fd
c0104725:	68 de 67 10 c0       	push   $0xc01067de
c010472a:	68 cc 00 00 00       	push   $0xcc
c010472f:	68 f3 67 10 c0       	push   $0xc01067f3
c0104734:	e8 94 bc ff ff       	call   c01003cd <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0104739:	83 ec 0c             	sub    $0xc,%esp
c010473c:	ff 75 f4             	pushl  -0xc(%ebp)
c010473f:	e8 35 f9 ff ff       	call   c0104079 <page2pa>
c0104744:	83 c4 10             	add    $0x10,%esp
c0104747:	89 c2                	mov    %eax,%edx
c0104749:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c010474e:	c1 e0 0c             	shl    $0xc,%eax
c0104751:	39 c2                	cmp    %eax,%edx
c0104753:	72 19                	jb     c010476e <basic_check+0x1c5>
c0104755:	68 1a 69 10 c0       	push   $0xc010691a
c010475a:	68 de 67 10 c0       	push   $0xc01067de
c010475f:	68 cd 00 00 00       	push   $0xcd
c0104764:	68 f3 67 10 c0       	push   $0xc01067f3
c0104769:	e8 5f bc ff ff       	call   c01003cd <__panic>

    list_entry_t free_list_store = free_list;
c010476e:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0104773:	8b 15 60 89 11 c0    	mov    0xc0118960,%edx
c0104779:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010477c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010477f:	c7 45 e4 5c 89 11 c0 	movl   $0xc011895c,-0x1c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0104786:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104789:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010478c:	89 50 04             	mov    %edx,0x4(%eax)
c010478f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104792:	8b 50 04             	mov    0x4(%eax),%edx
c0104795:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104798:	89 10                	mov    %edx,(%eax)
c010479a:	c7 45 d8 5c 89 11 c0 	movl   $0xc011895c,-0x28(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c01047a1:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01047a4:	8b 40 04             	mov    0x4(%eax),%eax
c01047a7:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c01047aa:	0f 94 c0             	sete   %al
c01047ad:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c01047b0:	85 c0                	test   %eax,%eax
c01047b2:	75 19                	jne    c01047cd <basic_check+0x224>
c01047b4:	68 37 69 10 c0       	push   $0xc0106937
c01047b9:	68 de 67 10 c0       	push   $0xc01067de
c01047be:	68 d1 00 00 00       	push   $0xd1
c01047c3:	68 f3 67 10 c0       	push   $0xc01067f3
c01047c8:	e8 00 bc ff ff       	call   c01003cd <__panic>

    unsigned int nr_free_store = nr_free;
c01047cd:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c01047d2:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c01047d5:	c7 05 64 89 11 c0 00 	movl   $0x0,0xc0118964
c01047dc:	00 00 00 

    assert(alloc_page() == NULL);
c01047df:	83 ec 0c             	sub    $0xc,%esp
c01047e2:	6a 01                	push   $0x1
c01047e4:	e8 bd e3 ff ff       	call   c0102ba6 <alloc_pages>
c01047e9:	83 c4 10             	add    $0x10,%esp
c01047ec:	85 c0                	test   %eax,%eax
c01047ee:	74 19                	je     c0104809 <basic_check+0x260>
c01047f0:	68 4e 69 10 c0       	push   $0xc010694e
c01047f5:	68 de 67 10 c0       	push   $0xc01067de
c01047fa:	68 d6 00 00 00       	push   $0xd6
c01047ff:	68 f3 67 10 c0       	push   $0xc01067f3
c0104804:	e8 c4 bb ff ff       	call   c01003cd <__panic>

    free_page(p0);
c0104809:	83 ec 08             	sub    $0x8,%esp
c010480c:	6a 01                	push   $0x1
c010480e:	ff 75 ec             	pushl  -0x14(%ebp)
c0104811:	e8 ce e3 ff ff       	call   c0102be4 <free_pages>
c0104816:	83 c4 10             	add    $0x10,%esp
    free_page(p1);
c0104819:	83 ec 08             	sub    $0x8,%esp
c010481c:	6a 01                	push   $0x1
c010481e:	ff 75 f0             	pushl  -0x10(%ebp)
c0104821:	e8 be e3 ff ff       	call   c0102be4 <free_pages>
c0104826:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
c0104829:	83 ec 08             	sub    $0x8,%esp
c010482c:	6a 01                	push   $0x1
c010482e:	ff 75 f4             	pushl  -0xc(%ebp)
c0104831:	e8 ae e3 ff ff       	call   c0102be4 <free_pages>
c0104836:	83 c4 10             	add    $0x10,%esp
    assert(nr_free == 3);
c0104839:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c010483e:	83 f8 03             	cmp    $0x3,%eax
c0104841:	74 19                	je     c010485c <basic_check+0x2b3>
c0104843:	68 63 69 10 c0       	push   $0xc0106963
c0104848:	68 de 67 10 c0       	push   $0xc01067de
c010484d:	68 db 00 00 00       	push   $0xdb
c0104852:	68 f3 67 10 c0       	push   $0xc01067f3
c0104857:	e8 71 bb ff ff       	call   c01003cd <__panic>

    assert((p0 = alloc_page()) != NULL);
c010485c:	83 ec 0c             	sub    $0xc,%esp
c010485f:	6a 01                	push   $0x1
c0104861:	e8 40 e3 ff ff       	call   c0102ba6 <alloc_pages>
c0104866:	83 c4 10             	add    $0x10,%esp
c0104869:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010486c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0104870:	75 19                	jne    c010488b <basic_check+0x2e2>
c0104872:	68 2c 68 10 c0       	push   $0xc010682c
c0104877:	68 de 67 10 c0       	push   $0xc01067de
c010487c:	68 dd 00 00 00       	push   $0xdd
c0104881:	68 f3 67 10 c0       	push   $0xc01067f3
c0104886:	e8 42 bb ff ff       	call   c01003cd <__panic>
    assert((p1 = alloc_page()) != NULL);
c010488b:	83 ec 0c             	sub    $0xc,%esp
c010488e:	6a 01                	push   $0x1
c0104890:	e8 11 e3 ff ff       	call   c0102ba6 <alloc_pages>
c0104895:	83 c4 10             	add    $0x10,%esp
c0104898:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010489b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010489f:	75 19                	jne    c01048ba <basic_check+0x311>
c01048a1:	68 48 68 10 c0       	push   $0xc0106848
c01048a6:	68 de 67 10 c0       	push   $0xc01067de
c01048ab:	68 de 00 00 00       	push   $0xde
c01048b0:	68 f3 67 10 c0       	push   $0xc01067f3
c01048b5:	e8 13 bb ff ff       	call   c01003cd <__panic>
    assert((p2 = alloc_page()) != NULL);
c01048ba:	83 ec 0c             	sub    $0xc,%esp
c01048bd:	6a 01                	push   $0x1
c01048bf:	e8 e2 e2 ff ff       	call   c0102ba6 <alloc_pages>
c01048c4:	83 c4 10             	add    $0x10,%esp
c01048c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01048ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01048ce:	75 19                	jne    c01048e9 <basic_check+0x340>
c01048d0:	68 64 68 10 c0       	push   $0xc0106864
c01048d5:	68 de 67 10 c0       	push   $0xc01067de
c01048da:	68 df 00 00 00       	push   $0xdf
c01048df:	68 f3 67 10 c0       	push   $0xc01067f3
c01048e4:	e8 e4 ba ff ff       	call   c01003cd <__panic>

    assert(alloc_page() == NULL);
c01048e9:	83 ec 0c             	sub    $0xc,%esp
c01048ec:	6a 01                	push   $0x1
c01048ee:	e8 b3 e2 ff ff       	call   c0102ba6 <alloc_pages>
c01048f3:	83 c4 10             	add    $0x10,%esp
c01048f6:	85 c0                	test   %eax,%eax
c01048f8:	74 19                	je     c0104913 <basic_check+0x36a>
c01048fa:	68 4e 69 10 c0       	push   $0xc010694e
c01048ff:	68 de 67 10 c0       	push   $0xc01067de
c0104904:	68 e1 00 00 00       	push   $0xe1
c0104909:	68 f3 67 10 c0       	push   $0xc01067f3
c010490e:	e8 ba ba ff ff       	call   c01003cd <__panic>

    free_page(p0);
c0104913:	83 ec 08             	sub    $0x8,%esp
c0104916:	6a 01                	push   $0x1
c0104918:	ff 75 ec             	pushl  -0x14(%ebp)
c010491b:	e8 c4 e2 ff ff       	call   c0102be4 <free_pages>
c0104920:	83 c4 10             	add    $0x10,%esp
c0104923:	c7 45 e8 5c 89 11 c0 	movl   $0xc011895c,-0x18(%ebp)
c010492a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010492d:	8b 40 04             	mov    0x4(%eax),%eax
c0104930:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0104933:	0f 94 c0             	sete   %al
c0104936:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0104939:	85 c0                	test   %eax,%eax
c010493b:	74 19                	je     c0104956 <basic_check+0x3ad>
c010493d:	68 70 69 10 c0       	push   $0xc0106970
c0104942:	68 de 67 10 c0       	push   $0xc01067de
c0104947:	68 e4 00 00 00       	push   $0xe4
c010494c:	68 f3 67 10 c0       	push   $0xc01067f3
c0104951:	e8 77 ba ff ff       	call   c01003cd <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c0104956:	83 ec 0c             	sub    $0xc,%esp
c0104959:	6a 01                	push   $0x1
c010495b:	e8 46 e2 ff ff       	call   c0102ba6 <alloc_pages>
c0104960:	83 c4 10             	add    $0x10,%esp
c0104963:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104966:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104969:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c010496c:	74 19                	je     c0104987 <basic_check+0x3de>
c010496e:	68 88 69 10 c0       	push   $0xc0106988
c0104973:	68 de 67 10 c0       	push   $0xc01067de
c0104978:	68 e7 00 00 00       	push   $0xe7
c010497d:	68 f3 67 10 c0       	push   $0xc01067f3
c0104982:	e8 46 ba ff ff       	call   c01003cd <__panic>
    assert(alloc_page() == NULL);
c0104987:	83 ec 0c             	sub    $0xc,%esp
c010498a:	6a 01                	push   $0x1
c010498c:	e8 15 e2 ff ff       	call   c0102ba6 <alloc_pages>
c0104991:	83 c4 10             	add    $0x10,%esp
c0104994:	85 c0                	test   %eax,%eax
c0104996:	74 19                	je     c01049b1 <basic_check+0x408>
c0104998:	68 4e 69 10 c0       	push   $0xc010694e
c010499d:	68 de 67 10 c0       	push   $0xc01067de
c01049a2:	68 e8 00 00 00       	push   $0xe8
c01049a7:	68 f3 67 10 c0       	push   $0xc01067f3
c01049ac:	e8 1c ba ff ff       	call   c01003cd <__panic>

    assert(nr_free == 0);
c01049b1:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c01049b6:	85 c0                	test   %eax,%eax
c01049b8:	74 19                	je     c01049d3 <basic_check+0x42a>
c01049ba:	68 a1 69 10 c0       	push   $0xc01069a1
c01049bf:	68 de 67 10 c0       	push   $0xc01067de
c01049c4:	68 ea 00 00 00       	push   $0xea
c01049c9:	68 f3 67 10 c0       	push   $0xc01067f3
c01049ce:	e8 fa b9 ff ff       	call   c01003cd <__panic>
    free_list = free_list_store;
c01049d3:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01049d6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01049d9:	a3 5c 89 11 c0       	mov    %eax,0xc011895c
c01049de:	89 15 60 89 11 c0    	mov    %edx,0xc0118960
    nr_free = nr_free_store;
c01049e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01049e7:	a3 64 89 11 c0       	mov    %eax,0xc0118964

    free_page(p);
c01049ec:	83 ec 08             	sub    $0x8,%esp
c01049ef:	6a 01                	push   $0x1
c01049f1:	ff 75 dc             	pushl  -0x24(%ebp)
c01049f4:	e8 eb e1 ff ff       	call   c0102be4 <free_pages>
c01049f9:	83 c4 10             	add    $0x10,%esp
    free_page(p1);
c01049fc:	83 ec 08             	sub    $0x8,%esp
c01049ff:	6a 01                	push   $0x1
c0104a01:	ff 75 f0             	pushl  -0x10(%ebp)
c0104a04:	e8 db e1 ff ff       	call   c0102be4 <free_pages>
c0104a09:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
c0104a0c:	83 ec 08             	sub    $0x8,%esp
c0104a0f:	6a 01                	push   $0x1
c0104a11:	ff 75 f4             	pushl  -0xc(%ebp)
c0104a14:	e8 cb e1 ff ff       	call   c0102be4 <free_pages>
c0104a19:	83 c4 10             	add    $0x10,%esp
}
c0104a1c:	90                   	nop
c0104a1d:	c9                   	leave  
c0104a1e:	c3                   	ret    

c0104a1f <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c0104a1f:	55                   	push   %ebp
c0104a20:	89 e5                	mov    %esp,%ebp
c0104a22:	81 ec 88 00 00 00    	sub    $0x88,%esp
    int count = 0, total = 0;
c0104a28:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104a2f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0104a36:	c7 45 ec 5c 89 11 c0 	movl   $0xc011895c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0104a3d:	eb 60                	jmp    c0104a9f <default_check+0x80>
        struct Page *p = le2page(le, page_link);
c0104a3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104a42:	83 e8 0c             	sub    $0xc,%eax
c0104a45:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        assert(PageProperty(p));
c0104a48:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104a4b:	83 c0 04             	add    $0x4,%eax
c0104a4e:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
c0104a55:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104a58:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0104a5b:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0104a5e:	0f a3 10             	bt     %edx,(%eax)
c0104a61:	19 c0                	sbb    %eax,%eax
c0104a63:	89 45 a8             	mov    %eax,-0x58(%ebp)
    return oldbit != 0;
c0104a66:	83 7d a8 00          	cmpl   $0x0,-0x58(%ebp)
c0104a6a:	0f 95 c0             	setne  %al
c0104a6d:	0f b6 c0             	movzbl %al,%eax
c0104a70:	85 c0                	test   %eax,%eax
c0104a72:	75 19                	jne    c0104a8d <default_check+0x6e>
c0104a74:	68 ae 69 10 c0       	push   $0xc01069ae
c0104a79:	68 de 67 10 c0       	push   $0xc01067de
c0104a7e:	68 fb 00 00 00       	push   $0xfb
c0104a83:	68 f3 67 10 c0       	push   $0xc01067f3
c0104a88:	e8 40 b9 ff ff       	call   c01003cd <__panic>
        count ++, total += p->property;
c0104a8d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0104a91:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104a94:	8b 50 08             	mov    0x8(%eax),%edx
c0104a97:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a9a:	01 d0                	add    %edx,%eax
c0104a9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104a9f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104aa2:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0104aa5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104aa8:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0104aab:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104aae:	81 7d ec 5c 89 11 c0 	cmpl   $0xc011895c,-0x14(%ebp)
c0104ab5:	75 88                	jne    c0104a3f <default_check+0x20>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c0104ab7:	e8 5d e1 ff ff       	call   c0102c19 <nr_free_pages>
c0104abc:	89 c2                	mov    %eax,%edx
c0104abe:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ac1:	39 c2                	cmp    %eax,%edx
c0104ac3:	74 19                	je     c0104ade <default_check+0xbf>
c0104ac5:	68 be 69 10 c0       	push   $0xc01069be
c0104aca:	68 de 67 10 c0       	push   $0xc01067de
c0104acf:	68 fe 00 00 00       	push   $0xfe
c0104ad4:	68 f3 67 10 c0       	push   $0xc01067f3
c0104ad9:	e8 ef b8 ff ff       	call   c01003cd <__panic>

    basic_check();
c0104ade:	e8 c6 fa ff ff       	call   c01045a9 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0104ae3:	83 ec 0c             	sub    $0xc,%esp
c0104ae6:	6a 05                	push   $0x5
c0104ae8:	e8 b9 e0 ff ff       	call   c0102ba6 <alloc_pages>
c0104aed:	83 c4 10             	add    $0x10,%esp
c0104af0:	89 45 dc             	mov    %eax,-0x24(%ebp)
    assert(p0 != NULL);
c0104af3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0104af7:	75 19                	jne    c0104b12 <default_check+0xf3>
c0104af9:	68 d7 69 10 c0       	push   $0xc01069d7
c0104afe:	68 de 67 10 c0       	push   $0xc01067de
c0104b03:	68 03 01 00 00       	push   $0x103
c0104b08:	68 f3 67 10 c0       	push   $0xc01067f3
c0104b0d:	e8 bb b8 ff ff       	call   c01003cd <__panic>
    assert(!PageProperty(p0));
c0104b12:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104b15:	83 c0 04             	add    $0x4,%eax
c0104b18:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
c0104b1f:	89 45 a4             	mov    %eax,-0x5c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104b22:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0104b25:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0104b28:	0f a3 10             	bt     %edx,(%eax)
c0104b2b:	19 c0                	sbb    %eax,%eax
c0104b2d:	89 45 a0             	mov    %eax,-0x60(%ebp)
    return oldbit != 0;
c0104b30:	83 7d a0 00          	cmpl   $0x0,-0x60(%ebp)
c0104b34:	0f 95 c0             	setne  %al
c0104b37:	0f b6 c0             	movzbl %al,%eax
c0104b3a:	85 c0                	test   %eax,%eax
c0104b3c:	74 19                	je     c0104b57 <default_check+0x138>
c0104b3e:	68 e2 69 10 c0       	push   $0xc01069e2
c0104b43:	68 de 67 10 c0       	push   $0xc01067de
c0104b48:	68 04 01 00 00       	push   $0x104
c0104b4d:	68 f3 67 10 c0       	push   $0xc01067f3
c0104b52:	e8 76 b8 ff ff       	call   c01003cd <__panic>

    list_entry_t free_list_store = free_list;
c0104b57:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0104b5c:	8b 15 60 89 11 c0    	mov    0xc0118960,%edx
c0104b62:	89 45 80             	mov    %eax,-0x80(%ebp)
c0104b65:	89 55 84             	mov    %edx,-0x7c(%ebp)
c0104b68:	c7 45 d0 5c 89 11 c0 	movl   $0xc011895c,-0x30(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0104b6f:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104b72:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104b75:	89 50 04             	mov    %edx,0x4(%eax)
c0104b78:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104b7b:	8b 50 04             	mov    0x4(%eax),%edx
c0104b7e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104b81:	89 10                	mov    %edx,(%eax)
c0104b83:	c7 45 d8 5c 89 11 c0 	movl   $0xc011895c,-0x28(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0104b8a:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104b8d:	8b 40 04             	mov    0x4(%eax),%eax
c0104b90:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0104b93:	0f 94 c0             	sete   %al
c0104b96:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0104b99:	85 c0                	test   %eax,%eax
c0104b9b:	75 19                	jne    c0104bb6 <default_check+0x197>
c0104b9d:	68 37 69 10 c0       	push   $0xc0106937
c0104ba2:	68 de 67 10 c0       	push   $0xc01067de
c0104ba7:	68 08 01 00 00       	push   $0x108
c0104bac:	68 f3 67 10 c0       	push   $0xc01067f3
c0104bb1:	e8 17 b8 ff ff       	call   c01003cd <__panic>
    assert(alloc_page() == NULL);
c0104bb6:	83 ec 0c             	sub    $0xc,%esp
c0104bb9:	6a 01                	push   $0x1
c0104bbb:	e8 e6 df ff ff       	call   c0102ba6 <alloc_pages>
c0104bc0:	83 c4 10             	add    $0x10,%esp
c0104bc3:	85 c0                	test   %eax,%eax
c0104bc5:	74 19                	je     c0104be0 <default_check+0x1c1>
c0104bc7:	68 4e 69 10 c0       	push   $0xc010694e
c0104bcc:	68 de 67 10 c0       	push   $0xc01067de
c0104bd1:	68 09 01 00 00       	push   $0x109
c0104bd6:	68 f3 67 10 c0       	push   $0xc01067f3
c0104bdb:	e8 ed b7 ff ff       	call   c01003cd <__panic>

    unsigned int nr_free_store = nr_free;
c0104be0:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c0104be5:	89 45 cc             	mov    %eax,-0x34(%ebp)
    nr_free = 0;
c0104be8:	c7 05 64 89 11 c0 00 	movl   $0x0,0xc0118964
c0104bef:	00 00 00 

    free_pages(p0 + 2, 3);
c0104bf2:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104bf5:	83 c0 28             	add    $0x28,%eax
c0104bf8:	83 ec 08             	sub    $0x8,%esp
c0104bfb:	6a 03                	push   $0x3
c0104bfd:	50                   	push   %eax
c0104bfe:	e8 e1 df ff ff       	call   c0102be4 <free_pages>
c0104c03:	83 c4 10             	add    $0x10,%esp
    assert(alloc_pages(4) == NULL);
c0104c06:	83 ec 0c             	sub    $0xc,%esp
c0104c09:	6a 04                	push   $0x4
c0104c0b:	e8 96 df ff ff       	call   c0102ba6 <alloc_pages>
c0104c10:	83 c4 10             	add    $0x10,%esp
c0104c13:	85 c0                	test   %eax,%eax
c0104c15:	74 19                	je     c0104c30 <default_check+0x211>
c0104c17:	68 f4 69 10 c0       	push   $0xc01069f4
c0104c1c:	68 de 67 10 c0       	push   $0xc01067de
c0104c21:	68 0f 01 00 00       	push   $0x10f
c0104c26:	68 f3 67 10 c0       	push   $0xc01067f3
c0104c2b:	e8 9d b7 ff ff       	call   c01003cd <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c0104c30:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104c33:	83 c0 28             	add    $0x28,%eax
c0104c36:	83 c0 04             	add    $0x4,%eax
c0104c39:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c0104c40:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104c43:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0104c46:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104c49:	0f a3 10             	bt     %edx,(%eax)
c0104c4c:	19 c0                	sbb    %eax,%eax
c0104c4e:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c0104c51:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c0104c55:	0f 95 c0             	setne  %al
c0104c58:	0f b6 c0             	movzbl %al,%eax
c0104c5b:	85 c0                	test   %eax,%eax
c0104c5d:	74 0e                	je     c0104c6d <default_check+0x24e>
c0104c5f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104c62:	83 c0 28             	add    $0x28,%eax
c0104c65:	8b 40 08             	mov    0x8(%eax),%eax
c0104c68:	83 f8 03             	cmp    $0x3,%eax
c0104c6b:	74 19                	je     c0104c86 <default_check+0x267>
c0104c6d:	68 0c 6a 10 c0       	push   $0xc0106a0c
c0104c72:	68 de 67 10 c0       	push   $0xc01067de
c0104c77:	68 10 01 00 00       	push   $0x110
c0104c7c:	68 f3 67 10 c0       	push   $0xc01067f3
c0104c81:	e8 47 b7 ff ff       	call   c01003cd <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c0104c86:	83 ec 0c             	sub    $0xc,%esp
c0104c89:	6a 03                	push   $0x3
c0104c8b:	e8 16 df ff ff       	call   c0102ba6 <alloc_pages>
c0104c90:	83 c4 10             	add    $0x10,%esp
c0104c93:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c0104c96:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
c0104c9a:	75 19                	jne    c0104cb5 <default_check+0x296>
c0104c9c:	68 38 6a 10 c0       	push   $0xc0106a38
c0104ca1:	68 de 67 10 c0       	push   $0xc01067de
c0104ca6:	68 11 01 00 00       	push   $0x111
c0104cab:	68 f3 67 10 c0       	push   $0xc01067f3
c0104cb0:	e8 18 b7 ff ff       	call   c01003cd <__panic>
    assert(alloc_page() == NULL);
c0104cb5:	83 ec 0c             	sub    $0xc,%esp
c0104cb8:	6a 01                	push   $0x1
c0104cba:	e8 e7 de ff ff       	call   c0102ba6 <alloc_pages>
c0104cbf:	83 c4 10             	add    $0x10,%esp
c0104cc2:	85 c0                	test   %eax,%eax
c0104cc4:	74 19                	je     c0104cdf <default_check+0x2c0>
c0104cc6:	68 4e 69 10 c0       	push   $0xc010694e
c0104ccb:	68 de 67 10 c0       	push   $0xc01067de
c0104cd0:	68 12 01 00 00       	push   $0x112
c0104cd5:	68 f3 67 10 c0       	push   $0xc01067f3
c0104cda:	e8 ee b6 ff ff       	call   c01003cd <__panic>
    assert(p0 + 2 == p1);
c0104cdf:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104ce2:	83 c0 28             	add    $0x28,%eax
c0104ce5:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
c0104ce8:	74 19                	je     c0104d03 <default_check+0x2e4>
c0104cea:	68 56 6a 10 c0       	push   $0xc0106a56
c0104cef:	68 de 67 10 c0       	push   $0xc01067de
c0104cf4:	68 13 01 00 00       	push   $0x113
c0104cf9:	68 f3 67 10 c0       	push   $0xc01067f3
c0104cfe:	e8 ca b6 ff ff       	call   c01003cd <__panic>

    p2 = p0 + 1;
c0104d03:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104d06:	83 c0 14             	add    $0x14,%eax
c0104d09:	89 45 c0             	mov    %eax,-0x40(%ebp)
    free_page(p0);
c0104d0c:	83 ec 08             	sub    $0x8,%esp
c0104d0f:	6a 01                	push   $0x1
c0104d11:	ff 75 dc             	pushl  -0x24(%ebp)
c0104d14:	e8 cb de ff ff       	call   c0102be4 <free_pages>
c0104d19:	83 c4 10             	add    $0x10,%esp
    free_pages(p1, 3);
c0104d1c:	83 ec 08             	sub    $0x8,%esp
c0104d1f:	6a 03                	push   $0x3
c0104d21:	ff 75 c4             	pushl  -0x3c(%ebp)
c0104d24:	e8 bb de ff ff       	call   c0102be4 <free_pages>
c0104d29:	83 c4 10             	add    $0x10,%esp
    assert(PageProperty(p0) && p0->property == 1);
c0104d2c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104d2f:	83 c0 04             	add    $0x4,%eax
c0104d32:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
c0104d39:	89 45 94             	mov    %eax,-0x6c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104d3c:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0104d3f:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0104d42:	0f a3 10             	bt     %edx,(%eax)
c0104d45:	19 c0                	sbb    %eax,%eax
c0104d47:	89 45 90             	mov    %eax,-0x70(%ebp)
    return oldbit != 0;
c0104d4a:	83 7d 90 00          	cmpl   $0x0,-0x70(%ebp)
c0104d4e:	0f 95 c0             	setne  %al
c0104d51:	0f b6 c0             	movzbl %al,%eax
c0104d54:	85 c0                	test   %eax,%eax
c0104d56:	74 0b                	je     c0104d63 <default_check+0x344>
c0104d58:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104d5b:	8b 40 08             	mov    0x8(%eax),%eax
c0104d5e:	83 f8 01             	cmp    $0x1,%eax
c0104d61:	74 19                	je     c0104d7c <default_check+0x35d>
c0104d63:	68 64 6a 10 c0       	push   $0xc0106a64
c0104d68:	68 de 67 10 c0       	push   $0xc01067de
c0104d6d:	68 18 01 00 00       	push   $0x118
c0104d72:	68 f3 67 10 c0       	push   $0xc01067f3
c0104d77:	e8 51 b6 ff ff       	call   c01003cd <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c0104d7c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104d7f:	83 c0 04             	add    $0x4,%eax
c0104d82:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
c0104d89:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104d8c:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0104d8f:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0104d92:	0f a3 10             	bt     %edx,(%eax)
c0104d95:	19 c0                	sbb    %eax,%eax
c0104d97:	89 45 88             	mov    %eax,-0x78(%ebp)
    return oldbit != 0;
c0104d9a:	83 7d 88 00          	cmpl   $0x0,-0x78(%ebp)
c0104d9e:	0f 95 c0             	setne  %al
c0104da1:	0f b6 c0             	movzbl %al,%eax
c0104da4:	85 c0                	test   %eax,%eax
c0104da6:	74 0b                	je     c0104db3 <default_check+0x394>
c0104da8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104dab:	8b 40 08             	mov    0x8(%eax),%eax
c0104dae:	83 f8 03             	cmp    $0x3,%eax
c0104db1:	74 19                	je     c0104dcc <default_check+0x3ad>
c0104db3:	68 8c 6a 10 c0       	push   $0xc0106a8c
c0104db8:	68 de 67 10 c0       	push   $0xc01067de
c0104dbd:	68 19 01 00 00       	push   $0x119
c0104dc2:	68 f3 67 10 c0       	push   $0xc01067f3
c0104dc7:	e8 01 b6 ff ff       	call   c01003cd <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c0104dcc:	83 ec 0c             	sub    $0xc,%esp
c0104dcf:	6a 01                	push   $0x1
c0104dd1:	e8 d0 dd ff ff       	call   c0102ba6 <alloc_pages>
c0104dd6:	83 c4 10             	add    $0x10,%esp
c0104dd9:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104ddc:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0104ddf:	83 e8 14             	sub    $0x14,%eax
c0104de2:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0104de5:	74 19                	je     c0104e00 <default_check+0x3e1>
c0104de7:	68 b2 6a 10 c0       	push   $0xc0106ab2
c0104dec:	68 de 67 10 c0       	push   $0xc01067de
c0104df1:	68 1b 01 00 00       	push   $0x11b
c0104df6:	68 f3 67 10 c0       	push   $0xc01067f3
c0104dfb:	e8 cd b5 ff ff       	call   c01003cd <__panic>
    free_page(p0);
c0104e00:	83 ec 08             	sub    $0x8,%esp
c0104e03:	6a 01                	push   $0x1
c0104e05:	ff 75 dc             	pushl  -0x24(%ebp)
c0104e08:	e8 d7 dd ff ff       	call   c0102be4 <free_pages>
c0104e0d:	83 c4 10             	add    $0x10,%esp
    assert((p0 = alloc_pages(2)) == p2 + 1);
c0104e10:	83 ec 0c             	sub    $0xc,%esp
c0104e13:	6a 02                	push   $0x2
c0104e15:	e8 8c dd ff ff       	call   c0102ba6 <alloc_pages>
c0104e1a:	83 c4 10             	add    $0x10,%esp
c0104e1d:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104e20:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0104e23:	83 c0 14             	add    $0x14,%eax
c0104e26:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0104e29:	74 19                	je     c0104e44 <default_check+0x425>
c0104e2b:	68 d0 6a 10 c0       	push   $0xc0106ad0
c0104e30:	68 de 67 10 c0       	push   $0xc01067de
c0104e35:	68 1d 01 00 00       	push   $0x11d
c0104e3a:	68 f3 67 10 c0       	push   $0xc01067f3
c0104e3f:	e8 89 b5 ff ff       	call   c01003cd <__panic>

    free_pages(p0, 2);
c0104e44:	83 ec 08             	sub    $0x8,%esp
c0104e47:	6a 02                	push   $0x2
c0104e49:	ff 75 dc             	pushl  -0x24(%ebp)
c0104e4c:	e8 93 dd ff ff       	call   c0102be4 <free_pages>
c0104e51:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
c0104e54:	83 ec 08             	sub    $0x8,%esp
c0104e57:	6a 01                	push   $0x1
c0104e59:	ff 75 c0             	pushl  -0x40(%ebp)
c0104e5c:	e8 83 dd ff ff       	call   c0102be4 <free_pages>
c0104e61:	83 c4 10             	add    $0x10,%esp

    assert((p0 = alloc_pages(5)) != NULL);
c0104e64:	83 ec 0c             	sub    $0xc,%esp
c0104e67:	6a 05                	push   $0x5
c0104e69:	e8 38 dd ff ff       	call   c0102ba6 <alloc_pages>
c0104e6e:	83 c4 10             	add    $0x10,%esp
c0104e71:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104e74:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0104e78:	75 19                	jne    c0104e93 <default_check+0x474>
c0104e7a:	68 f0 6a 10 c0       	push   $0xc0106af0
c0104e7f:	68 de 67 10 c0       	push   $0xc01067de
c0104e84:	68 22 01 00 00       	push   $0x122
c0104e89:	68 f3 67 10 c0       	push   $0xc01067f3
c0104e8e:	e8 3a b5 ff ff       	call   c01003cd <__panic>
    assert(alloc_page() == NULL);
c0104e93:	83 ec 0c             	sub    $0xc,%esp
c0104e96:	6a 01                	push   $0x1
c0104e98:	e8 09 dd ff ff       	call   c0102ba6 <alloc_pages>
c0104e9d:	83 c4 10             	add    $0x10,%esp
c0104ea0:	85 c0                	test   %eax,%eax
c0104ea2:	74 19                	je     c0104ebd <default_check+0x49e>
c0104ea4:	68 4e 69 10 c0       	push   $0xc010694e
c0104ea9:	68 de 67 10 c0       	push   $0xc01067de
c0104eae:	68 23 01 00 00       	push   $0x123
c0104eb3:	68 f3 67 10 c0       	push   $0xc01067f3
c0104eb8:	e8 10 b5 ff ff       	call   c01003cd <__panic>

    assert(nr_free == 0);
c0104ebd:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c0104ec2:	85 c0                	test   %eax,%eax
c0104ec4:	74 19                	je     c0104edf <default_check+0x4c0>
c0104ec6:	68 a1 69 10 c0       	push   $0xc01069a1
c0104ecb:	68 de 67 10 c0       	push   $0xc01067de
c0104ed0:	68 25 01 00 00       	push   $0x125
c0104ed5:	68 f3 67 10 c0       	push   $0xc01067f3
c0104eda:	e8 ee b4 ff ff       	call   c01003cd <__panic>
    nr_free = nr_free_store;
c0104edf:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104ee2:	a3 64 89 11 c0       	mov    %eax,0xc0118964

    free_list = free_list_store;
c0104ee7:	8b 45 80             	mov    -0x80(%ebp),%eax
c0104eea:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0104eed:	a3 5c 89 11 c0       	mov    %eax,0xc011895c
c0104ef2:	89 15 60 89 11 c0    	mov    %edx,0xc0118960
    free_pages(p0, 5);
c0104ef8:	83 ec 08             	sub    $0x8,%esp
c0104efb:	6a 05                	push   $0x5
c0104efd:	ff 75 dc             	pushl  -0x24(%ebp)
c0104f00:	e8 df dc ff ff       	call   c0102be4 <free_pages>
c0104f05:	83 c4 10             	add    $0x10,%esp

    le = &free_list;
c0104f08:	c7 45 ec 5c 89 11 c0 	movl   $0xc011895c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0104f0f:	eb 1d                	jmp    c0104f2e <default_check+0x50f>
        struct Page *p = le2page(le, page_link);
c0104f11:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104f14:	83 e8 0c             	sub    $0xc,%eax
c0104f17:	89 45 b4             	mov    %eax,-0x4c(%ebp)
        count --, total -= p->property;
c0104f1a:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0104f1e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104f21:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104f24:	8b 40 08             	mov    0x8(%eax),%eax
c0104f27:	29 c2                	sub    %eax,%edx
c0104f29:	89 d0                	mov    %edx,%eax
c0104f2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104f2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104f31:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0104f34:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104f37:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0104f3a:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104f3d:	81 7d ec 5c 89 11 c0 	cmpl   $0xc011895c,-0x14(%ebp)
c0104f44:	75 cb                	jne    c0104f11 <default_check+0x4f2>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c0104f46:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104f4a:	74 19                	je     c0104f65 <default_check+0x546>
c0104f4c:	68 0e 6b 10 c0       	push   $0xc0106b0e
c0104f51:	68 de 67 10 c0       	push   $0xc01067de
c0104f56:	68 30 01 00 00       	push   $0x130
c0104f5b:	68 f3 67 10 c0       	push   $0xc01067f3
c0104f60:	e8 68 b4 ff ff       	call   c01003cd <__panic>
    assert(total == 0);
c0104f65:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104f69:	74 19                	je     c0104f84 <default_check+0x565>
c0104f6b:	68 19 6b 10 c0       	push   $0xc0106b19
c0104f70:	68 de 67 10 c0       	push   $0xc01067de
c0104f75:	68 31 01 00 00       	push   $0x131
c0104f7a:	68 f3 67 10 c0       	push   $0xc01067f3
c0104f7f:	e8 49 b4 ff ff       	call   c01003cd <__panic>
}
c0104f84:	90                   	nop
c0104f85:	c9                   	leave  
c0104f86:	c3                   	ret    

c0104f87 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c0104f87:	55                   	push   %ebp
c0104f88:	89 e5                	mov    %esp,%ebp
c0104f8a:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0104f8d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c0104f94:	eb 04                	jmp    c0104f9a <strlen+0x13>
        cnt ++;
c0104f96:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c0104f9a:	8b 45 08             	mov    0x8(%ebp),%eax
c0104f9d:	8d 50 01             	lea    0x1(%eax),%edx
c0104fa0:	89 55 08             	mov    %edx,0x8(%ebp)
c0104fa3:	0f b6 00             	movzbl (%eax),%eax
c0104fa6:	84 c0                	test   %al,%al
c0104fa8:	75 ec                	jne    c0104f96 <strlen+0xf>
        cnt ++;
    }
    return cnt;
c0104faa:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0104fad:	c9                   	leave  
c0104fae:	c3                   	ret    

c0104faf <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c0104faf:	55                   	push   %ebp
c0104fb0:	89 e5                	mov    %esp,%ebp
c0104fb2:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0104fb5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0104fbc:	eb 04                	jmp    c0104fc2 <strnlen+0x13>
        cnt ++;
c0104fbe:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c0104fc2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104fc5:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104fc8:	73 10                	jae    c0104fda <strnlen+0x2b>
c0104fca:	8b 45 08             	mov    0x8(%ebp),%eax
c0104fcd:	8d 50 01             	lea    0x1(%eax),%edx
c0104fd0:	89 55 08             	mov    %edx,0x8(%ebp)
c0104fd3:	0f b6 00             	movzbl (%eax),%eax
c0104fd6:	84 c0                	test   %al,%al
c0104fd8:	75 e4                	jne    c0104fbe <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c0104fda:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0104fdd:	c9                   	leave  
c0104fde:	c3                   	ret    

c0104fdf <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c0104fdf:	55                   	push   %ebp
c0104fe0:	89 e5                	mov    %esp,%ebp
c0104fe2:	57                   	push   %edi
c0104fe3:	56                   	push   %esi
c0104fe4:	83 ec 20             	sub    $0x20,%esp
c0104fe7:	8b 45 08             	mov    0x8(%ebp),%eax
c0104fea:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104fed:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104ff0:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c0104ff3:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104ff6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ff9:	89 d1                	mov    %edx,%ecx
c0104ffb:	89 c2                	mov    %eax,%edx
c0104ffd:	89 ce                	mov    %ecx,%esi
c0104fff:	89 d7                	mov    %edx,%edi
c0105001:	ac                   	lods   %ds:(%esi),%al
c0105002:	aa                   	stos   %al,%es:(%edi)
c0105003:	84 c0                	test   %al,%al
c0105005:	75 fa                	jne    c0105001 <strcpy+0x22>
c0105007:	89 fa                	mov    %edi,%edx
c0105009:	89 f1                	mov    %esi,%ecx
c010500b:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c010500e:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0105011:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c0105014:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
c0105017:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0105018:	83 c4 20             	add    $0x20,%esp
c010501b:	5e                   	pop    %esi
c010501c:	5f                   	pop    %edi
c010501d:	5d                   	pop    %ebp
c010501e:	c3                   	ret    

c010501f <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c010501f:	55                   	push   %ebp
c0105020:	89 e5                	mov    %esp,%ebp
c0105022:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0105025:	8b 45 08             	mov    0x8(%ebp),%eax
c0105028:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c010502b:	eb 21                	jmp    c010504e <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c010502d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105030:	0f b6 10             	movzbl (%eax),%edx
c0105033:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105036:	88 10                	mov    %dl,(%eax)
c0105038:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010503b:	0f b6 00             	movzbl (%eax),%eax
c010503e:	84 c0                	test   %al,%al
c0105040:	74 04                	je     c0105046 <strncpy+0x27>
            src ++;
c0105042:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c0105046:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010504a:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c010504e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105052:	75 d9                	jne    c010502d <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c0105054:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105057:	c9                   	leave  
c0105058:	c3                   	ret    

c0105059 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0105059:	55                   	push   %ebp
c010505a:	89 e5                	mov    %esp,%ebp
c010505c:	57                   	push   %edi
c010505d:	56                   	push   %esi
c010505e:	83 ec 20             	sub    $0x20,%esp
c0105061:	8b 45 08             	mov    0x8(%ebp),%eax
c0105064:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105067:	8b 45 0c             	mov    0xc(%ebp),%eax
c010506a:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c010506d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105070:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105073:	89 d1                	mov    %edx,%ecx
c0105075:	89 c2                	mov    %eax,%edx
c0105077:	89 ce                	mov    %ecx,%esi
c0105079:	89 d7                	mov    %edx,%edi
c010507b:	ac                   	lods   %ds:(%esi),%al
c010507c:	ae                   	scas   %es:(%edi),%al
c010507d:	75 08                	jne    c0105087 <strcmp+0x2e>
c010507f:	84 c0                	test   %al,%al
c0105081:	75 f8                	jne    c010507b <strcmp+0x22>
c0105083:	31 c0                	xor    %eax,%eax
c0105085:	eb 04                	jmp    c010508b <strcmp+0x32>
c0105087:	19 c0                	sbb    %eax,%eax
c0105089:	0c 01                	or     $0x1,%al
c010508b:	89 fa                	mov    %edi,%edx
c010508d:	89 f1                	mov    %esi,%ecx
c010508f:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105092:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105095:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c0105098:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
c010509b:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c010509c:	83 c4 20             	add    $0x20,%esp
c010509f:	5e                   	pop    %esi
c01050a0:	5f                   	pop    %edi
c01050a1:	5d                   	pop    %ebp
c01050a2:	c3                   	ret    

c01050a3 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c01050a3:	55                   	push   %ebp
c01050a4:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c01050a6:	eb 0c                	jmp    c01050b4 <strncmp+0x11>
        n --, s1 ++, s2 ++;
c01050a8:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c01050ac:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01050b0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c01050b4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01050b8:	74 1a                	je     c01050d4 <strncmp+0x31>
c01050ba:	8b 45 08             	mov    0x8(%ebp),%eax
c01050bd:	0f b6 00             	movzbl (%eax),%eax
c01050c0:	84 c0                	test   %al,%al
c01050c2:	74 10                	je     c01050d4 <strncmp+0x31>
c01050c4:	8b 45 08             	mov    0x8(%ebp),%eax
c01050c7:	0f b6 10             	movzbl (%eax),%edx
c01050ca:	8b 45 0c             	mov    0xc(%ebp),%eax
c01050cd:	0f b6 00             	movzbl (%eax),%eax
c01050d0:	38 c2                	cmp    %al,%dl
c01050d2:	74 d4                	je     c01050a8 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c01050d4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01050d8:	74 18                	je     c01050f2 <strncmp+0x4f>
c01050da:	8b 45 08             	mov    0x8(%ebp),%eax
c01050dd:	0f b6 00             	movzbl (%eax),%eax
c01050e0:	0f b6 d0             	movzbl %al,%edx
c01050e3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01050e6:	0f b6 00             	movzbl (%eax),%eax
c01050e9:	0f b6 c0             	movzbl %al,%eax
c01050ec:	29 c2                	sub    %eax,%edx
c01050ee:	89 d0                	mov    %edx,%eax
c01050f0:	eb 05                	jmp    c01050f7 <strncmp+0x54>
c01050f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01050f7:	5d                   	pop    %ebp
c01050f8:	c3                   	ret    

c01050f9 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c01050f9:	55                   	push   %ebp
c01050fa:	89 e5                	mov    %esp,%ebp
c01050fc:	83 ec 04             	sub    $0x4,%esp
c01050ff:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105102:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105105:	eb 14                	jmp    c010511b <strchr+0x22>
        if (*s == c) {
c0105107:	8b 45 08             	mov    0x8(%ebp),%eax
c010510a:	0f b6 00             	movzbl (%eax),%eax
c010510d:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105110:	75 05                	jne    c0105117 <strchr+0x1e>
            return (char *)s;
c0105112:	8b 45 08             	mov    0x8(%ebp),%eax
c0105115:	eb 13                	jmp    c010512a <strchr+0x31>
        }
        s ++;
c0105117:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c010511b:	8b 45 08             	mov    0x8(%ebp),%eax
c010511e:	0f b6 00             	movzbl (%eax),%eax
c0105121:	84 c0                	test   %al,%al
c0105123:	75 e2                	jne    c0105107 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c0105125:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010512a:	c9                   	leave  
c010512b:	c3                   	ret    

c010512c <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c010512c:	55                   	push   %ebp
c010512d:	89 e5                	mov    %esp,%ebp
c010512f:	83 ec 04             	sub    $0x4,%esp
c0105132:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105135:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105138:	eb 0f                	jmp    c0105149 <strfind+0x1d>
        if (*s == c) {
c010513a:	8b 45 08             	mov    0x8(%ebp),%eax
c010513d:	0f b6 00             	movzbl (%eax),%eax
c0105140:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105143:	74 10                	je     c0105155 <strfind+0x29>
            break;
        }
        s ++;
c0105145:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c0105149:	8b 45 08             	mov    0x8(%ebp),%eax
c010514c:	0f b6 00             	movzbl (%eax),%eax
c010514f:	84 c0                	test   %al,%al
c0105151:	75 e7                	jne    c010513a <strfind+0xe>
c0105153:	eb 01                	jmp    c0105156 <strfind+0x2a>
        if (*s == c) {
            break;
c0105155:	90                   	nop
        }
        s ++;
    }
    return (char *)s;
c0105156:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105159:	c9                   	leave  
c010515a:	c3                   	ret    

c010515b <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c010515b:	55                   	push   %ebp
c010515c:	89 e5                	mov    %esp,%ebp
c010515e:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0105161:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0105168:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c010516f:	eb 04                	jmp    c0105175 <strtol+0x1a>
        s ++;
c0105171:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105175:	8b 45 08             	mov    0x8(%ebp),%eax
c0105178:	0f b6 00             	movzbl (%eax),%eax
c010517b:	3c 20                	cmp    $0x20,%al
c010517d:	74 f2                	je     c0105171 <strtol+0x16>
c010517f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105182:	0f b6 00             	movzbl (%eax),%eax
c0105185:	3c 09                	cmp    $0x9,%al
c0105187:	74 e8                	je     c0105171 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c0105189:	8b 45 08             	mov    0x8(%ebp),%eax
c010518c:	0f b6 00             	movzbl (%eax),%eax
c010518f:	3c 2b                	cmp    $0x2b,%al
c0105191:	75 06                	jne    c0105199 <strtol+0x3e>
        s ++;
c0105193:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105197:	eb 15                	jmp    c01051ae <strtol+0x53>
    }
    else if (*s == '-') {
c0105199:	8b 45 08             	mov    0x8(%ebp),%eax
c010519c:	0f b6 00             	movzbl (%eax),%eax
c010519f:	3c 2d                	cmp    $0x2d,%al
c01051a1:	75 0b                	jne    c01051ae <strtol+0x53>
        s ++, neg = 1;
c01051a3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01051a7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c01051ae:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01051b2:	74 06                	je     c01051ba <strtol+0x5f>
c01051b4:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c01051b8:	75 24                	jne    c01051de <strtol+0x83>
c01051ba:	8b 45 08             	mov    0x8(%ebp),%eax
c01051bd:	0f b6 00             	movzbl (%eax),%eax
c01051c0:	3c 30                	cmp    $0x30,%al
c01051c2:	75 1a                	jne    c01051de <strtol+0x83>
c01051c4:	8b 45 08             	mov    0x8(%ebp),%eax
c01051c7:	83 c0 01             	add    $0x1,%eax
c01051ca:	0f b6 00             	movzbl (%eax),%eax
c01051cd:	3c 78                	cmp    $0x78,%al
c01051cf:	75 0d                	jne    c01051de <strtol+0x83>
        s += 2, base = 16;
c01051d1:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c01051d5:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c01051dc:	eb 2a                	jmp    c0105208 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c01051de:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01051e2:	75 17                	jne    c01051fb <strtol+0xa0>
c01051e4:	8b 45 08             	mov    0x8(%ebp),%eax
c01051e7:	0f b6 00             	movzbl (%eax),%eax
c01051ea:	3c 30                	cmp    $0x30,%al
c01051ec:	75 0d                	jne    c01051fb <strtol+0xa0>
        s ++, base = 8;
c01051ee:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01051f2:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c01051f9:	eb 0d                	jmp    c0105208 <strtol+0xad>
    }
    else if (base == 0) {
c01051fb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01051ff:	75 07                	jne    c0105208 <strtol+0xad>
        base = 10;
c0105201:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0105208:	8b 45 08             	mov    0x8(%ebp),%eax
c010520b:	0f b6 00             	movzbl (%eax),%eax
c010520e:	3c 2f                	cmp    $0x2f,%al
c0105210:	7e 1b                	jle    c010522d <strtol+0xd2>
c0105212:	8b 45 08             	mov    0x8(%ebp),%eax
c0105215:	0f b6 00             	movzbl (%eax),%eax
c0105218:	3c 39                	cmp    $0x39,%al
c010521a:	7f 11                	jg     c010522d <strtol+0xd2>
            dig = *s - '0';
c010521c:	8b 45 08             	mov    0x8(%ebp),%eax
c010521f:	0f b6 00             	movzbl (%eax),%eax
c0105222:	0f be c0             	movsbl %al,%eax
c0105225:	83 e8 30             	sub    $0x30,%eax
c0105228:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010522b:	eb 48                	jmp    c0105275 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c010522d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105230:	0f b6 00             	movzbl (%eax),%eax
c0105233:	3c 60                	cmp    $0x60,%al
c0105235:	7e 1b                	jle    c0105252 <strtol+0xf7>
c0105237:	8b 45 08             	mov    0x8(%ebp),%eax
c010523a:	0f b6 00             	movzbl (%eax),%eax
c010523d:	3c 7a                	cmp    $0x7a,%al
c010523f:	7f 11                	jg     c0105252 <strtol+0xf7>
            dig = *s - 'a' + 10;
c0105241:	8b 45 08             	mov    0x8(%ebp),%eax
c0105244:	0f b6 00             	movzbl (%eax),%eax
c0105247:	0f be c0             	movsbl %al,%eax
c010524a:	83 e8 57             	sub    $0x57,%eax
c010524d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105250:	eb 23                	jmp    c0105275 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0105252:	8b 45 08             	mov    0x8(%ebp),%eax
c0105255:	0f b6 00             	movzbl (%eax),%eax
c0105258:	3c 40                	cmp    $0x40,%al
c010525a:	7e 3c                	jle    c0105298 <strtol+0x13d>
c010525c:	8b 45 08             	mov    0x8(%ebp),%eax
c010525f:	0f b6 00             	movzbl (%eax),%eax
c0105262:	3c 5a                	cmp    $0x5a,%al
c0105264:	7f 32                	jg     c0105298 <strtol+0x13d>
            dig = *s - 'A' + 10;
c0105266:	8b 45 08             	mov    0x8(%ebp),%eax
c0105269:	0f b6 00             	movzbl (%eax),%eax
c010526c:	0f be c0             	movsbl %al,%eax
c010526f:	83 e8 37             	sub    $0x37,%eax
c0105272:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0105275:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105278:	3b 45 10             	cmp    0x10(%ebp),%eax
c010527b:	7d 1a                	jge    c0105297 <strtol+0x13c>
            break;
        }
        s ++, val = (val * base) + dig;
c010527d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105281:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105284:	0f af 45 10          	imul   0x10(%ebp),%eax
c0105288:	89 c2                	mov    %eax,%edx
c010528a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010528d:	01 d0                	add    %edx,%eax
c010528f:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c0105292:	e9 71 ff ff ff       	jmp    c0105208 <strtol+0xad>
        }
        else {
            break;
        }
        if (dig >= base) {
            break;
c0105297:	90                   	nop
        }
        s ++, val = (val * base) + dig;
        // we don't properly detect overflow!
    }

    if (endptr) {
c0105298:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010529c:	74 08                	je     c01052a6 <strtol+0x14b>
        *endptr = (char *) s;
c010529e:	8b 45 0c             	mov    0xc(%ebp),%eax
c01052a1:	8b 55 08             	mov    0x8(%ebp),%edx
c01052a4:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c01052a6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c01052aa:	74 07                	je     c01052b3 <strtol+0x158>
c01052ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01052af:	f7 d8                	neg    %eax
c01052b1:	eb 03                	jmp    c01052b6 <strtol+0x15b>
c01052b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c01052b6:	c9                   	leave  
c01052b7:	c3                   	ret    

c01052b8 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c01052b8:	55                   	push   %ebp
c01052b9:	89 e5                	mov    %esp,%ebp
c01052bb:	57                   	push   %edi
c01052bc:	83 ec 24             	sub    $0x24,%esp
c01052bf:	8b 45 0c             	mov    0xc(%ebp),%eax
c01052c2:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c01052c5:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c01052c9:	8b 55 08             	mov    0x8(%ebp),%edx
c01052cc:	89 55 f8             	mov    %edx,-0x8(%ebp)
c01052cf:	88 45 f7             	mov    %al,-0x9(%ebp)
c01052d2:	8b 45 10             	mov    0x10(%ebp),%eax
c01052d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c01052d8:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c01052db:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c01052df:	8b 55 f8             	mov    -0x8(%ebp),%edx
c01052e2:	89 d7                	mov    %edx,%edi
c01052e4:	f3 aa                	rep stos %al,%es:(%edi)
c01052e6:	89 fa                	mov    %edi,%edx
c01052e8:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c01052eb:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c01052ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01052f1:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c01052f2:	83 c4 24             	add    $0x24,%esp
c01052f5:	5f                   	pop    %edi
c01052f6:	5d                   	pop    %ebp
c01052f7:	c3                   	ret    

c01052f8 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c01052f8:	55                   	push   %ebp
c01052f9:	89 e5                	mov    %esp,%ebp
c01052fb:	57                   	push   %edi
c01052fc:	56                   	push   %esi
c01052fd:	53                   	push   %ebx
c01052fe:	83 ec 30             	sub    $0x30,%esp
c0105301:	8b 45 08             	mov    0x8(%ebp),%eax
c0105304:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105307:	8b 45 0c             	mov    0xc(%ebp),%eax
c010530a:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010530d:	8b 45 10             	mov    0x10(%ebp),%eax
c0105310:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0105313:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105316:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0105319:	73 42                	jae    c010535d <memmove+0x65>
c010531b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010531e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105321:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105324:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105327:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010532a:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c010532d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105330:	c1 e8 02             	shr    $0x2,%eax
c0105333:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0105335:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105338:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010533b:	89 d7                	mov    %edx,%edi
c010533d:	89 c6                	mov    %eax,%esi
c010533f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105341:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105344:	83 e1 03             	and    $0x3,%ecx
c0105347:	74 02                	je     c010534b <memmove+0x53>
c0105349:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c010534b:	89 f0                	mov    %esi,%eax
c010534d:	89 fa                	mov    %edi,%edx
c010534f:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0105352:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0105355:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0105358:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
c010535b:	eb 36                	jmp    c0105393 <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c010535d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105360:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105363:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105366:	01 c2                	add    %eax,%edx
c0105368:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010536b:	8d 48 ff             	lea    -0x1(%eax),%ecx
c010536e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105371:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c0105374:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105377:	89 c1                	mov    %eax,%ecx
c0105379:	89 d8                	mov    %ebx,%eax
c010537b:	89 d6                	mov    %edx,%esi
c010537d:	89 c7                	mov    %eax,%edi
c010537f:	fd                   	std    
c0105380:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105382:	fc                   	cld    
c0105383:	89 f8                	mov    %edi,%eax
c0105385:	89 f2                	mov    %esi,%edx
c0105387:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c010538a:	89 55 c8             	mov    %edx,-0x38(%ebp)
c010538d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c0105390:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0105393:	83 c4 30             	add    $0x30,%esp
c0105396:	5b                   	pop    %ebx
c0105397:	5e                   	pop    %esi
c0105398:	5f                   	pop    %edi
c0105399:	5d                   	pop    %ebp
c010539a:	c3                   	ret    

c010539b <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c010539b:	55                   	push   %ebp
c010539c:	89 e5                	mov    %esp,%ebp
c010539e:	57                   	push   %edi
c010539f:	56                   	push   %esi
c01053a0:	83 ec 20             	sub    $0x20,%esp
c01053a3:	8b 45 08             	mov    0x8(%ebp),%eax
c01053a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01053a9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01053ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01053af:	8b 45 10             	mov    0x10(%ebp),%eax
c01053b2:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c01053b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01053b8:	c1 e8 02             	shr    $0x2,%eax
c01053bb:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c01053bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01053c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01053c3:	89 d7                	mov    %edx,%edi
c01053c5:	89 c6                	mov    %eax,%esi
c01053c7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c01053c9:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c01053cc:	83 e1 03             	and    $0x3,%ecx
c01053cf:	74 02                	je     c01053d3 <memcpy+0x38>
c01053d1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c01053d3:	89 f0                	mov    %esi,%eax
c01053d5:	89 fa                	mov    %edi,%edx
c01053d7:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c01053da:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c01053dd:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c01053e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
c01053e3:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c01053e4:	83 c4 20             	add    $0x20,%esp
c01053e7:	5e                   	pop    %esi
c01053e8:	5f                   	pop    %edi
c01053e9:	5d                   	pop    %ebp
c01053ea:	c3                   	ret    

c01053eb <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c01053eb:	55                   	push   %ebp
c01053ec:	89 e5                	mov    %esp,%ebp
c01053ee:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c01053f1:	8b 45 08             	mov    0x8(%ebp),%eax
c01053f4:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c01053f7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01053fa:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c01053fd:	eb 30                	jmp    c010542f <memcmp+0x44>
        if (*s1 != *s2) {
c01053ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105402:	0f b6 10             	movzbl (%eax),%edx
c0105405:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105408:	0f b6 00             	movzbl (%eax),%eax
c010540b:	38 c2                	cmp    %al,%dl
c010540d:	74 18                	je     c0105427 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c010540f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105412:	0f b6 00             	movzbl (%eax),%eax
c0105415:	0f b6 d0             	movzbl %al,%edx
c0105418:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010541b:	0f b6 00             	movzbl (%eax),%eax
c010541e:	0f b6 c0             	movzbl %al,%eax
c0105421:	29 c2                	sub    %eax,%edx
c0105423:	89 d0                	mov    %edx,%eax
c0105425:	eb 1a                	jmp    c0105441 <memcmp+0x56>
        }
        s1 ++, s2 ++;
c0105427:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010542b:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c010542f:	8b 45 10             	mov    0x10(%ebp),%eax
c0105432:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105435:	89 55 10             	mov    %edx,0x10(%ebp)
c0105438:	85 c0                	test   %eax,%eax
c010543a:	75 c3                	jne    c01053ff <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c010543c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105441:	c9                   	leave  
c0105442:	c3                   	ret    

c0105443 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c0105443:	55                   	push   %ebp
c0105444:	89 e5                	mov    %esp,%ebp
c0105446:	83 ec 38             	sub    $0x38,%esp
c0105449:	8b 45 10             	mov    0x10(%ebp),%eax
c010544c:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010544f:	8b 45 14             	mov    0x14(%ebp),%eax
c0105452:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c0105455:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105458:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010545b:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010545e:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c0105461:	8b 45 18             	mov    0x18(%ebp),%eax
c0105464:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105467:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010546a:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010546d:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105470:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0105473:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105476:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105479:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010547d:	74 1c                	je     c010549b <printnum+0x58>
c010547f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105482:	ba 00 00 00 00       	mov    $0x0,%edx
c0105487:	f7 75 e4             	divl   -0x1c(%ebp)
c010548a:	89 55 f4             	mov    %edx,-0xc(%ebp)
c010548d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105490:	ba 00 00 00 00       	mov    $0x0,%edx
c0105495:	f7 75 e4             	divl   -0x1c(%ebp)
c0105498:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010549b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010549e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01054a1:	f7 75 e4             	divl   -0x1c(%ebp)
c01054a4:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01054a7:	89 55 dc             	mov    %edx,-0x24(%ebp)
c01054aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01054ad:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01054b0:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01054b3:	89 55 ec             	mov    %edx,-0x14(%ebp)
c01054b6:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01054b9:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c01054bc:	8b 45 18             	mov    0x18(%ebp),%eax
c01054bf:	ba 00 00 00 00       	mov    $0x0,%edx
c01054c4:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01054c7:	77 41                	ja     c010550a <printnum+0xc7>
c01054c9:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01054cc:	72 05                	jb     c01054d3 <printnum+0x90>
c01054ce:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c01054d1:	77 37                	ja     c010550a <printnum+0xc7>
        printnum(putch, putdat, result, base, width - 1, padc);
c01054d3:	8b 45 1c             	mov    0x1c(%ebp),%eax
c01054d6:	83 e8 01             	sub    $0x1,%eax
c01054d9:	83 ec 04             	sub    $0x4,%esp
c01054dc:	ff 75 20             	pushl  0x20(%ebp)
c01054df:	50                   	push   %eax
c01054e0:	ff 75 18             	pushl  0x18(%ebp)
c01054e3:	ff 75 ec             	pushl  -0x14(%ebp)
c01054e6:	ff 75 e8             	pushl  -0x18(%ebp)
c01054e9:	ff 75 0c             	pushl  0xc(%ebp)
c01054ec:	ff 75 08             	pushl  0x8(%ebp)
c01054ef:	e8 4f ff ff ff       	call   c0105443 <printnum>
c01054f4:	83 c4 20             	add    $0x20,%esp
c01054f7:	eb 1b                	jmp    c0105514 <printnum+0xd1>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c01054f9:	83 ec 08             	sub    $0x8,%esp
c01054fc:	ff 75 0c             	pushl  0xc(%ebp)
c01054ff:	ff 75 20             	pushl  0x20(%ebp)
c0105502:	8b 45 08             	mov    0x8(%ebp),%eax
c0105505:	ff d0                	call   *%eax
c0105507:	83 c4 10             	add    $0x10,%esp
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c010550a:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c010550e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0105512:	7f e5                	jg     c01054f9 <printnum+0xb6>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c0105514:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105517:	05 d4 6b 10 c0       	add    $0xc0106bd4,%eax
c010551c:	0f b6 00             	movzbl (%eax),%eax
c010551f:	0f be c0             	movsbl %al,%eax
c0105522:	83 ec 08             	sub    $0x8,%esp
c0105525:	ff 75 0c             	pushl  0xc(%ebp)
c0105528:	50                   	push   %eax
c0105529:	8b 45 08             	mov    0x8(%ebp),%eax
c010552c:	ff d0                	call   *%eax
c010552e:	83 c4 10             	add    $0x10,%esp
}
c0105531:	90                   	nop
c0105532:	c9                   	leave  
c0105533:	c3                   	ret    

c0105534 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c0105534:	55                   	push   %ebp
c0105535:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0105537:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c010553b:	7e 14                	jle    c0105551 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c010553d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105540:	8b 00                	mov    (%eax),%eax
c0105542:	8d 48 08             	lea    0x8(%eax),%ecx
c0105545:	8b 55 08             	mov    0x8(%ebp),%edx
c0105548:	89 0a                	mov    %ecx,(%edx)
c010554a:	8b 50 04             	mov    0x4(%eax),%edx
c010554d:	8b 00                	mov    (%eax),%eax
c010554f:	eb 30                	jmp    c0105581 <getuint+0x4d>
    }
    else if (lflag) {
c0105551:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105555:	74 16                	je     c010556d <getuint+0x39>
        return va_arg(*ap, unsigned long);
c0105557:	8b 45 08             	mov    0x8(%ebp),%eax
c010555a:	8b 00                	mov    (%eax),%eax
c010555c:	8d 48 04             	lea    0x4(%eax),%ecx
c010555f:	8b 55 08             	mov    0x8(%ebp),%edx
c0105562:	89 0a                	mov    %ecx,(%edx)
c0105564:	8b 00                	mov    (%eax),%eax
c0105566:	ba 00 00 00 00       	mov    $0x0,%edx
c010556b:	eb 14                	jmp    c0105581 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c010556d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105570:	8b 00                	mov    (%eax),%eax
c0105572:	8d 48 04             	lea    0x4(%eax),%ecx
c0105575:	8b 55 08             	mov    0x8(%ebp),%edx
c0105578:	89 0a                	mov    %ecx,(%edx)
c010557a:	8b 00                	mov    (%eax),%eax
c010557c:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c0105581:	5d                   	pop    %ebp
c0105582:	c3                   	ret    

c0105583 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c0105583:	55                   	push   %ebp
c0105584:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0105586:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c010558a:	7e 14                	jle    c01055a0 <getint+0x1d>
        return va_arg(*ap, long long);
c010558c:	8b 45 08             	mov    0x8(%ebp),%eax
c010558f:	8b 00                	mov    (%eax),%eax
c0105591:	8d 48 08             	lea    0x8(%eax),%ecx
c0105594:	8b 55 08             	mov    0x8(%ebp),%edx
c0105597:	89 0a                	mov    %ecx,(%edx)
c0105599:	8b 50 04             	mov    0x4(%eax),%edx
c010559c:	8b 00                	mov    (%eax),%eax
c010559e:	eb 28                	jmp    c01055c8 <getint+0x45>
    }
    else if (lflag) {
c01055a0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01055a4:	74 12                	je     c01055b8 <getint+0x35>
        return va_arg(*ap, long);
c01055a6:	8b 45 08             	mov    0x8(%ebp),%eax
c01055a9:	8b 00                	mov    (%eax),%eax
c01055ab:	8d 48 04             	lea    0x4(%eax),%ecx
c01055ae:	8b 55 08             	mov    0x8(%ebp),%edx
c01055b1:	89 0a                	mov    %ecx,(%edx)
c01055b3:	8b 00                	mov    (%eax),%eax
c01055b5:	99                   	cltd   
c01055b6:	eb 10                	jmp    c01055c8 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c01055b8:	8b 45 08             	mov    0x8(%ebp),%eax
c01055bb:	8b 00                	mov    (%eax),%eax
c01055bd:	8d 48 04             	lea    0x4(%eax),%ecx
c01055c0:	8b 55 08             	mov    0x8(%ebp),%edx
c01055c3:	89 0a                	mov    %ecx,(%edx)
c01055c5:	8b 00                	mov    (%eax),%eax
c01055c7:	99                   	cltd   
    }
}
c01055c8:	5d                   	pop    %ebp
c01055c9:	c3                   	ret    

c01055ca <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c01055ca:	55                   	push   %ebp
c01055cb:	89 e5                	mov    %esp,%ebp
c01055cd:	83 ec 18             	sub    $0x18,%esp
    va_list ap;

    va_start(ap, fmt);
c01055d0:	8d 45 14             	lea    0x14(%ebp),%eax
c01055d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c01055d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01055d9:	50                   	push   %eax
c01055da:	ff 75 10             	pushl  0x10(%ebp)
c01055dd:	ff 75 0c             	pushl  0xc(%ebp)
c01055e0:	ff 75 08             	pushl  0x8(%ebp)
c01055e3:	e8 06 00 00 00       	call   c01055ee <vprintfmt>
c01055e8:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
c01055eb:	90                   	nop
c01055ec:	c9                   	leave  
c01055ed:	c3                   	ret    

c01055ee <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c01055ee:	55                   	push   %ebp
c01055ef:	89 e5                	mov    %esp,%ebp
c01055f1:	56                   	push   %esi
c01055f2:	53                   	push   %ebx
c01055f3:	83 ec 20             	sub    $0x20,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01055f6:	eb 17                	jmp    c010560f <vprintfmt+0x21>
            if (ch == '\0') {
c01055f8:	85 db                	test   %ebx,%ebx
c01055fa:	0f 84 8e 03 00 00    	je     c010598e <vprintfmt+0x3a0>
                return;
            }
            putch(ch, putdat);
c0105600:	83 ec 08             	sub    $0x8,%esp
c0105603:	ff 75 0c             	pushl  0xc(%ebp)
c0105606:	53                   	push   %ebx
c0105607:	8b 45 08             	mov    0x8(%ebp),%eax
c010560a:	ff d0                	call   *%eax
c010560c:	83 c4 10             	add    $0x10,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c010560f:	8b 45 10             	mov    0x10(%ebp),%eax
c0105612:	8d 50 01             	lea    0x1(%eax),%edx
c0105615:	89 55 10             	mov    %edx,0x10(%ebp)
c0105618:	0f b6 00             	movzbl (%eax),%eax
c010561b:	0f b6 d8             	movzbl %al,%ebx
c010561e:	83 fb 25             	cmp    $0x25,%ebx
c0105621:	75 d5                	jne    c01055f8 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c0105623:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c0105627:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c010562e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105631:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c0105634:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010563b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010563e:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c0105641:	8b 45 10             	mov    0x10(%ebp),%eax
c0105644:	8d 50 01             	lea    0x1(%eax),%edx
c0105647:	89 55 10             	mov    %edx,0x10(%ebp)
c010564a:	0f b6 00             	movzbl (%eax),%eax
c010564d:	0f b6 d8             	movzbl %al,%ebx
c0105650:	8d 43 dd             	lea    -0x23(%ebx),%eax
c0105653:	83 f8 55             	cmp    $0x55,%eax
c0105656:	0f 87 05 03 00 00    	ja     c0105961 <vprintfmt+0x373>
c010565c:	8b 04 85 f8 6b 10 c0 	mov    -0x3fef9408(,%eax,4),%eax
c0105663:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c0105665:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c0105669:	eb d6                	jmp    c0105641 <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c010566b:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c010566f:	eb d0                	jmp    c0105641 <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0105671:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c0105678:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010567b:	89 d0                	mov    %edx,%eax
c010567d:	c1 e0 02             	shl    $0x2,%eax
c0105680:	01 d0                	add    %edx,%eax
c0105682:	01 c0                	add    %eax,%eax
c0105684:	01 d8                	add    %ebx,%eax
c0105686:	83 e8 30             	sub    $0x30,%eax
c0105689:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c010568c:	8b 45 10             	mov    0x10(%ebp),%eax
c010568f:	0f b6 00             	movzbl (%eax),%eax
c0105692:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c0105695:	83 fb 2f             	cmp    $0x2f,%ebx
c0105698:	7e 39                	jle    c01056d3 <vprintfmt+0xe5>
c010569a:	83 fb 39             	cmp    $0x39,%ebx
c010569d:	7f 34                	jg     c01056d3 <vprintfmt+0xe5>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c010569f:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c01056a3:	eb d3                	jmp    c0105678 <vprintfmt+0x8a>
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
c01056a5:	8b 45 14             	mov    0x14(%ebp),%eax
c01056a8:	8d 50 04             	lea    0x4(%eax),%edx
c01056ab:	89 55 14             	mov    %edx,0x14(%ebp)
c01056ae:	8b 00                	mov    (%eax),%eax
c01056b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c01056b3:	eb 1f                	jmp    c01056d4 <vprintfmt+0xe6>

        case '.':
            if (width < 0)
c01056b5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01056b9:	79 86                	jns    c0105641 <vprintfmt+0x53>
                width = 0;
c01056bb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c01056c2:	e9 7a ff ff ff       	jmp    c0105641 <vprintfmt+0x53>

        case '#':
            altflag = 1;
c01056c7:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c01056ce:	e9 6e ff ff ff       	jmp    c0105641 <vprintfmt+0x53>
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
            goto process_precision;
c01056d3:	90                   	nop
        case '#':
            altflag = 1;
            goto reswitch;

        process_precision:
            if (width < 0)
c01056d4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01056d8:	0f 89 63 ff ff ff    	jns    c0105641 <vprintfmt+0x53>
                width = precision, precision = -1;
c01056de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01056e1:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01056e4:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c01056eb:	e9 51 ff ff ff       	jmp    c0105641 <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c01056f0:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c01056f4:	e9 48 ff ff ff       	jmp    c0105641 <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c01056f9:	8b 45 14             	mov    0x14(%ebp),%eax
c01056fc:	8d 50 04             	lea    0x4(%eax),%edx
c01056ff:	89 55 14             	mov    %edx,0x14(%ebp)
c0105702:	8b 00                	mov    (%eax),%eax
c0105704:	83 ec 08             	sub    $0x8,%esp
c0105707:	ff 75 0c             	pushl  0xc(%ebp)
c010570a:	50                   	push   %eax
c010570b:	8b 45 08             	mov    0x8(%ebp),%eax
c010570e:	ff d0                	call   *%eax
c0105710:	83 c4 10             	add    $0x10,%esp
            break;
c0105713:	e9 71 02 00 00       	jmp    c0105989 <vprintfmt+0x39b>

        // error message
        case 'e':
            err = va_arg(ap, int);
c0105718:	8b 45 14             	mov    0x14(%ebp),%eax
c010571b:	8d 50 04             	lea    0x4(%eax),%edx
c010571e:	89 55 14             	mov    %edx,0x14(%ebp)
c0105721:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c0105723:	85 db                	test   %ebx,%ebx
c0105725:	79 02                	jns    c0105729 <vprintfmt+0x13b>
                err = -err;
c0105727:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c0105729:	83 fb 06             	cmp    $0x6,%ebx
c010572c:	7f 0b                	jg     c0105739 <vprintfmt+0x14b>
c010572e:	8b 34 9d b8 6b 10 c0 	mov    -0x3fef9448(,%ebx,4),%esi
c0105735:	85 f6                	test   %esi,%esi
c0105737:	75 19                	jne    c0105752 <vprintfmt+0x164>
                printfmt(putch, putdat, "error %d", err);
c0105739:	53                   	push   %ebx
c010573a:	68 e5 6b 10 c0       	push   $0xc0106be5
c010573f:	ff 75 0c             	pushl  0xc(%ebp)
c0105742:	ff 75 08             	pushl  0x8(%ebp)
c0105745:	e8 80 fe ff ff       	call   c01055ca <printfmt>
c010574a:	83 c4 10             	add    $0x10,%esp
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c010574d:	e9 37 02 00 00       	jmp    c0105989 <vprintfmt+0x39b>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c0105752:	56                   	push   %esi
c0105753:	68 ee 6b 10 c0       	push   $0xc0106bee
c0105758:	ff 75 0c             	pushl  0xc(%ebp)
c010575b:	ff 75 08             	pushl  0x8(%ebp)
c010575e:	e8 67 fe ff ff       	call   c01055ca <printfmt>
c0105763:	83 c4 10             	add    $0x10,%esp
            }
            break;
c0105766:	e9 1e 02 00 00       	jmp    c0105989 <vprintfmt+0x39b>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c010576b:	8b 45 14             	mov    0x14(%ebp),%eax
c010576e:	8d 50 04             	lea    0x4(%eax),%edx
c0105771:	89 55 14             	mov    %edx,0x14(%ebp)
c0105774:	8b 30                	mov    (%eax),%esi
c0105776:	85 f6                	test   %esi,%esi
c0105778:	75 05                	jne    c010577f <vprintfmt+0x191>
                p = "(null)";
c010577a:	be f1 6b 10 c0       	mov    $0xc0106bf1,%esi
            }
            if (width > 0 && padc != '-') {
c010577f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105783:	7e 76                	jle    c01057fb <vprintfmt+0x20d>
c0105785:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c0105789:	74 70                	je     c01057fb <vprintfmt+0x20d>
                for (width -= strnlen(p, precision); width > 0; width --) {
c010578b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010578e:	83 ec 08             	sub    $0x8,%esp
c0105791:	50                   	push   %eax
c0105792:	56                   	push   %esi
c0105793:	e8 17 f8 ff ff       	call   c0104faf <strnlen>
c0105798:	83 c4 10             	add    $0x10,%esp
c010579b:	89 c2                	mov    %eax,%edx
c010579d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01057a0:	29 d0                	sub    %edx,%eax
c01057a2:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01057a5:	eb 17                	jmp    c01057be <vprintfmt+0x1d0>
                    putch(padc, putdat);
c01057a7:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c01057ab:	83 ec 08             	sub    $0x8,%esp
c01057ae:	ff 75 0c             	pushl  0xc(%ebp)
c01057b1:	50                   	push   %eax
c01057b2:	8b 45 08             	mov    0x8(%ebp),%eax
c01057b5:	ff d0                	call   *%eax
c01057b7:	83 c4 10             	add    $0x10,%esp
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c01057ba:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c01057be:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01057c2:	7f e3                	jg     c01057a7 <vprintfmt+0x1b9>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c01057c4:	eb 35                	jmp    c01057fb <vprintfmt+0x20d>
                if (altflag && (ch < ' ' || ch > '~')) {
c01057c6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01057ca:	74 1c                	je     c01057e8 <vprintfmt+0x1fa>
c01057cc:	83 fb 1f             	cmp    $0x1f,%ebx
c01057cf:	7e 05                	jle    c01057d6 <vprintfmt+0x1e8>
c01057d1:	83 fb 7e             	cmp    $0x7e,%ebx
c01057d4:	7e 12                	jle    c01057e8 <vprintfmt+0x1fa>
                    putch('?', putdat);
c01057d6:	83 ec 08             	sub    $0x8,%esp
c01057d9:	ff 75 0c             	pushl  0xc(%ebp)
c01057dc:	6a 3f                	push   $0x3f
c01057de:	8b 45 08             	mov    0x8(%ebp),%eax
c01057e1:	ff d0                	call   *%eax
c01057e3:	83 c4 10             	add    $0x10,%esp
c01057e6:	eb 0f                	jmp    c01057f7 <vprintfmt+0x209>
                }
                else {
                    putch(ch, putdat);
c01057e8:	83 ec 08             	sub    $0x8,%esp
c01057eb:	ff 75 0c             	pushl  0xc(%ebp)
c01057ee:	53                   	push   %ebx
c01057ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01057f2:	ff d0                	call   *%eax
c01057f4:	83 c4 10             	add    $0x10,%esp
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c01057f7:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c01057fb:	89 f0                	mov    %esi,%eax
c01057fd:	8d 70 01             	lea    0x1(%eax),%esi
c0105800:	0f b6 00             	movzbl (%eax),%eax
c0105803:	0f be d8             	movsbl %al,%ebx
c0105806:	85 db                	test   %ebx,%ebx
c0105808:	74 26                	je     c0105830 <vprintfmt+0x242>
c010580a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010580e:	78 b6                	js     c01057c6 <vprintfmt+0x1d8>
c0105810:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c0105814:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105818:	79 ac                	jns    c01057c6 <vprintfmt+0x1d8>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c010581a:	eb 14                	jmp    c0105830 <vprintfmt+0x242>
                putch(' ', putdat);
c010581c:	83 ec 08             	sub    $0x8,%esp
c010581f:	ff 75 0c             	pushl  0xc(%ebp)
c0105822:	6a 20                	push   $0x20
c0105824:	8b 45 08             	mov    0x8(%ebp),%eax
c0105827:	ff d0                	call   *%eax
c0105829:	83 c4 10             	add    $0x10,%esp
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c010582c:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105830:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105834:	7f e6                	jg     c010581c <vprintfmt+0x22e>
                putch(' ', putdat);
            }
            break;
c0105836:	e9 4e 01 00 00       	jmp    c0105989 <vprintfmt+0x39b>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c010583b:	83 ec 08             	sub    $0x8,%esp
c010583e:	ff 75 e0             	pushl  -0x20(%ebp)
c0105841:	8d 45 14             	lea    0x14(%ebp),%eax
c0105844:	50                   	push   %eax
c0105845:	e8 39 fd ff ff       	call   c0105583 <getint>
c010584a:	83 c4 10             	add    $0x10,%esp
c010584d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105850:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c0105853:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105856:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105859:	85 d2                	test   %edx,%edx
c010585b:	79 23                	jns    c0105880 <vprintfmt+0x292>
                putch('-', putdat);
c010585d:	83 ec 08             	sub    $0x8,%esp
c0105860:	ff 75 0c             	pushl  0xc(%ebp)
c0105863:	6a 2d                	push   $0x2d
c0105865:	8b 45 08             	mov    0x8(%ebp),%eax
c0105868:	ff d0                	call   *%eax
c010586a:	83 c4 10             	add    $0x10,%esp
                num = -(long long)num;
c010586d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105870:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105873:	f7 d8                	neg    %eax
c0105875:	83 d2 00             	adc    $0x0,%edx
c0105878:	f7 da                	neg    %edx
c010587a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010587d:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c0105880:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105887:	e9 9f 00 00 00       	jmp    c010592b <vprintfmt+0x33d>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c010588c:	83 ec 08             	sub    $0x8,%esp
c010588f:	ff 75 e0             	pushl  -0x20(%ebp)
c0105892:	8d 45 14             	lea    0x14(%ebp),%eax
c0105895:	50                   	push   %eax
c0105896:	e8 99 fc ff ff       	call   c0105534 <getuint>
c010589b:	83 c4 10             	add    $0x10,%esp
c010589e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01058a1:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c01058a4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c01058ab:	eb 7e                	jmp    c010592b <vprintfmt+0x33d>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c01058ad:	83 ec 08             	sub    $0x8,%esp
c01058b0:	ff 75 e0             	pushl  -0x20(%ebp)
c01058b3:	8d 45 14             	lea    0x14(%ebp),%eax
c01058b6:	50                   	push   %eax
c01058b7:	e8 78 fc ff ff       	call   c0105534 <getuint>
c01058bc:	83 c4 10             	add    $0x10,%esp
c01058bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01058c2:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c01058c5:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c01058cc:	eb 5d                	jmp    c010592b <vprintfmt+0x33d>

        // pointer
        case 'p':
            putch('0', putdat);
c01058ce:	83 ec 08             	sub    $0x8,%esp
c01058d1:	ff 75 0c             	pushl  0xc(%ebp)
c01058d4:	6a 30                	push   $0x30
c01058d6:	8b 45 08             	mov    0x8(%ebp),%eax
c01058d9:	ff d0                	call   *%eax
c01058db:	83 c4 10             	add    $0x10,%esp
            putch('x', putdat);
c01058de:	83 ec 08             	sub    $0x8,%esp
c01058e1:	ff 75 0c             	pushl  0xc(%ebp)
c01058e4:	6a 78                	push   $0x78
c01058e6:	8b 45 08             	mov    0x8(%ebp),%eax
c01058e9:	ff d0                	call   *%eax
c01058eb:	83 c4 10             	add    $0x10,%esp
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c01058ee:	8b 45 14             	mov    0x14(%ebp),%eax
c01058f1:	8d 50 04             	lea    0x4(%eax),%edx
c01058f4:	89 55 14             	mov    %edx,0x14(%ebp)
c01058f7:	8b 00                	mov    (%eax),%eax
c01058f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01058fc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c0105903:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c010590a:	eb 1f                	jmp    c010592b <vprintfmt+0x33d>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c010590c:	83 ec 08             	sub    $0x8,%esp
c010590f:	ff 75 e0             	pushl  -0x20(%ebp)
c0105912:	8d 45 14             	lea    0x14(%ebp),%eax
c0105915:	50                   	push   %eax
c0105916:	e8 19 fc ff ff       	call   c0105534 <getuint>
c010591b:	83 c4 10             	add    $0x10,%esp
c010591e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105921:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c0105924:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c010592b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c010592f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105932:	83 ec 04             	sub    $0x4,%esp
c0105935:	52                   	push   %edx
c0105936:	ff 75 e8             	pushl  -0x18(%ebp)
c0105939:	50                   	push   %eax
c010593a:	ff 75 f4             	pushl  -0xc(%ebp)
c010593d:	ff 75 f0             	pushl  -0x10(%ebp)
c0105940:	ff 75 0c             	pushl  0xc(%ebp)
c0105943:	ff 75 08             	pushl  0x8(%ebp)
c0105946:	e8 f8 fa ff ff       	call   c0105443 <printnum>
c010594b:	83 c4 20             	add    $0x20,%esp
            break;
c010594e:	eb 39                	jmp    c0105989 <vprintfmt+0x39b>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c0105950:	83 ec 08             	sub    $0x8,%esp
c0105953:	ff 75 0c             	pushl  0xc(%ebp)
c0105956:	53                   	push   %ebx
c0105957:	8b 45 08             	mov    0x8(%ebp),%eax
c010595a:	ff d0                	call   *%eax
c010595c:	83 c4 10             	add    $0x10,%esp
            break;
c010595f:	eb 28                	jmp    c0105989 <vprintfmt+0x39b>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c0105961:	83 ec 08             	sub    $0x8,%esp
c0105964:	ff 75 0c             	pushl  0xc(%ebp)
c0105967:	6a 25                	push   $0x25
c0105969:	8b 45 08             	mov    0x8(%ebp),%eax
c010596c:	ff d0                	call   *%eax
c010596e:	83 c4 10             	add    $0x10,%esp
            for (fmt --; fmt[-1] != '%'; fmt --)
c0105971:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105975:	eb 04                	jmp    c010597b <vprintfmt+0x38d>
c0105977:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c010597b:	8b 45 10             	mov    0x10(%ebp),%eax
c010597e:	83 e8 01             	sub    $0x1,%eax
c0105981:	0f b6 00             	movzbl (%eax),%eax
c0105984:	3c 25                	cmp    $0x25,%al
c0105986:	75 ef                	jne    c0105977 <vprintfmt+0x389>
                /* do nothing */;
            break;
c0105988:	90                   	nop
        }
    }
c0105989:	e9 68 fc ff ff       	jmp    c01055f6 <vprintfmt+0x8>
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
            if (ch == '\0') {
                return;
c010598e:	90                   	nop
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c010598f:	8d 65 f8             	lea    -0x8(%ebp),%esp
c0105992:	5b                   	pop    %ebx
c0105993:	5e                   	pop    %esi
c0105994:	5d                   	pop    %ebp
c0105995:	c3                   	ret    

c0105996 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0105996:	55                   	push   %ebp
c0105997:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c0105999:	8b 45 0c             	mov    0xc(%ebp),%eax
c010599c:	8b 40 08             	mov    0x8(%eax),%eax
c010599f:	8d 50 01             	lea    0x1(%eax),%edx
c01059a2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059a5:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c01059a8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059ab:	8b 10                	mov    (%eax),%edx
c01059ad:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059b0:	8b 40 04             	mov    0x4(%eax),%eax
c01059b3:	39 c2                	cmp    %eax,%edx
c01059b5:	73 12                	jae    c01059c9 <sprintputch+0x33>
        *b->buf ++ = ch;
c01059b7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059ba:	8b 00                	mov    (%eax),%eax
c01059bc:	8d 48 01             	lea    0x1(%eax),%ecx
c01059bf:	8b 55 0c             	mov    0xc(%ebp),%edx
c01059c2:	89 0a                	mov    %ecx,(%edx)
c01059c4:	8b 55 08             	mov    0x8(%ebp),%edx
c01059c7:	88 10                	mov    %dl,(%eax)
    }
}
c01059c9:	90                   	nop
c01059ca:	5d                   	pop    %ebp
c01059cb:	c3                   	ret    

c01059cc <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c01059cc:	55                   	push   %ebp
c01059cd:	89 e5                	mov    %esp,%ebp
c01059cf:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c01059d2:	8d 45 14             	lea    0x14(%ebp),%eax
c01059d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c01059d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01059db:	50                   	push   %eax
c01059dc:	ff 75 10             	pushl  0x10(%ebp)
c01059df:	ff 75 0c             	pushl  0xc(%ebp)
c01059e2:	ff 75 08             	pushl  0x8(%ebp)
c01059e5:	e8 0b 00 00 00       	call   c01059f5 <vsnprintf>
c01059ea:	83 c4 10             	add    $0x10,%esp
c01059ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c01059f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01059f3:	c9                   	leave  
c01059f4:	c3                   	ret    

c01059f5 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c01059f5:	55                   	push   %ebp
c01059f6:	89 e5                	mov    %esp,%ebp
c01059f8:	83 ec 18             	sub    $0x18,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c01059fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01059fe:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105a01:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a04:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105a07:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a0a:	01 d0                	add    %edx,%eax
c0105a0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105a0f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0105a16:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105a1a:	74 0a                	je     c0105a26 <vsnprintf+0x31>
c0105a1c:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105a1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a22:	39 c2                	cmp    %eax,%edx
c0105a24:	76 07                	jbe    c0105a2d <vsnprintf+0x38>
        return -E_INVAL;
c0105a26:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0105a2b:	eb 20                	jmp    c0105a4d <vsnprintf+0x58>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0105a2d:	ff 75 14             	pushl  0x14(%ebp)
c0105a30:	ff 75 10             	pushl  0x10(%ebp)
c0105a33:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0105a36:	50                   	push   %eax
c0105a37:	68 96 59 10 c0       	push   $0xc0105996
c0105a3c:	e8 ad fb ff ff       	call   c01055ee <vprintfmt>
c0105a41:	83 c4 10             	add    $0x10,%esp
    // null terminate the buffer
    *b.buf = '\0';
c0105a44:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105a47:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0105a4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105a4d:	c9                   	leave  
c0105a4e:	c3                   	ret    
