
bin/kernel_nopage：     文件格式 elf32-i386


Disassembly of section .text:

00100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
  100000:	0f 01 15 18 70 11 40 	lgdtl  0x40117018
    movl $KERNEL_DS, %eax
  100007:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  10000c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  10000e:	8e c0                	mov    %eax,%es
    movw %ax, %ss
  100010:	8e d0                	mov    %eax,%ss

    ljmp $KERNEL_CS, $relocated
  100012:	ea 19 00 10 00 08 00 	ljmp   $0x8,$0x100019

00100019 <relocated>:

relocated:

    # set ebp, esp
    movl $0x0, %ebp
  100019:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
  10001e:	bc 00 70 11 00       	mov    $0x117000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
  100023:	e8 02 00 00 00       	call   10002a <kern_init>

00100028 <spin>:

# should never get here
spin:
    jmp spin
  100028:	eb fe                	jmp    100028 <spin>

0010002a <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  10002a:	55                   	push   %ebp
  10002b:	89 e5                	mov    %esp,%ebp
  10002d:	83 ec 18             	sub    $0x18,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100030:	ba 68 89 11 00       	mov    $0x118968,%edx
  100035:	b8 36 7a 11 00       	mov    $0x117a36,%eax
  10003a:	29 c2                	sub    %eax,%edx
  10003c:	89 d0                	mov    %edx,%eax
  10003e:	83 ec 04             	sub    $0x4,%esp
  100041:	50                   	push   %eax
  100042:	6a 00                	push   $0x0
  100044:	68 36 7a 11 00       	push   $0x117a36
  100049:	e8 64 52 00 00       	call   1052b2 <memset>
  10004e:	83 c4 10             	add    $0x10,%esp

    cons_init();                // init the console
  100051:	e8 48 15 00 00       	call   10159e <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100056:	c7 45 f4 60 5a 10 00 	movl   $0x105a60,-0xc(%ebp)
    cprintf("%s\n\n", message);
  10005d:	83 ec 08             	sub    $0x8,%esp
  100060:	ff 75 f4             	pushl  -0xc(%ebp)
  100063:	68 7c 5a 10 00       	push   $0x105a7c
  100068:	e8 fa 01 00 00       	call   100267 <cprintf>
  10006d:	83 c4 10             	add    $0x10,%esp

    print_kerninfo();
  100070:	e8 7c 08 00 00       	call   1008f1 <print_kerninfo>

    grade_backtrace();
  100075:	e8 74 00 00 00       	call   1000ee <grade_backtrace>

    pmm_init();                 // init physical memory management
  10007a:	e8 ea 30 00 00       	call   103169 <pmm_init>

    pic_init();                 // init interrupt controller
  10007f:	e8 8c 16 00 00       	call   101710 <pic_init>
    idt_init();                 // init interrupt descriptor table
  100084:	e8 ed 17 00 00       	call   101876 <idt_init>

    clock_init();               // init clock interrupt
  100089:	e8 b7 0c 00 00       	call   100d45 <clock_init>
    intr_enable();              // enable irq interrupt
  10008e:	e8 ba 17 00 00       	call   10184d <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  100093:	eb fe                	jmp    100093 <kern_init+0x69>

00100095 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  100095:	55                   	push   %ebp
  100096:	89 e5                	mov    %esp,%ebp
  100098:	83 ec 08             	sub    $0x8,%esp
    mon_backtrace(0, NULL, NULL);
  10009b:	83 ec 04             	sub    $0x4,%esp
  10009e:	6a 00                	push   $0x0
  1000a0:	6a 00                	push   $0x0
  1000a2:	6a 00                	push   $0x0
  1000a4:	e8 8a 0c 00 00       	call   100d33 <mon_backtrace>
  1000a9:	83 c4 10             	add    $0x10,%esp
}
  1000ac:	90                   	nop
  1000ad:	c9                   	leave  
  1000ae:	c3                   	ret    

001000af <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  1000af:	55                   	push   %ebp
  1000b0:	89 e5                	mov    %esp,%ebp
  1000b2:	53                   	push   %ebx
  1000b3:	83 ec 04             	sub    $0x4,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000b6:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  1000b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  1000bc:	8d 5d 08             	lea    0x8(%ebp),%ebx
  1000bf:	8b 45 08             	mov    0x8(%ebp),%eax
  1000c2:	51                   	push   %ecx
  1000c3:	52                   	push   %edx
  1000c4:	53                   	push   %ebx
  1000c5:	50                   	push   %eax
  1000c6:	e8 ca ff ff ff       	call   100095 <grade_backtrace2>
  1000cb:	83 c4 10             	add    $0x10,%esp
}
  1000ce:	90                   	nop
  1000cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1000d2:	c9                   	leave  
  1000d3:	c3                   	ret    

001000d4 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000d4:	55                   	push   %ebp
  1000d5:	89 e5                	mov    %esp,%ebp
  1000d7:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace1(arg0, arg2);
  1000da:	83 ec 08             	sub    $0x8,%esp
  1000dd:	ff 75 10             	pushl  0x10(%ebp)
  1000e0:	ff 75 08             	pushl  0x8(%ebp)
  1000e3:	e8 c7 ff ff ff       	call   1000af <grade_backtrace1>
  1000e8:	83 c4 10             	add    $0x10,%esp
}
  1000eb:	90                   	nop
  1000ec:	c9                   	leave  
  1000ed:	c3                   	ret    

001000ee <grade_backtrace>:

void
grade_backtrace(void) {
  1000ee:	55                   	push   %ebp
  1000ef:	89 e5                	mov    %esp,%ebp
  1000f1:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  1000f4:	b8 2a 00 10 00       	mov    $0x10002a,%eax
  1000f9:	83 ec 04             	sub    $0x4,%esp
  1000fc:	68 00 00 ff ff       	push   $0xffff0000
  100101:	50                   	push   %eax
  100102:	6a 00                	push   $0x0
  100104:	e8 cb ff ff ff       	call   1000d4 <grade_backtrace0>
  100109:	83 c4 10             	add    $0x10,%esp
}
  10010c:	90                   	nop
  10010d:	c9                   	leave  
  10010e:	c3                   	ret    

0010010f <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  10010f:	55                   	push   %ebp
  100110:	89 e5                	mov    %esp,%ebp
  100112:	83 ec 18             	sub    $0x18,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100115:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100118:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  10011b:	8c 45 f2             	mov    %es,-0xe(%ebp)
  10011e:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  100121:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100125:	0f b7 c0             	movzwl %ax,%eax
  100128:	83 e0 03             	and    $0x3,%eax
  10012b:	89 c2                	mov    %eax,%edx
  10012d:	a1 40 7a 11 00       	mov    0x117a40,%eax
  100132:	83 ec 04             	sub    $0x4,%esp
  100135:	52                   	push   %edx
  100136:	50                   	push   %eax
  100137:	68 81 5a 10 00       	push   $0x105a81
  10013c:	e8 26 01 00 00       	call   100267 <cprintf>
  100141:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  cs = %x\n", round, reg1);
  100144:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100148:	0f b7 d0             	movzwl %ax,%edx
  10014b:	a1 40 7a 11 00       	mov    0x117a40,%eax
  100150:	83 ec 04             	sub    $0x4,%esp
  100153:	52                   	push   %edx
  100154:	50                   	push   %eax
  100155:	68 8f 5a 10 00       	push   $0x105a8f
  10015a:	e8 08 01 00 00       	call   100267 <cprintf>
  10015f:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ds = %x\n", round, reg2);
  100162:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100166:	0f b7 d0             	movzwl %ax,%edx
  100169:	a1 40 7a 11 00       	mov    0x117a40,%eax
  10016e:	83 ec 04             	sub    $0x4,%esp
  100171:	52                   	push   %edx
  100172:	50                   	push   %eax
  100173:	68 9d 5a 10 00       	push   $0x105a9d
  100178:	e8 ea 00 00 00       	call   100267 <cprintf>
  10017d:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  es = %x\n", round, reg3);
  100180:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100184:	0f b7 d0             	movzwl %ax,%edx
  100187:	a1 40 7a 11 00       	mov    0x117a40,%eax
  10018c:	83 ec 04             	sub    $0x4,%esp
  10018f:	52                   	push   %edx
  100190:	50                   	push   %eax
  100191:	68 ab 5a 10 00       	push   $0x105aab
  100196:	e8 cc 00 00 00       	call   100267 <cprintf>
  10019b:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ss = %x\n", round, reg4);
  10019e:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001a2:	0f b7 d0             	movzwl %ax,%edx
  1001a5:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001aa:	83 ec 04             	sub    $0x4,%esp
  1001ad:	52                   	push   %edx
  1001ae:	50                   	push   %eax
  1001af:	68 b9 5a 10 00       	push   $0x105ab9
  1001b4:	e8 ae 00 00 00       	call   100267 <cprintf>
  1001b9:	83 c4 10             	add    $0x10,%esp
    round ++;
  1001bc:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001c1:	83 c0 01             	add    $0x1,%eax
  1001c4:	a3 40 7a 11 00       	mov    %eax,0x117a40
}
  1001c9:	90                   	nop
  1001ca:	c9                   	leave  
  1001cb:	c3                   	ret    

001001cc <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001cc:	55                   	push   %ebp
  1001cd:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
  1001cf:	90                   	nop
  1001d0:	5d                   	pop    %ebp
  1001d1:	c3                   	ret    

001001d2 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001d2:	55                   	push   %ebp
  1001d3:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
  1001d5:	90                   	nop
  1001d6:	5d                   	pop    %ebp
  1001d7:	c3                   	ret    

001001d8 <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001d8:	55                   	push   %ebp
  1001d9:	89 e5                	mov    %esp,%ebp
  1001db:	83 ec 08             	sub    $0x8,%esp
    lab1_print_cur_status();
  1001de:	e8 2c ff ff ff       	call   10010f <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  1001e3:	83 ec 0c             	sub    $0xc,%esp
  1001e6:	68 c8 5a 10 00       	push   $0x105ac8
  1001eb:	e8 77 00 00 00       	call   100267 <cprintf>
  1001f0:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_user();
  1001f3:	e8 d4 ff ff ff       	call   1001cc <lab1_switch_to_user>
    lab1_print_cur_status();
  1001f8:	e8 12 ff ff ff       	call   10010f <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  1001fd:	83 ec 0c             	sub    $0xc,%esp
  100200:	68 e8 5a 10 00       	push   $0x105ae8
  100205:	e8 5d 00 00 00       	call   100267 <cprintf>
  10020a:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_kernel();
  10020d:	e8 c0 ff ff ff       	call   1001d2 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100212:	e8 f8 fe ff ff       	call   10010f <lab1_print_cur_status>
}
  100217:	90                   	nop
  100218:	c9                   	leave  
  100219:	c3                   	ret    

0010021a <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  10021a:	55                   	push   %ebp
  10021b:	89 e5                	mov    %esp,%ebp
  10021d:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
  100220:	83 ec 0c             	sub    $0xc,%esp
  100223:	ff 75 08             	pushl  0x8(%ebp)
  100226:	e8 a4 13 00 00       	call   1015cf <cons_putc>
  10022b:	83 c4 10             	add    $0x10,%esp
    (*cnt) ++;
  10022e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100231:	8b 00                	mov    (%eax),%eax
  100233:	8d 50 01             	lea    0x1(%eax),%edx
  100236:	8b 45 0c             	mov    0xc(%ebp),%eax
  100239:	89 10                	mov    %edx,(%eax)
}
  10023b:	90                   	nop
  10023c:	c9                   	leave  
  10023d:	c3                   	ret    

0010023e <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  10023e:	55                   	push   %ebp
  10023f:	89 e5                	mov    %esp,%ebp
  100241:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
  100244:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  10024b:	ff 75 0c             	pushl  0xc(%ebp)
  10024e:	ff 75 08             	pushl  0x8(%ebp)
  100251:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100254:	50                   	push   %eax
  100255:	68 1a 02 10 00       	push   $0x10021a
  10025a:	e8 89 53 00 00       	call   1055e8 <vprintfmt>
  10025f:	83 c4 10             	add    $0x10,%esp
    return cnt;
  100262:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100265:	c9                   	leave  
  100266:	c3                   	ret    

00100267 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  100267:	55                   	push   %ebp
  100268:	89 e5                	mov    %esp,%ebp
  10026a:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  10026d:	8d 45 0c             	lea    0xc(%ebp),%eax
  100270:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100273:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100276:	83 ec 08             	sub    $0x8,%esp
  100279:	50                   	push   %eax
  10027a:	ff 75 08             	pushl  0x8(%ebp)
  10027d:	e8 bc ff ff ff       	call   10023e <vcprintf>
  100282:	83 c4 10             	add    $0x10,%esp
  100285:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  100288:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10028b:	c9                   	leave  
  10028c:	c3                   	ret    

0010028d <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  10028d:	55                   	push   %ebp
  10028e:	89 e5                	mov    %esp,%ebp
  100290:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
  100293:	83 ec 0c             	sub    $0xc,%esp
  100296:	ff 75 08             	pushl  0x8(%ebp)
  100299:	e8 31 13 00 00       	call   1015cf <cons_putc>
  10029e:	83 c4 10             	add    $0x10,%esp
}
  1002a1:	90                   	nop
  1002a2:	c9                   	leave  
  1002a3:	c3                   	ret    

001002a4 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  1002a4:	55                   	push   %ebp
  1002a5:	89 e5                	mov    %esp,%ebp
  1002a7:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
  1002aa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  1002b1:	eb 14                	jmp    1002c7 <cputs+0x23>
        cputch(c, &cnt);
  1002b3:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  1002b7:	83 ec 08             	sub    $0x8,%esp
  1002ba:	8d 55 f0             	lea    -0x10(%ebp),%edx
  1002bd:	52                   	push   %edx
  1002be:	50                   	push   %eax
  1002bf:	e8 56 ff ff ff       	call   10021a <cputch>
  1002c4:	83 c4 10             	add    $0x10,%esp
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  1002c7:	8b 45 08             	mov    0x8(%ebp),%eax
  1002ca:	8d 50 01             	lea    0x1(%eax),%edx
  1002cd:	89 55 08             	mov    %edx,0x8(%ebp)
  1002d0:	0f b6 00             	movzbl (%eax),%eax
  1002d3:	88 45 f7             	mov    %al,-0x9(%ebp)
  1002d6:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1002da:	75 d7                	jne    1002b3 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  1002dc:	83 ec 08             	sub    $0x8,%esp
  1002df:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1002e2:	50                   	push   %eax
  1002e3:	6a 0a                	push   $0xa
  1002e5:	e8 30 ff ff ff       	call   10021a <cputch>
  1002ea:	83 c4 10             	add    $0x10,%esp
    return cnt;
  1002ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1002f0:	c9                   	leave  
  1002f1:	c3                   	ret    

001002f2 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1002f2:	55                   	push   %ebp
  1002f3:	89 e5                	mov    %esp,%ebp
  1002f5:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1002f8:	e8 1b 13 00 00       	call   101618 <cons_getc>
  1002fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100300:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100304:	74 f2                	je     1002f8 <getchar+0x6>
        /* do nothing */;
    return c;
  100306:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100309:	c9                   	leave  
  10030a:	c3                   	ret    

0010030b <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  10030b:	55                   	push   %ebp
  10030c:	89 e5                	mov    %esp,%ebp
  10030e:	83 ec 18             	sub    $0x18,%esp
    if (prompt != NULL) {
  100311:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100315:	74 13                	je     10032a <readline+0x1f>
        cprintf("%s", prompt);
  100317:	83 ec 08             	sub    $0x8,%esp
  10031a:	ff 75 08             	pushl  0x8(%ebp)
  10031d:	68 07 5b 10 00       	push   $0x105b07
  100322:	e8 40 ff ff ff       	call   100267 <cprintf>
  100327:	83 c4 10             	add    $0x10,%esp
    }
    int i = 0, c;
  10032a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100331:	e8 bc ff ff ff       	call   1002f2 <getchar>
  100336:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100339:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10033d:	79 0a                	jns    100349 <readline+0x3e>
            return NULL;
  10033f:	b8 00 00 00 00       	mov    $0x0,%eax
  100344:	e9 82 00 00 00       	jmp    1003cb <readline+0xc0>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  100349:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  10034d:	7e 2b                	jle    10037a <readline+0x6f>
  10034f:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100356:	7f 22                	jg     10037a <readline+0x6f>
            cputchar(c);
  100358:	83 ec 0c             	sub    $0xc,%esp
  10035b:	ff 75 f0             	pushl  -0x10(%ebp)
  10035e:	e8 2a ff ff ff       	call   10028d <cputchar>
  100363:	83 c4 10             	add    $0x10,%esp
            buf[i ++] = c;
  100366:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100369:	8d 50 01             	lea    0x1(%eax),%edx
  10036c:	89 55 f4             	mov    %edx,-0xc(%ebp)
  10036f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100372:	88 90 60 7a 11 00    	mov    %dl,0x117a60(%eax)
  100378:	eb 4c                	jmp    1003c6 <readline+0xbb>
        }
        else if (c == '\b' && i > 0) {
  10037a:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  10037e:	75 1a                	jne    10039a <readline+0x8f>
  100380:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100384:	7e 14                	jle    10039a <readline+0x8f>
            cputchar(c);
  100386:	83 ec 0c             	sub    $0xc,%esp
  100389:	ff 75 f0             	pushl  -0x10(%ebp)
  10038c:	e8 fc fe ff ff       	call   10028d <cputchar>
  100391:	83 c4 10             	add    $0x10,%esp
            i --;
  100394:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  100398:	eb 2c                	jmp    1003c6 <readline+0xbb>
        }
        else if (c == '\n' || c == '\r') {
  10039a:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  10039e:	74 06                	je     1003a6 <readline+0x9b>
  1003a0:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1003a4:	75 8b                	jne    100331 <readline+0x26>
            cputchar(c);
  1003a6:	83 ec 0c             	sub    $0xc,%esp
  1003a9:	ff 75 f0             	pushl  -0x10(%ebp)
  1003ac:	e8 dc fe ff ff       	call   10028d <cputchar>
  1003b1:	83 c4 10             	add    $0x10,%esp
            buf[i] = '\0';
  1003b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003b7:	05 60 7a 11 00       	add    $0x117a60,%eax
  1003bc:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1003bf:	b8 60 7a 11 00       	mov    $0x117a60,%eax
  1003c4:	eb 05                	jmp    1003cb <readline+0xc0>
        }
    }
  1003c6:	e9 66 ff ff ff       	jmp    100331 <readline+0x26>
}
  1003cb:	c9                   	leave  
  1003cc:	c3                   	ret    

001003cd <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  1003cd:	55                   	push   %ebp
  1003ce:	89 e5                	mov    %esp,%ebp
  1003d0:	83 ec 18             	sub    $0x18,%esp
    if (is_panic) {
  1003d3:	a1 60 7e 11 00       	mov    0x117e60,%eax
  1003d8:	85 c0                	test   %eax,%eax
  1003da:	75 4a                	jne    100426 <__panic+0x59>
        goto panic_dead;
    }
    is_panic = 1;
  1003dc:	c7 05 60 7e 11 00 01 	movl   $0x1,0x117e60
  1003e3:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  1003e6:	8d 45 14             	lea    0x14(%ebp),%eax
  1003e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  1003ec:	83 ec 04             	sub    $0x4,%esp
  1003ef:	ff 75 0c             	pushl  0xc(%ebp)
  1003f2:	ff 75 08             	pushl  0x8(%ebp)
  1003f5:	68 0a 5b 10 00       	push   $0x105b0a
  1003fa:	e8 68 fe ff ff       	call   100267 <cprintf>
  1003ff:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
  100402:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100405:	83 ec 08             	sub    $0x8,%esp
  100408:	50                   	push   %eax
  100409:	ff 75 10             	pushl  0x10(%ebp)
  10040c:	e8 2d fe ff ff       	call   10023e <vcprintf>
  100411:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
  100414:	83 ec 0c             	sub    $0xc,%esp
  100417:	68 26 5b 10 00       	push   $0x105b26
  10041c:	e8 46 fe ff ff       	call   100267 <cprintf>
  100421:	83 c4 10             	add    $0x10,%esp
  100424:	eb 01                	jmp    100427 <__panic+0x5a>
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
        goto panic_dead;
  100426:	90                   	nop
    vcprintf(fmt, ap);
    cprintf("\n");
    va_end(ap);

panic_dead:
    intr_disable();
  100427:	e8 28 14 00 00       	call   101854 <intr_disable>
    while (1) {
        kmonitor(NULL);
  10042c:	83 ec 0c             	sub    $0xc,%esp
  10042f:	6a 00                	push   $0x0
  100431:	e8 23 08 00 00       	call   100c59 <kmonitor>
  100436:	83 c4 10             	add    $0x10,%esp
    }
  100439:	eb f1                	jmp    10042c <__panic+0x5f>

0010043b <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  10043b:	55                   	push   %ebp
  10043c:	89 e5                	mov    %esp,%ebp
  10043e:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    va_start(ap, fmt);
  100441:	8d 45 14             	lea    0x14(%ebp),%eax
  100444:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100447:	83 ec 04             	sub    $0x4,%esp
  10044a:	ff 75 0c             	pushl  0xc(%ebp)
  10044d:	ff 75 08             	pushl  0x8(%ebp)
  100450:	68 28 5b 10 00       	push   $0x105b28
  100455:	e8 0d fe ff ff       	call   100267 <cprintf>
  10045a:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
  10045d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100460:	83 ec 08             	sub    $0x8,%esp
  100463:	50                   	push   %eax
  100464:	ff 75 10             	pushl  0x10(%ebp)
  100467:	e8 d2 fd ff ff       	call   10023e <vcprintf>
  10046c:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
  10046f:	83 ec 0c             	sub    $0xc,%esp
  100472:	68 26 5b 10 00       	push   $0x105b26
  100477:	e8 eb fd ff ff       	call   100267 <cprintf>
  10047c:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
  10047f:	90                   	nop
  100480:	c9                   	leave  
  100481:	c3                   	ret    

00100482 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100482:	55                   	push   %ebp
  100483:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100485:	a1 60 7e 11 00       	mov    0x117e60,%eax
}
  10048a:	5d                   	pop    %ebp
  10048b:	c3                   	ret    

0010048c <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  10048c:	55                   	push   %ebp
  10048d:	89 e5                	mov    %esp,%ebp
  10048f:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  100492:	8b 45 0c             	mov    0xc(%ebp),%eax
  100495:	8b 00                	mov    (%eax),%eax
  100497:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10049a:	8b 45 10             	mov    0x10(%ebp),%eax
  10049d:	8b 00                	mov    (%eax),%eax
  10049f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004a2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1004a9:	e9 d2 00 00 00       	jmp    100580 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  1004ae:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1004b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1004b4:	01 d0                	add    %edx,%eax
  1004b6:	89 c2                	mov    %eax,%edx
  1004b8:	c1 ea 1f             	shr    $0x1f,%edx
  1004bb:	01 d0                	add    %edx,%eax
  1004bd:	d1 f8                	sar    %eax
  1004bf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1004c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1004c5:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1004c8:	eb 04                	jmp    1004ce <stab_binsearch+0x42>
            m --;
  1004ca:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1004ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004d1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004d4:	7c 1f                	jl     1004f5 <stab_binsearch+0x69>
  1004d6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004d9:	89 d0                	mov    %edx,%eax
  1004db:	01 c0                	add    %eax,%eax
  1004dd:	01 d0                	add    %edx,%eax
  1004df:	c1 e0 02             	shl    $0x2,%eax
  1004e2:	89 c2                	mov    %eax,%edx
  1004e4:	8b 45 08             	mov    0x8(%ebp),%eax
  1004e7:	01 d0                	add    %edx,%eax
  1004e9:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1004ed:	0f b6 c0             	movzbl %al,%eax
  1004f0:	3b 45 14             	cmp    0x14(%ebp),%eax
  1004f3:	75 d5                	jne    1004ca <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
  1004f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004f8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004fb:	7d 0b                	jge    100508 <stab_binsearch+0x7c>
            l = true_m + 1;
  1004fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100500:	83 c0 01             	add    $0x1,%eax
  100503:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100506:	eb 78                	jmp    100580 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  100508:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  10050f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100512:	89 d0                	mov    %edx,%eax
  100514:	01 c0                	add    %eax,%eax
  100516:	01 d0                	add    %edx,%eax
  100518:	c1 e0 02             	shl    $0x2,%eax
  10051b:	89 c2                	mov    %eax,%edx
  10051d:	8b 45 08             	mov    0x8(%ebp),%eax
  100520:	01 d0                	add    %edx,%eax
  100522:	8b 40 08             	mov    0x8(%eax),%eax
  100525:	3b 45 18             	cmp    0x18(%ebp),%eax
  100528:	73 13                	jae    10053d <stab_binsearch+0xb1>
            *region_left = m;
  10052a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10052d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100530:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100532:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100535:	83 c0 01             	add    $0x1,%eax
  100538:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10053b:	eb 43                	jmp    100580 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  10053d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100540:	89 d0                	mov    %edx,%eax
  100542:	01 c0                	add    %eax,%eax
  100544:	01 d0                	add    %edx,%eax
  100546:	c1 e0 02             	shl    $0x2,%eax
  100549:	89 c2                	mov    %eax,%edx
  10054b:	8b 45 08             	mov    0x8(%ebp),%eax
  10054e:	01 d0                	add    %edx,%eax
  100550:	8b 40 08             	mov    0x8(%eax),%eax
  100553:	3b 45 18             	cmp    0x18(%ebp),%eax
  100556:	76 16                	jbe    10056e <stab_binsearch+0xe2>
            *region_right = m - 1;
  100558:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10055b:	8d 50 ff             	lea    -0x1(%eax),%edx
  10055e:	8b 45 10             	mov    0x10(%ebp),%eax
  100561:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  100563:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100566:	83 e8 01             	sub    $0x1,%eax
  100569:	89 45 f8             	mov    %eax,-0x8(%ebp)
  10056c:	eb 12                	jmp    100580 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  10056e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100571:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100574:	89 10                	mov    %edx,(%eax)
            l = m;
  100576:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100579:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  10057c:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
  100580:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100583:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  100586:	0f 8e 22 ff ff ff    	jle    1004ae <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
  10058c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100590:	75 0f                	jne    1005a1 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  100592:	8b 45 0c             	mov    0xc(%ebp),%eax
  100595:	8b 00                	mov    (%eax),%eax
  100597:	8d 50 ff             	lea    -0x1(%eax),%edx
  10059a:	8b 45 10             	mov    0x10(%ebp),%eax
  10059d:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
  10059f:	eb 3f                	jmp    1005e0 <stab_binsearch+0x154>
    if (!any_matches) {
        *region_right = *region_left - 1;
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  1005a1:	8b 45 10             	mov    0x10(%ebp),%eax
  1005a4:	8b 00                	mov    (%eax),%eax
  1005a6:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1005a9:	eb 04                	jmp    1005af <stab_binsearch+0x123>
  1005ab:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  1005af:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005b2:	8b 00                	mov    (%eax),%eax
  1005b4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1005b7:	7d 1f                	jge    1005d8 <stab_binsearch+0x14c>
  1005b9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005bc:	89 d0                	mov    %edx,%eax
  1005be:	01 c0                	add    %eax,%eax
  1005c0:	01 d0                	add    %edx,%eax
  1005c2:	c1 e0 02             	shl    $0x2,%eax
  1005c5:	89 c2                	mov    %eax,%edx
  1005c7:	8b 45 08             	mov    0x8(%ebp),%eax
  1005ca:	01 d0                	add    %edx,%eax
  1005cc:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1005d0:	0f b6 c0             	movzbl %al,%eax
  1005d3:	3b 45 14             	cmp    0x14(%ebp),%eax
  1005d6:	75 d3                	jne    1005ab <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  1005d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005db:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005de:	89 10                	mov    %edx,(%eax)
    }
}
  1005e0:	90                   	nop
  1005e1:	c9                   	leave  
  1005e2:	c3                   	ret    

001005e3 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  1005e3:	55                   	push   %ebp
  1005e4:	89 e5                	mov    %esp,%ebp
  1005e6:	83 ec 38             	sub    $0x38,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  1005e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005ec:	c7 00 48 5b 10 00    	movl   $0x105b48,(%eax)
    info->eip_line = 0;
  1005f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005f5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  1005fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005ff:	c7 40 08 48 5b 10 00 	movl   $0x105b48,0x8(%eax)
    info->eip_fn_namelen = 9;
  100606:	8b 45 0c             	mov    0xc(%ebp),%eax
  100609:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100610:	8b 45 0c             	mov    0xc(%ebp),%eax
  100613:	8b 55 08             	mov    0x8(%ebp),%edx
  100616:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100619:	8b 45 0c             	mov    0xc(%ebp),%eax
  10061c:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100623:	c7 45 f4 50 6d 10 00 	movl   $0x106d50,-0xc(%ebp)
    stab_end = __STAB_END__;
  10062a:	c7 45 f0 b0 1b 11 00 	movl   $0x111bb0,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100631:	c7 45 ec b1 1b 11 00 	movl   $0x111bb1,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100638:	c7 45 e8 4b 46 11 00 	movl   $0x11464b,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  10063f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100642:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  100645:	76 0d                	jbe    100654 <debuginfo_eip+0x71>
  100647:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10064a:	83 e8 01             	sub    $0x1,%eax
  10064d:	0f b6 00             	movzbl (%eax),%eax
  100650:	84 c0                	test   %al,%al
  100652:	74 0a                	je     10065e <debuginfo_eip+0x7b>
        return -1;
  100654:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100659:	e9 91 02 00 00       	jmp    1008ef <debuginfo_eip+0x30c>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  10065e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  100665:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100668:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10066b:	29 c2                	sub    %eax,%edx
  10066d:	89 d0                	mov    %edx,%eax
  10066f:	c1 f8 02             	sar    $0x2,%eax
  100672:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  100678:	83 e8 01             	sub    $0x1,%eax
  10067b:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  10067e:	ff 75 08             	pushl  0x8(%ebp)
  100681:	6a 64                	push   $0x64
  100683:	8d 45 e0             	lea    -0x20(%ebp),%eax
  100686:	50                   	push   %eax
  100687:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  10068a:	50                   	push   %eax
  10068b:	ff 75 f4             	pushl  -0xc(%ebp)
  10068e:	e8 f9 fd ff ff       	call   10048c <stab_binsearch>
  100693:	83 c4 14             	add    $0x14,%esp
    if (lfile == 0)
  100696:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100699:	85 c0                	test   %eax,%eax
  10069b:	75 0a                	jne    1006a7 <debuginfo_eip+0xc4>
        return -1;
  10069d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1006a2:	e9 48 02 00 00       	jmp    1008ef <debuginfo_eip+0x30c>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1006a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006aa:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1006ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006b0:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  1006b3:	ff 75 08             	pushl  0x8(%ebp)
  1006b6:	6a 24                	push   $0x24
  1006b8:	8d 45 d8             	lea    -0x28(%ebp),%eax
  1006bb:	50                   	push   %eax
  1006bc:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1006bf:	50                   	push   %eax
  1006c0:	ff 75 f4             	pushl  -0xc(%ebp)
  1006c3:	e8 c4 fd ff ff       	call   10048c <stab_binsearch>
  1006c8:	83 c4 14             	add    $0x14,%esp

    if (lfun <= rfun) {
  1006cb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1006ce:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006d1:	39 c2                	cmp    %eax,%edx
  1006d3:	7f 7c                	jg     100751 <debuginfo_eip+0x16e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  1006d5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006d8:	89 c2                	mov    %eax,%edx
  1006da:	89 d0                	mov    %edx,%eax
  1006dc:	01 c0                	add    %eax,%eax
  1006de:	01 d0                	add    %edx,%eax
  1006e0:	c1 e0 02             	shl    $0x2,%eax
  1006e3:	89 c2                	mov    %eax,%edx
  1006e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006e8:	01 d0                	add    %edx,%eax
  1006ea:	8b 00                	mov    (%eax),%eax
  1006ec:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1006ef:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1006f2:	29 d1                	sub    %edx,%ecx
  1006f4:	89 ca                	mov    %ecx,%edx
  1006f6:	39 d0                	cmp    %edx,%eax
  1006f8:	73 22                	jae    10071c <debuginfo_eip+0x139>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  1006fa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006fd:	89 c2                	mov    %eax,%edx
  1006ff:	89 d0                	mov    %edx,%eax
  100701:	01 c0                	add    %eax,%eax
  100703:	01 d0                	add    %edx,%eax
  100705:	c1 e0 02             	shl    $0x2,%eax
  100708:	89 c2                	mov    %eax,%edx
  10070a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10070d:	01 d0                	add    %edx,%eax
  10070f:	8b 10                	mov    (%eax),%edx
  100711:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100714:	01 c2                	add    %eax,%edx
  100716:	8b 45 0c             	mov    0xc(%ebp),%eax
  100719:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  10071c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10071f:	89 c2                	mov    %eax,%edx
  100721:	89 d0                	mov    %edx,%eax
  100723:	01 c0                	add    %eax,%eax
  100725:	01 d0                	add    %edx,%eax
  100727:	c1 e0 02             	shl    $0x2,%eax
  10072a:	89 c2                	mov    %eax,%edx
  10072c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10072f:	01 d0                	add    %edx,%eax
  100731:	8b 50 08             	mov    0x8(%eax),%edx
  100734:	8b 45 0c             	mov    0xc(%ebp),%eax
  100737:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  10073a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10073d:	8b 40 10             	mov    0x10(%eax),%eax
  100740:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  100743:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100746:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  100749:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10074c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10074f:	eb 15                	jmp    100766 <debuginfo_eip+0x183>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  100751:	8b 45 0c             	mov    0xc(%ebp),%eax
  100754:	8b 55 08             	mov    0x8(%ebp),%edx
  100757:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  10075a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10075d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  100760:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100763:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  100766:	8b 45 0c             	mov    0xc(%ebp),%eax
  100769:	8b 40 08             	mov    0x8(%eax),%eax
  10076c:	83 ec 08             	sub    $0x8,%esp
  10076f:	6a 3a                	push   $0x3a
  100771:	50                   	push   %eax
  100772:	e8 af 49 00 00       	call   105126 <strfind>
  100777:	83 c4 10             	add    $0x10,%esp
  10077a:	89 c2                	mov    %eax,%edx
  10077c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10077f:	8b 40 08             	mov    0x8(%eax),%eax
  100782:	29 c2                	sub    %eax,%edx
  100784:	8b 45 0c             	mov    0xc(%ebp),%eax
  100787:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  10078a:	83 ec 0c             	sub    $0xc,%esp
  10078d:	ff 75 08             	pushl  0x8(%ebp)
  100790:	6a 44                	push   $0x44
  100792:	8d 45 d0             	lea    -0x30(%ebp),%eax
  100795:	50                   	push   %eax
  100796:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  100799:	50                   	push   %eax
  10079a:	ff 75 f4             	pushl  -0xc(%ebp)
  10079d:	e8 ea fc ff ff       	call   10048c <stab_binsearch>
  1007a2:	83 c4 20             	add    $0x20,%esp
    if (lline <= rline) {
  1007a5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007a8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1007ab:	39 c2                	cmp    %eax,%edx
  1007ad:	7f 24                	jg     1007d3 <debuginfo_eip+0x1f0>
        info->eip_line = stabs[rline].n_desc;
  1007af:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1007b2:	89 c2                	mov    %eax,%edx
  1007b4:	89 d0                	mov    %edx,%eax
  1007b6:	01 c0                	add    %eax,%eax
  1007b8:	01 d0                	add    %edx,%eax
  1007ba:	c1 e0 02             	shl    $0x2,%eax
  1007bd:	89 c2                	mov    %eax,%edx
  1007bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007c2:	01 d0                	add    %edx,%eax
  1007c4:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  1007c8:	0f b7 d0             	movzwl %ax,%edx
  1007cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007ce:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  1007d1:	eb 13                	jmp    1007e6 <debuginfo_eip+0x203>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
  1007d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1007d8:	e9 12 01 00 00       	jmp    1008ef <debuginfo_eip+0x30c>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  1007dd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007e0:	83 e8 01             	sub    $0x1,%eax
  1007e3:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  1007e6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007ec:	39 c2                	cmp    %eax,%edx
  1007ee:	7c 56                	jl     100846 <debuginfo_eip+0x263>
           && stabs[lline].n_type != N_SOL
  1007f0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007f3:	89 c2                	mov    %eax,%edx
  1007f5:	89 d0                	mov    %edx,%eax
  1007f7:	01 c0                	add    %eax,%eax
  1007f9:	01 d0                	add    %edx,%eax
  1007fb:	c1 e0 02             	shl    $0x2,%eax
  1007fe:	89 c2                	mov    %eax,%edx
  100800:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100803:	01 d0                	add    %edx,%eax
  100805:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100809:	3c 84                	cmp    $0x84,%al
  10080b:	74 39                	je     100846 <debuginfo_eip+0x263>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  10080d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100810:	89 c2                	mov    %eax,%edx
  100812:	89 d0                	mov    %edx,%eax
  100814:	01 c0                	add    %eax,%eax
  100816:	01 d0                	add    %edx,%eax
  100818:	c1 e0 02             	shl    $0x2,%eax
  10081b:	89 c2                	mov    %eax,%edx
  10081d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100820:	01 d0                	add    %edx,%eax
  100822:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100826:	3c 64                	cmp    $0x64,%al
  100828:	75 b3                	jne    1007dd <debuginfo_eip+0x1fa>
  10082a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10082d:	89 c2                	mov    %eax,%edx
  10082f:	89 d0                	mov    %edx,%eax
  100831:	01 c0                	add    %eax,%eax
  100833:	01 d0                	add    %edx,%eax
  100835:	c1 e0 02             	shl    $0x2,%eax
  100838:	89 c2                	mov    %eax,%edx
  10083a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10083d:	01 d0                	add    %edx,%eax
  10083f:	8b 40 08             	mov    0x8(%eax),%eax
  100842:	85 c0                	test   %eax,%eax
  100844:	74 97                	je     1007dd <debuginfo_eip+0x1fa>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  100846:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100849:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10084c:	39 c2                	cmp    %eax,%edx
  10084e:	7c 46                	jl     100896 <debuginfo_eip+0x2b3>
  100850:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100853:	89 c2                	mov    %eax,%edx
  100855:	89 d0                	mov    %edx,%eax
  100857:	01 c0                	add    %eax,%eax
  100859:	01 d0                	add    %edx,%eax
  10085b:	c1 e0 02             	shl    $0x2,%eax
  10085e:	89 c2                	mov    %eax,%edx
  100860:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100863:	01 d0                	add    %edx,%eax
  100865:	8b 00                	mov    (%eax),%eax
  100867:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  10086a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10086d:	29 d1                	sub    %edx,%ecx
  10086f:	89 ca                	mov    %ecx,%edx
  100871:	39 d0                	cmp    %edx,%eax
  100873:	73 21                	jae    100896 <debuginfo_eip+0x2b3>
        info->eip_file = stabstr + stabs[lline].n_strx;
  100875:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100878:	89 c2                	mov    %eax,%edx
  10087a:	89 d0                	mov    %edx,%eax
  10087c:	01 c0                	add    %eax,%eax
  10087e:	01 d0                	add    %edx,%eax
  100880:	c1 e0 02             	shl    $0x2,%eax
  100883:	89 c2                	mov    %eax,%edx
  100885:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100888:	01 d0                	add    %edx,%eax
  10088a:	8b 10                	mov    (%eax),%edx
  10088c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10088f:	01 c2                	add    %eax,%edx
  100891:	8b 45 0c             	mov    0xc(%ebp),%eax
  100894:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  100896:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100899:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10089c:	39 c2                	cmp    %eax,%edx
  10089e:	7d 4a                	jge    1008ea <debuginfo_eip+0x307>
        for (lline = lfun + 1;
  1008a0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1008a3:	83 c0 01             	add    $0x1,%eax
  1008a6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  1008a9:	eb 18                	jmp    1008c3 <debuginfo_eip+0x2e0>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  1008ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008ae:	8b 40 14             	mov    0x14(%eax),%eax
  1008b1:	8d 50 01             	lea    0x1(%eax),%edx
  1008b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008b7:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
  1008ba:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008bd:	83 c0 01             	add    $0x1,%eax
  1008c0:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
  1008c3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1008c6:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
  1008c9:	39 c2                	cmp    %eax,%edx
  1008cb:	7d 1d                	jge    1008ea <debuginfo_eip+0x307>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  1008cd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008d0:	89 c2                	mov    %eax,%edx
  1008d2:	89 d0                	mov    %edx,%eax
  1008d4:	01 c0                	add    %eax,%eax
  1008d6:	01 d0                	add    %edx,%eax
  1008d8:	c1 e0 02             	shl    $0x2,%eax
  1008db:	89 c2                	mov    %eax,%edx
  1008dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008e0:	01 d0                	add    %edx,%eax
  1008e2:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1008e6:	3c a0                	cmp    $0xa0,%al
  1008e8:	74 c1                	je     1008ab <debuginfo_eip+0x2c8>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
  1008ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1008ef:	c9                   	leave  
  1008f0:	c3                   	ret    

001008f1 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  1008f1:	55                   	push   %ebp
  1008f2:	89 e5                	mov    %esp,%ebp
  1008f4:	83 ec 08             	sub    $0x8,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  1008f7:	83 ec 0c             	sub    $0xc,%esp
  1008fa:	68 52 5b 10 00       	push   $0x105b52
  1008ff:	e8 63 f9 ff ff       	call   100267 <cprintf>
  100904:	83 c4 10             	add    $0x10,%esp
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100907:	83 ec 08             	sub    $0x8,%esp
  10090a:	68 2a 00 10 00       	push   $0x10002a
  10090f:	68 6b 5b 10 00       	push   $0x105b6b
  100914:	e8 4e f9 ff ff       	call   100267 <cprintf>
  100919:	83 c4 10             	add    $0x10,%esp
    cprintf("  etext  0x%08x (phys)\n", etext);
  10091c:	83 ec 08             	sub    $0x8,%esp
  10091f:	68 49 5a 10 00       	push   $0x105a49
  100924:	68 83 5b 10 00       	push   $0x105b83
  100929:	e8 39 f9 ff ff       	call   100267 <cprintf>
  10092e:	83 c4 10             	add    $0x10,%esp
    cprintf("  edata  0x%08x (phys)\n", edata);
  100931:	83 ec 08             	sub    $0x8,%esp
  100934:	68 36 7a 11 00       	push   $0x117a36
  100939:	68 9b 5b 10 00       	push   $0x105b9b
  10093e:	e8 24 f9 ff ff       	call   100267 <cprintf>
  100943:	83 c4 10             	add    $0x10,%esp
    cprintf("  end    0x%08x (phys)\n", end);
  100946:	83 ec 08             	sub    $0x8,%esp
  100949:	68 68 89 11 00       	push   $0x118968
  10094e:	68 b3 5b 10 00       	push   $0x105bb3
  100953:	e8 0f f9 ff ff       	call   100267 <cprintf>
  100958:	83 c4 10             	add    $0x10,%esp
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  10095b:	b8 68 89 11 00       	mov    $0x118968,%eax
  100960:	05 ff 03 00 00       	add    $0x3ff,%eax
  100965:	ba 2a 00 10 00       	mov    $0x10002a,%edx
  10096a:	29 d0                	sub    %edx,%eax
  10096c:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  100972:	85 c0                	test   %eax,%eax
  100974:	0f 48 c2             	cmovs  %edx,%eax
  100977:	c1 f8 0a             	sar    $0xa,%eax
  10097a:	83 ec 08             	sub    $0x8,%esp
  10097d:	50                   	push   %eax
  10097e:	68 cc 5b 10 00       	push   $0x105bcc
  100983:	e8 df f8 ff ff       	call   100267 <cprintf>
  100988:	83 c4 10             	add    $0x10,%esp
}
  10098b:	90                   	nop
  10098c:	c9                   	leave  
  10098d:	c3                   	ret    

0010098e <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  10098e:	55                   	push   %ebp
  10098f:	89 e5                	mov    %esp,%ebp
  100991:	81 ec 28 01 00 00    	sub    $0x128,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  100997:	83 ec 08             	sub    $0x8,%esp
  10099a:	8d 45 dc             	lea    -0x24(%ebp),%eax
  10099d:	50                   	push   %eax
  10099e:	ff 75 08             	pushl  0x8(%ebp)
  1009a1:	e8 3d fc ff ff       	call   1005e3 <debuginfo_eip>
  1009a6:	83 c4 10             	add    $0x10,%esp
  1009a9:	85 c0                	test   %eax,%eax
  1009ab:	74 15                	je     1009c2 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  1009ad:	83 ec 08             	sub    $0x8,%esp
  1009b0:	ff 75 08             	pushl  0x8(%ebp)
  1009b3:	68 f6 5b 10 00       	push   $0x105bf6
  1009b8:	e8 aa f8 ff ff       	call   100267 <cprintf>
  1009bd:	83 c4 10             	add    $0x10,%esp
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
  1009c0:	eb 65                	jmp    100a27 <print_debuginfo+0x99>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  1009c2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1009c9:	eb 1c                	jmp    1009e7 <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  1009cb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1009ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009d1:	01 d0                	add    %edx,%eax
  1009d3:	0f b6 00             	movzbl (%eax),%eax
  1009d6:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  1009dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1009df:	01 ca                	add    %ecx,%edx
  1009e1:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  1009e3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1009e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1009ea:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1009ed:	7f dc                	jg     1009cb <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
  1009ef:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  1009f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009f8:	01 d0                	add    %edx,%eax
  1009fa:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  1009fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100a00:	8b 55 08             	mov    0x8(%ebp),%edx
  100a03:	89 d1                	mov    %edx,%ecx
  100a05:	29 c1                	sub    %eax,%ecx
  100a07:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100a0a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100a0d:	83 ec 0c             	sub    $0xc,%esp
  100a10:	51                   	push   %ecx
  100a11:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a17:	51                   	push   %ecx
  100a18:	52                   	push   %edx
  100a19:	50                   	push   %eax
  100a1a:	68 12 5c 10 00       	push   $0x105c12
  100a1f:	e8 43 f8 ff ff       	call   100267 <cprintf>
  100a24:	83 c4 20             	add    $0x20,%esp
                fnname, eip - info.eip_fn_addr);
    }
}
  100a27:	90                   	nop
  100a28:	c9                   	leave  
  100a29:	c3                   	ret    

00100a2a <read_eip>:

static __noinline uint32_t
read_eip(void) {
  100a2a:	55                   	push   %ebp
  100a2b:	89 e5                	mov    %esp,%ebp
  100a2d:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100a30:	8b 45 04             	mov    0x4(%ebp),%eax
  100a33:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100a36:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100a39:	c9                   	leave  
  100a3a:	c3                   	ret    

00100a3b <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100a3b:	55                   	push   %ebp
  100a3c:	89 e5                	mov    %esp,%ebp
  100a3e:	83 ec 28             	sub    $0x28,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100a41:	89 e8                	mov    %ebp,%eax
  100a43:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
  100a46:	8b 45 e0             	mov    -0x20(%ebp),%eax
              临时变量n
              ……
      高地址:
      */

      uint32_t ebp = read_ebp(); //ebp为当前栈存放ebp的地址
  100a49:	89 45 f4             	mov    %eax,-0xc(%ebp)
      uint32_t eip = read_eip(); //eip为当前栈存放eip的地址
  100a4c:	e8 d9 ff ff ff       	call   100a2a <read_eip>
  100a51:	89 45 f0             	mov    %eax,-0x10(%ebp)
      int i, j;

      for(i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i++)
  100a54:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  100a5b:	eb 7d                	jmp    100ada <print_stackframe+0x9f>
      {
              cprintf("ebp : 0x%08x, eip : 0x%08x  args:", ebp, eip);
  100a5d:	83 ec 04             	sub    $0x4,%esp
  100a60:	ff 75 f0             	pushl  -0x10(%ebp)
  100a63:	ff 75 f4             	pushl  -0xc(%ebp)
  100a66:	68 24 5c 10 00       	push   $0x105c24
  100a6b:	e8 f7 f7 ff ff       	call   100267 <cprintf>
  100a70:	83 c4 10             	add    $0x10,%esp

              uint32_t *args = (uint32_t *)ebp + 2; 
  100a73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a76:	83 c0 08             	add    $0x8,%eax
  100a79:	89 45 e4             	mov    %eax,-0x1c(%ebp)
              for(j = 0; j < 4; j++)
  100a7c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  100a83:	eb 26                	jmp    100aab <print_stackframe+0x70>
                      cprintf("0x%08x ", args[j]);
  100a85:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a88:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100a8f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100a92:	01 d0                	add    %edx,%eax
  100a94:	8b 00                	mov    (%eax),%eax
  100a96:	83 ec 08             	sub    $0x8,%esp
  100a99:	50                   	push   %eax
  100a9a:	68 46 5c 10 00       	push   $0x105c46
  100a9f:	e8 c3 f7 ff ff       	call   100267 <cprintf>
  100aa4:	83 c4 10             	add    $0x10,%esp
      for(i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i++)
      {
              cprintf("ebp : 0x%08x, eip : 0x%08x  args:", ebp, eip);

              uint32_t *args = (uint32_t *)ebp + 2; 
              for(j = 0; j < 4; j++)
  100aa7:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  100aab:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100aaf:	7e d4                	jle    100a85 <print_stackframe+0x4a>
                      cprintf("0x%08x ", args[j]);

              print_debuginfo(eip - 1);
  100ab1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100ab4:	83 e8 01             	sub    $0x1,%eax
  100ab7:	83 ec 0c             	sub    $0xc,%esp
  100aba:	50                   	push   %eax
  100abb:	e8 ce fe ff ff       	call   10098e <print_debuginfo>
  100ac0:	83 c4 10             	add    $0x10,%esp

              eip = ((uint32_t *)ebp)[1]; //取出存在栈中的地址，ebp[1]指向返回本次调用后的下一条指令
  100ac3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ac6:	83 c0 04             	add    $0x4,%eax
  100ac9:	8b 00                	mov    (%eax),%eax
  100acb:	89 45 f0             	mov    %eax,-0x10(%ebp)
              ebp = ((uint32_t *)ebp)[0]; //取出存在栈中的地址，ebp[0]指向其调用者函数的ebp
  100ace:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ad1:	8b 00                	mov    (%eax),%eax
  100ad3:	89 45 f4             	mov    %eax,-0xc(%ebp)

      uint32_t ebp = read_ebp(); //ebp为当前栈存放ebp的地址
      uint32_t eip = read_eip(); //eip为当前栈存放eip的地址
      int i, j;

      for(i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i++)
  100ad6:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100ada:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100ade:	74 0a                	je     100aea <print_stackframe+0xaf>
  100ae0:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100ae4:	0f 8e 73 ff ff ff    	jle    100a5d <print_stackframe+0x22>
              eip = ((uint32_t *)ebp)[1]; //取出存在栈中的地址，ebp[1]指向返回本次调用后的下一条指令
              ebp = ((uint32_t *)ebp)[0]; //取出存在栈中的地址，ebp[0]指向其调用者函数的ebp

      }

}
  100aea:	90                   	nop
  100aeb:	c9                   	leave  
  100aec:	c3                   	ret    

00100aed <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100aed:	55                   	push   %ebp
  100aee:	89 e5                	mov    %esp,%ebp
  100af0:	83 ec 18             	sub    $0x18,%esp
    int argc = 0;
  100af3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100afa:	eb 0c                	jmp    100b08 <parse+0x1b>
            *buf ++ = '\0';
  100afc:	8b 45 08             	mov    0x8(%ebp),%eax
  100aff:	8d 50 01             	lea    0x1(%eax),%edx
  100b02:	89 55 08             	mov    %edx,0x8(%ebp)
  100b05:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b08:	8b 45 08             	mov    0x8(%ebp),%eax
  100b0b:	0f b6 00             	movzbl (%eax),%eax
  100b0e:	84 c0                	test   %al,%al
  100b10:	74 1e                	je     100b30 <parse+0x43>
  100b12:	8b 45 08             	mov    0x8(%ebp),%eax
  100b15:	0f b6 00             	movzbl (%eax),%eax
  100b18:	0f be c0             	movsbl %al,%eax
  100b1b:	83 ec 08             	sub    $0x8,%esp
  100b1e:	50                   	push   %eax
  100b1f:	68 d0 5c 10 00       	push   $0x105cd0
  100b24:	e8 ca 45 00 00       	call   1050f3 <strchr>
  100b29:	83 c4 10             	add    $0x10,%esp
  100b2c:	85 c0                	test   %eax,%eax
  100b2e:	75 cc                	jne    100afc <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100b30:	8b 45 08             	mov    0x8(%ebp),%eax
  100b33:	0f b6 00             	movzbl (%eax),%eax
  100b36:	84 c0                	test   %al,%al
  100b38:	74 69                	je     100ba3 <parse+0xb6>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100b3a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100b3e:	75 12                	jne    100b52 <parse+0x65>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100b40:	83 ec 08             	sub    $0x8,%esp
  100b43:	6a 10                	push   $0x10
  100b45:	68 d5 5c 10 00       	push   $0x105cd5
  100b4a:	e8 18 f7 ff ff       	call   100267 <cprintf>
  100b4f:	83 c4 10             	add    $0x10,%esp
        }
        argv[argc ++] = buf;
  100b52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b55:	8d 50 01             	lea    0x1(%eax),%edx
  100b58:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100b5b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100b62:	8b 45 0c             	mov    0xc(%ebp),%eax
  100b65:	01 c2                	add    %eax,%edx
  100b67:	8b 45 08             	mov    0x8(%ebp),%eax
  100b6a:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b6c:	eb 04                	jmp    100b72 <parse+0x85>
            buf ++;
  100b6e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b72:	8b 45 08             	mov    0x8(%ebp),%eax
  100b75:	0f b6 00             	movzbl (%eax),%eax
  100b78:	84 c0                	test   %al,%al
  100b7a:	0f 84 7a ff ff ff    	je     100afa <parse+0xd>
  100b80:	8b 45 08             	mov    0x8(%ebp),%eax
  100b83:	0f b6 00             	movzbl (%eax),%eax
  100b86:	0f be c0             	movsbl %al,%eax
  100b89:	83 ec 08             	sub    $0x8,%esp
  100b8c:	50                   	push   %eax
  100b8d:	68 d0 5c 10 00       	push   $0x105cd0
  100b92:	e8 5c 45 00 00       	call   1050f3 <strchr>
  100b97:	83 c4 10             	add    $0x10,%esp
  100b9a:	85 c0                	test   %eax,%eax
  100b9c:	74 d0                	je     100b6e <parse+0x81>
            buf ++;
        }
    }
  100b9e:	e9 57 ff ff ff       	jmp    100afa <parse+0xd>
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
            break;
  100ba3:	90                   	nop
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100ba4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100ba7:	c9                   	leave  
  100ba8:	c3                   	ret    

00100ba9 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100ba9:	55                   	push   %ebp
  100baa:	89 e5                	mov    %esp,%ebp
  100bac:	83 ec 58             	sub    $0x58,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100baf:	83 ec 08             	sub    $0x8,%esp
  100bb2:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100bb5:	50                   	push   %eax
  100bb6:	ff 75 08             	pushl  0x8(%ebp)
  100bb9:	e8 2f ff ff ff       	call   100aed <parse>
  100bbe:	83 c4 10             	add    $0x10,%esp
  100bc1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100bc4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100bc8:	75 0a                	jne    100bd4 <runcmd+0x2b>
        return 0;
  100bca:	b8 00 00 00 00       	mov    $0x0,%eax
  100bcf:	e9 83 00 00 00       	jmp    100c57 <runcmd+0xae>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100bd4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100bdb:	eb 59                	jmp    100c36 <runcmd+0x8d>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100bdd:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100be0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100be3:	89 d0                	mov    %edx,%eax
  100be5:	01 c0                	add    %eax,%eax
  100be7:	01 d0                	add    %edx,%eax
  100be9:	c1 e0 02             	shl    $0x2,%eax
  100bec:	05 20 70 11 00       	add    $0x117020,%eax
  100bf1:	8b 00                	mov    (%eax),%eax
  100bf3:	83 ec 08             	sub    $0x8,%esp
  100bf6:	51                   	push   %ecx
  100bf7:	50                   	push   %eax
  100bf8:	e8 56 44 00 00       	call   105053 <strcmp>
  100bfd:	83 c4 10             	add    $0x10,%esp
  100c00:	85 c0                	test   %eax,%eax
  100c02:	75 2e                	jne    100c32 <runcmd+0x89>
            return commands[i].func(argc - 1, argv + 1, tf);
  100c04:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c07:	89 d0                	mov    %edx,%eax
  100c09:	01 c0                	add    %eax,%eax
  100c0b:	01 d0                	add    %edx,%eax
  100c0d:	c1 e0 02             	shl    $0x2,%eax
  100c10:	05 28 70 11 00       	add    $0x117028,%eax
  100c15:	8b 10                	mov    (%eax),%edx
  100c17:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100c1a:	83 c0 04             	add    $0x4,%eax
  100c1d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100c20:	83 e9 01             	sub    $0x1,%ecx
  100c23:	83 ec 04             	sub    $0x4,%esp
  100c26:	ff 75 0c             	pushl  0xc(%ebp)
  100c29:	50                   	push   %eax
  100c2a:	51                   	push   %ecx
  100c2b:	ff d2                	call   *%edx
  100c2d:	83 c4 10             	add    $0x10,%esp
  100c30:	eb 25                	jmp    100c57 <runcmd+0xae>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c32:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c39:	83 f8 02             	cmp    $0x2,%eax
  100c3c:	76 9f                	jbe    100bdd <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100c3e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100c41:	83 ec 08             	sub    $0x8,%esp
  100c44:	50                   	push   %eax
  100c45:	68 f3 5c 10 00       	push   $0x105cf3
  100c4a:	e8 18 f6 ff ff       	call   100267 <cprintf>
  100c4f:	83 c4 10             	add    $0x10,%esp
    return 0;
  100c52:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c57:	c9                   	leave  
  100c58:	c3                   	ret    

00100c59 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100c59:	55                   	push   %ebp
  100c5a:	89 e5                	mov    %esp,%ebp
  100c5c:	83 ec 18             	sub    $0x18,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100c5f:	83 ec 0c             	sub    $0xc,%esp
  100c62:	68 0c 5d 10 00       	push   $0x105d0c
  100c67:	e8 fb f5 ff ff       	call   100267 <cprintf>
  100c6c:	83 c4 10             	add    $0x10,%esp
    cprintf("Type 'help' for a list of commands.\n");
  100c6f:	83 ec 0c             	sub    $0xc,%esp
  100c72:	68 34 5d 10 00       	push   $0x105d34
  100c77:	e8 eb f5 ff ff       	call   100267 <cprintf>
  100c7c:	83 c4 10             	add    $0x10,%esp

    if (tf != NULL) {
  100c7f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100c83:	74 0e                	je     100c93 <kmonitor+0x3a>
        print_trapframe(tf);
  100c85:	83 ec 0c             	sub    $0xc,%esp
  100c88:	ff 75 08             	pushl  0x8(%ebp)
  100c8b:	e8 9f 0d 00 00       	call   101a2f <print_trapframe>
  100c90:	83 c4 10             	add    $0x10,%esp
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100c93:	83 ec 0c             	sub    $0xc,%esp
  100c96:	68 59 5d 10 00       	push   $0x105d59
  100c9b:	e8 6b f6 ff ff       	call   10030b <readline>
  100ca0:	83 c4 10             	add    $0x10,%esp
  100ca3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100ca6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100caa:	74 e7                	je     100c93 <kmonitor+0x3a>
            if (runcmd(buf, tf) < 0) {
  100cac:	83 ec 08             	sub    $0x8,%esp
  100caf:	ff 75 08             	pushl  0x8(%ebp)
  100cb2:	ff 75 f4             	pushl  -0xc(%ebp)
  100cb5:	e8 ef fe ff ff       	call   100ba9 <runcmd>
  100cba:	83 c4 10             	add    $0x10,%esp
  100cbd:	85 c0                	test   %eax,%eax
  100cbf:	78 02                	js     100cc3 <kmonitor+0x6a>
                break;
            }
        }
    }
  100cc1:	eb d0                	jmp    100c93 <kmonitor+0x3a>

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
            if (runcmd(buf, tf) < 0) {
                break;
  100cc3:	90                   	nop
            }
        }
    }
}
  100cc4:	90                   	nop
  100cc5:	c9                   	leave  
  100cc6:	c3                   	ret    

00100cc7 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100cc7:	55                   	push   %ebp
  100cc8:	89 e5                	mov    %esp,%ebp
  100cca:	83 ec 18             	sub    $0x18,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100ccd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100cd4:	eb 3c                	jmp    100d12 <mon_help+0x4b>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100cd6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100cd9:	89 d0                	mov    %edx,%eax
  100cdb:	01 c0                	add    %eax,%eax
  100cdd:	01 d0                	add    %edx,%eax
  100cdf:	c1 e0 02             	shl    $0x2,%eax
  100ce2:	05 24 70 11 00       	add    $0x117024,%eax
  100ce7:	8b 08                	mov    (%eax),%ecx
  100ce9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100cec:	89 d0                	mov    %edx,%eax
  100cee:	01 c0                	add    %eax,%eax
  100cf0:	01 d0                	add    %edx,%eax
  100cf2:	c1 e0 02             	shl    $0x2,%eax
  100cf5:	05 20 70 11 00       	add    $0x117020,%eax
  100cfa:	8b 00                	mov    (%eax),%eax
  100cfc:	83 ec 04             	sub    $0x4,%esp
  100cff:	51                   	push   %ecx
  100d00:	50                   	push   %eax
  100d01:	68 5d 5d 10 00       	push   $0x105d5d
  100d06:	e8 5c f5 ff ff       	call   100267 <cprintf>
  100d0b:	83 c4 10             	add    $0x10,%esp

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100d0e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100d12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d15:	83 f8 02             	cmp    $0x2,%eax
  100d18:	76 bc                	jbe    100cd6 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100d1a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d1f:	c9                   	leave  
  100d20:	c3                   	ret    

00100d21 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100d21:	55                   	push   %ebp
  100d22:	89 e5                	mov    %esp,%ebp
  100d24:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100d27:	e8 c5 fb ff ff       	call   1008f1 <print_kerninfo>
    return 0;
  100d2c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d31:	c9                   	leave  
  100d32:	c3                   	ret    

00100d33 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100d33:	55                   	push   %ebp
  100d34:	89 e5                	mov    %esp,%ebp
  100d36:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100d39:	e8 fd fc ff ff       	call   100a3b <print_stackframe>
    return 0;
  100d3e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d43:	c9                   	leave  
  100d44:	c3                   	ret    

00100d45 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d45:	55                   	push   %ebp
  100d46:	89 e5                	mov    %esp,%ebp
  100d48:	83 ec 18             	sub    $0x18,%esp
  100d4b:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100d51:	c6 45 ef 34          	movb   $0x34,-0x11(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100d55:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
  100d59:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100d5d:	ee                   	out    %al,(%dx)
  100d5e:	66 c7 45 f4 40 00    	movw   $0x40,-0xc(%ebp)
  100d64:	c6 45 f0 9c          	movb   $0x9c,-0x10(%ebp)
  100d68:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
  100d6c:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
  100d70:	ee                   	out    %al,(%dx)
  100d71:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100d77:	c6 45 f1 2e          	movb   $0x2e,-0xf(%ebp)
  100d7b:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100d7f:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100d83:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100d84:	c7 05 4c 89 11 00 00 	movl   $0x0,0x11894c
  100d8b:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100d8e:	83 ec 0c             	sub    $0xc,%esp
  100d91:	68 66 5d 10 00       	push   $0x105d66
  100d96:	e8 cc f4 ff ff       	call   100267 <cprintf>
  100d9b:	83 c4 10             	add    $0x10,%esp
    pic_enable(IRQ_TIMER);
  100d9e:	83 ec 0c             	sub    $0xc,%esp
  100da1:	6a 00                	push   $0x0
  100da3:	e8 3b 09 00 00       	call   1016e3 <pic_enable>
  100da8:	83 c4 10             	add    $0x10,%esp
}
  100dab:	90                   	nop
  100dac:	c9                   	leave  
  100dad:	c3                   	ret    

00100dae <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  100dae:	55                   	push   %ebp
  100daf:	89 e5                	mov    %esp,%ebp
  100db1:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  100db4:	9c                   	pushf  
  100db5:	58                   	pop    %eax
  100db6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  100db9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  100dbc:	25 00 02 00 00       	and    $0x200,%eax
  100dc1:	85 c0                	test   %eax,%eax
  100dc3:	74 0c                	je     100dd1 <__intr_save+0x23>
        intr_disable();
  100dc5:	e8 8a 0a 00 00       	call   101854 <intr_disable>
        return 1;
  100dca:	b8 01 00 00 00       	mov    $0x1,%eax
  100dcf:	eb 05                	jmp    100dd6 <__intr_save+0x28>
    }
    return 0;
  100dd1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100dd6:	c9                   	leave  
  100dd7:	c3                   	ret    

00100dd8 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  100dd8:	55                   	push   %ebp
  100dd9:	89 e5                	mov    %esp,%ebp
  100ddb:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  100dde:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100de2:	74 05                	je     100de9 <__intr_restore+0x11>
        intr_enable();
  100de4:	e8 64 0a 00 00       	call   10184d <intr_enable>
    }
}
  100de9:	90                   	nop
  100dea:	c9                   	leave  
  100deb:	c3                   	ret    

00100dec <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100dec:	55                   	push   %ebp
  100ded:	89 e5                	mov    %esp,%ebp
  100def:	83 ec 10             	sub    $0x10,%esp
  100df2:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100df8:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100dfc:	89 c2                	mov    %eax,%edx
  100dfe:	ec                   	in     (%dx),%al
  100dff:	88 45 f4             	mov    %al,-0xc(%ebp)
  100e02:	66 c7 45 fc 84 00    	movw   $0x84,-0x4(%ebp)
  100e08:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
  100e0c:	89 c2                	mov    %eax,%edx
  100e0e:	ec                   	in     (%dx),%al
  100e0f:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e12:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100e18:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100e1c:	89 c2                	mov    %eax,%edx
  100e1e:	ec                   	in     (%dx),%al
  100e1f:	88 45 f6             	mov    %al,-0xa(%ebp)
  100e22:	66 c7 45 f8 84 00    	movw   $0x84,-0x8(%ebp)
  100e28:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
  100e2c:	89 c2                	mov    %eax,%edx
  100e2e:	ec                   	in     (%dx),%al
  100e2f:	88 45 f7             	mov    %al,-0x9(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e32:	90                   	nop
  100e33:	c9                   	leave  
  100e34:	c3                   	ret    

00100e35 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100e35:	55                   	push   %ebp
  100e36:	89 e5                	mov    %esp,%ebp
  100e38:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
  100e3b:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
  100e42:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e45:	0f b7 00             	movzwl (%eax),%eax
  100e48:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100e4c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e4f:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100e54:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e57:	0f b7 00             	movzwl (%eax),%eax
  100e5a:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100e5e:	74 12                	je     100e72 <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
  100e60:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100e67:	66 c7 05 86 7e 11 00 	movw   $0x3b4,0x117e86
  100e6e:	b4 03 
  100e70:	eb 13                	jmp    100e85 <cga_init+0x50>
    } else {
        *cp = was;
  100e72:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e75:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100e79:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100e7c:	66 c7 05 86 7e 11 00 	movw   $0x3d4,0x117e86
  100e83:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100e85:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100e8c:	0f b7 c0             	movzwl %ax,%eax
  100e8f:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
  100e93:	c6 45 ea 0e          	movb   $0xe,-0x16(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100e97:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
  100e9b:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  100e9f:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  100ea0:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100ea7:	83 c0 01             	add    $0x1,%eax
  100eaa:	0f b7 c0             	movzwl %ax,%eax
  100ead:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100eb1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100eb5:	89 c2                	mov    %eax,%edx
  100eb7:	ec                   	in     (%dx),%al
  100eb8:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  100ebb:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
  100ebf:	0f b6 c0             	movzbl %al,%eax
  100ec2:	c1 e0 08             	shl    $0x8,%eax
  100ec5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100ec8:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100ecf:	0f b7 c0             	movzwl %ax,%eax
  100ed2:	66 89 45 f0          	mov    %ax,-0x10(%ebp)
  100ed6:	c6 45 ec 0f          	movb   $0xf,-0x14(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100eda:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
  100ede:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  100ee2:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  100ee3:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100eea:	83 c0 01             	add    $0x1,%eax
  100eed:	0f b7 c0             	movzwl %ax,%eax
  100ef0:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100ef4:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100ef8:	89 c2                	mov    %eax,%edx
  100efa:	ec                   	in     (%dx),%al
  100efb:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100efe:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f02:	0f b6 c0             	movzbl %al,%eax
  100f05:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100f08:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f0b:	a3 80 7e 11 00       	mov    %eax,0x117e80
    crt_pos = pos;
  100f10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f13:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
}
  100f19:	90                   	nop
  100f1a:	c9                   	leave  
  100f1b:	c3                   	ret    

00100f1c <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f1c:	55                   	push   %ebp
  100f1d:	89 e5                	mov    %esp,%ebp
  100f1f:	83 ec 28             	sub    $0x28,%esp
  100f22:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100f28:	c6 45 da 00          	movb   $0x0,-0x26(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f2c:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
  100f30:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100f34:	ee                   	out    %al,(%dx)
  100f35:	66 c7 45 f4 fb 03    	movw   $0x3fb,-0xc(%ebp)
  100f3b:	c6 45 db 80          	movb   $0x80,-0x25(%ebp)
  100f3f:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
  100f43:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
  100f47:	ee                   	out    %al,(%dx)
  100f48:	66 c7 45 f2 f8 03    	movw   $0x3f8,-0xe(%ebp)
  100f4e:	c6 45 dc 0c          	movb   $0xc,-0x24(%ebp)
  100f52:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
  100f56:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100f5a:	ee                   	out    %al,(%dx)
  100f5b:	66 c7 45 f0 f9 03    	movw   $0x3f9,-0x10(%ebp)
  100f61:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
  100f65:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100f69:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  100f6d:	ee                   	out    %al,(%dx)
  100f6e:	66 c7 45 ee fb 03    	movw   $0x3fb,-0x12(%ebp)
  100f74:	c6 45 de 03          	movb   $0x3,-0x22(%ebp)
  100f78:	0f b6 45 de          	movzbl -0x22(%ebp),%eax
  100f7c:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f80:	ee                   	out    %al,(%dx)
  100f81:	66 c7 45 ec fc 03    	movw   $0x3fc,-0x14(%ebp)
  100f87:	c6 45 df 00          	movb   $0x0,-0x21(%ebp)
  100f8b:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
  100f8f:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
  100f93:	ee                   	out    %al,(%dx)
  100f94:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100f9a:	c6 45 e0 01          	movb   $0x1,-0x20(%ebp)
  100f9e:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
  100fa2:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100fa6:	ee                   	out    %al,(%dx)
  100fa7:	66 c7 45 e8 fd 03    	movw   $0x3fd,-0x18(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100fad:	0f b7 45 e8          	movzwl -0x18(%ebp),%eax
  100fb1:	89 c2                	mov    %eax,%edx
  100fb3:	ec                   	in     (%dx),%al
  100fb4:	88 45 e1             	mov    %al,-0x1f(%ebp)
    return data;
  100fb7:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100fbb:	3c ff                	cmp    $0xff,%al
  100fbd:	0f 95 c0             	setne  %al
  100fc0:	0f b6 c0             	movzbl %al,%eax
  100fc3:	a3 88 7e 11 00       	mov    %eax,0x117e88
  100fc8:	66 c7 45 e6 fa 03    	movw   $0x3fa,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100fce:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100fd2:	89 c2                	mov    %eax,%edx
  100fd4:	ec                   	in     (%dx),%al
  100fd5:	88 45 e2             	mov    %al,-0x1e(%ebp)
  100fd8:	66 c7 45 e4 f8 03    	movw   $0x3f8,-0x1c(%ebp)
  100fde:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
  100fe2:	89 c2                	mov    %eax,%edx
  100fe4:	ec                   	in     (%dx),%al
  100fe5:	88 45 e3             	mov    %al,-0x1d(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  100fe8:	a1 88 7e 11 00       	mov    0x117e88,%eax
  100fed:	85 c0                	test   %eax,%eax
  100fef:	74 0d                	je     100ffe <serial_init+0xe2>
        pic_enable(IRQ_COM1);
  100ff1:	83 ec 0c             	sub    $0xc,%esp
  100ff4:	6a 04                	push   $0x4
  100ff6:	e8 e8 06 00 00       	call   1016e3 <pic_enable>
  100ffb:	83 c4 10             	add    $0x10,%esp
    }
}
  100ffe:	90                   	nop
  100fff:	c9                   	leave  
  101000:	c3                   	ret    

00101001 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  101001:	55                   	push   %ebp
  101002:	89 e5                	mov    %esp,%ebp
  101004:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101007:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10100e:	eb 09                	jmp    101019 <lpt_putc_sub+0x18>
        delay();
  101010:	e8 d7 fd ff ff       	call   100dec <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101015:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101019:	66 c7 45 f4 79 03    	movw   $0x379,-0xc(%ebp)
  10101f:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  101023:	89 c2                	mov    %eax,%edx
  101025:	ec                   	in     (%dx),%al
  101026:	88 45 f3             	mov    %al,-0xd(%ebp)
    return data;
  101029:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10102d:	84 c0                	test   %al,%al
  10102f:	78 09                	js     10103a <lpt_putc_sub+0x39>
  101031:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101038:	7e d6                	jle    101010 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  10103a:	8b 45 08             	mov    0x8(%ebp),%eax
  10103d:	0f b6 c0             	movzbl %al,%eax
  101040:	66 c7 45 f8 78 03    	movw   $0x378,-0x8(%ebp)
  101046:	88 45 f0             	mov    %al,-0x10(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101049:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
  10104d:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  101051:	ee                   	out    %al,(%dx)
  101052:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  101058:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  10105c:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101060:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101064:	ee                   	out    %al,(%dx)
  101065:	66 c7 45 fa 7a 03    	movw   $0x37a,-0x6(%ebp)
  10106b:	c6 45 f2 08          	movb   $0x8,-0xe(%ebp)
  10106f:	0f b6 45 f2          	movzbl -0xe(%ebp),%eax
  101073:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101077:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  101078:	90                   	nop
  101079:	c9                   	leave  
  10107a:	c3                   	ret    

0010107b <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  10107b:	55                   	push   %ebp
  10107c:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
  10107e:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101082:	74 0d                	je     101091 <lpt_putc+0x16>
        lpt_putc_sub(c);
  101084:	ff 75 08             	pushl  0x8(%ebp)
  101087:	e8 75 ff ff ff       	call   101001 <lpt_putc_sub>
  10108c:	83 c4 04             	add    $0x4,%esp
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  10108f:	eb 1e                	jmp    1010af <lpt_putc+0x34>
lpt_putc(int c) {
    if (c != '\b') {
        lpt_putc_sub(c);
    }
    else {
        lpt_putc_sub('\b');
  101091:	6a 08                	push   $0x8
  101093:	e8 69 ff ff ff       	call   101001 <lpt_putc_sub>
  101098:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub(' ');
  10109b:	6a 20                	push   $0x20
  10109d:	e8 5f ff ff ff       	call   101001 <lpt_putc_sub>
  1010a2:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub('\b');
  1010a5:	6a 08                	push   $0x8
  1010a7:	e8 55 ff ff ff       	call   101001 <lpt_putc_sub>
  1010ac:	83 c4 04             	add    $0x4,%esp
    }
}
  1010af:	90                   	nop
  1010b0:	c9                   	leave  
  1010b1:	c3                   	ret    

001010b2 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  1010b2:	55                   	push   %ebp
  1010b3:	89 e5                	mov    %esp,%ebp
  1010b5:	53                   	push   %ebx
  1010b6:	83 ec 14             	sub    $0x14,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  1010b9:	8b 45 08             	mov    0x8(%ebp),%eax
  1010bc:	b0 00                	mov    $0x0,%al
  1010be:	85 c0                	test   %eax,%eax
  1010c0:	75 07                	jne    1010c9 <cga_putc+0x17>
        c |= 0x0700;
  1010c2:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  1010c9:	8b 45 08             	mov    0x8(%ebp),%eax
  1010cc:	0f b6 c0             	movzbl %al,%eax
  1010cf:	83 f8 0a             	cmp    $0xa,%eax
  1010d2:	74 4e                	je     101122 <cga_putc+0x70>
  1010d4:	83 f8 0d             	cmp    $0xd,%eax
  1010d7:	74 59                	je     101132 <cga_putc+0x80>
  1010d9:	83 f8 08             	cmp    $0x8,%eax
  1010dc:	0f 85 8a 00 00 00    	jne    10116c <cga_putc+0xba>
    case '\b':
        if (crt_pos > 0) {
  1010e2:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  1010e9:	66 85 c0             	test   %ax,%ax
  1010ec:	0f 84 a0 00 00 00    	je     101192 <cga_putc+0xe0>
            crt_pos --;
  1010f2:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  1010f9:	83 e8 01             	sub    $0x1,%eax
  1010fc:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  101102:	a1 80 7e 11 00       	mov    0x117e80,%eax
  101107:	0f b7 15 84 7e 11 00 	movzwl 0x117e84,%edx
  10110e:	0f b7 d2             	movzwl %dx,%edx
  101111:	01 d2                	add    %edx,%edx
  101113:	01 d0                	add    %edx,%eax
  101115:	8b 55 08             	mov    0x8(%ebp),%edx
  101118:	b2 00                	mov    $0x0,%dl
  10111a:	83 ca 20             	or     $0x20,%edx
  10111d:	66 89 10             	mov    %dx,(%eax)
        }
        break;
  101120:	eb 70                	jmp    101192 <cga_putc+0xe0>
    case '\n':
        crt_pos += CRT_COLS;
  101122:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101129:	83 c0 50             	add    $0x50,%eax
  10112c:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  101132:	0f b7 1d 84 7e 11 00 	movzwl 0x117e84,%ebx
  101139:	0f b7 0d 84 7e 11 00 	movzwl 0x117e84,%ecx
  101140:	0f b7 c1             	movzwl %cx,%eax
  101143:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  101149:	c1 e8 10             	shr    $0x10,%eax
  10114c:	89 c2                	mov    %eax,%edx
  10114e:	66 c1 ea 06          	shr    $0x6,%dx
  101152:	89 d0                	mov    %edx,%eax
  101154:	c1 e0 02             	shl    $0x2,%eax
  101157:	01 d0                	add    %edx,%eax
  101159:	c1 e0 04             	shl    $0x4,%eax
  10115c:	29 c1                	sub    %eax,%ecx
  10115e:	89 ca                	mov    %ecx,%edx
  101160:	89 d8                	mov    %ebx,%eax
  101162:	29 d0                	sub    %edx,%eax
  101164:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
        break;
  10116a:	eb 27                	jmp    101193 <cga_putc+0xe1>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  10116c:	8b 0d 80 7e 11 00    	mov    0x117e80,%ecx
  101172:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101179:	8d 50 01             	lea    0x1(%eax),%edx
  10117c:	66 89 15 84 7e 11 00 	mov    %dx,0x117e84
  101183:	0f b7 c0             	movzwl %ax,%eax
  101186:	01 c0                	add    %eax,%eax
  101188:	01 c8                	add    %ecx,%eax
  10118a:	8b 55 08             	mov    0x8(%ebp),%edx
  10118d:	66 89 10             	mov    %dx,(%eax)
        break;
  101190:	eb 01                	jmp    101193 <cga_putc+0xe1>
    case '\b':
        if (crt_pos > 0) {
            crt_pos --;
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
        }
        break;
  101192:	90                   	nop
        crt_buf[crt_pos ++] = c;     // write the character
        break;
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  101193:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  10119a:	66 3d cf 07          	cmp    $0x7cf,%ax
  10119e:	76 59                	jbe    1011f9 <cga_putc+0x147>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  1011a0:	a1 80 7e 11 00       	mov    0x117e80,%eax
  1011a5:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  1011ab:	a1 80 7e 11 00       	mov    0x117e80,%eax
  1011b0:	83 ec 04             	sub    $0x4,%esp
  1011b3:	68 00 0f 00 00       	push   $0xf00
  1011b8:	52                   	push   %edx
  1011b9:	50                   	push   %eax
  1011ba:	e8 33 41 00 00       	call   1052f2 <memmove>
  1011bf:	83 c4 10             	add    $0x10,%esp
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011c2:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  1011c9:	eb 15                	jmp    1011e0 <cga_putc+0x12e>
            crt_buf[i] = 0x0700 | ' ';
  1011cb:	a1 80 7e 11 00       	mov    0x117e80,%eax
  1011d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1011d3:	01 d2                	add    %edx,%edx
  1011d5:	01 d0                	add    %edx,%eax
  1011d7:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011dc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1011e0:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  1011e7:	7e e2                	jle    1011cb <cga_putc+0x119>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  1011e9:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  1011f0:	83 e8 50             	sub    $0x50,%eax
  1011f3:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  1011f9:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  101200:	0f b7 c0             	movzwl %ax,%eax
  101203:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  101207:	c6 45 e8 0e          	movb   $0xe,-0x18(%ebp)
  10120b:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
  10120f:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101213:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  101214:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  10121b:	66 c1 e8 08          	shr    $0x8,%ax
  10121f:	0f b6 c0             	movzbl %al,%eax
  101222:	0f b7 15 86 7e 11 00 	movzwl 0x117e86,%edx
  101229:	83 c2 01             	add    $0x1,%edx
  10122c:	0f b7 d2             	movzwl %dx,%edx
  10122f:	66 89 55 f0          	mov    %dx,-0x10(%ebp)
  101233:	88 45 e9             	mov    %al,-0x17(%ebp)
  101236:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10123a:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  10123e:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  10123f:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  101246:	0f b7 c0             	movzwl %ax,%eax
  101249:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  10124d:	c6 45 ea 0f          	movb   $0xf,-0x16(%ebp)
  101251:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
  101255:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101259:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  10125a:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101261:	0f b6 c0             	movzbl %al,%eax
  101264:	0f b7 15 86 7e 11 00 	movzwl 0x117e86,%edx
  10126b:	83 c2 01             	add    $0x1,%edx
  10126e:	0f b7 d2             	movzwl %dx,%edx
  101271:	66 89 55 ec          	mov    %dx,-0x14(%ebp)
  101275:	88 45 eb             	mov    %al,-0x15(%ebp)
  101278:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
  10127c:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
  101280:	ee                   	out    %al,(%dx)
}
  101281:	90                   	nop
  101282:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  101285:	c9                   	leave  
  101286:	c3                   	ret    

00101287 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  101287:	55                   	push   %ebp
  101288:	89 e5                	mov    %esp,%ebp
  10128a:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10128d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101294:	eb 09                	jmp    10129f <serial_putc_sub+0x18>
        delay();
  101296:	e8 51 fb ff ff       	call   100dec <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10129b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10129f:	66 c7 45 f8 fd 03    	movw   $0x3fd,-0x8(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1012a5:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
  1012a9:	89 c2                	mov    %eax,%edx
  1012ab:	ec                   	in     (%dx),%al
  1012ac:	88 45 f7             	mov    %al,-0x9(%ebp)
    return data;
  1012af:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  1012b3:	0f b6 c0             	movzbl %al,%eax
  1012b6:	83 e0 20             	and    $0x20,%eax
  1012b9:	85 c0                	test   %eax,%eax
  1012bb:	75 09                	jne    1012c6 <serial_putc_sub+0x3f>
  1012bd:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1012c4:	7e d0                	jle    101296 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  1012c6:	8b 45 08             	mov    0x8(%ebp),%eax
  1012c9:	0f b6 c0             	movzbl %al,%eax
  1012cc:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
  1012d2:	88 45 f6             	mov    %al,-0xa(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1012d5:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
  1012d9:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1012dd:	ee                   	out    %al,(%dx)
}
  1012de:	90                   	nop
  1012df:	c9                   	leave  
  1012e0:	c3                   	ret    

001012e1 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  1012e1:	55                   	push   %ebp
  1012e2:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
  1012e4:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1012e8:	74 0d                	je     1012f7 <serial_putc+0x16>
        serial_putc_sub(c);
  1012ea:	ff 75 08             	pushl  0x8(%ebp)
  1012ed:	e8 95 ff ff ff       	call   101287 <serial_putc_sub>
  1012f2:	83 c4 04             	add    $0x4,%esp
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  1012f5:	eb 1e                	jmp    101315 <serial_putc+0x34>
serial_putc(int c) {
    if (c != '\b') {
        serial_putc_sub(c);
    }
    else {
        serial_putc_sub('\b');
  1012f7:	6a 08                	push   $0x8
  1012f9:	e8 89 ff ff ff       	call   101287 <serial_putc_sub>
  1012fe:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub(' ');
  101301:	6a 20                	push   $0x20
  101303:	e8 7f ff ff ff       	call   101287 <serial_putc_sub>
  101308:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub('\b');
  10130b:	6a 08                	push   $0x8
  10130d:	e8 75 ff ff ff       	call   101287 <serial_putc_sub>
  101312:	83 c4 04             	add    $0x4,%esp
    }
}
  101315:	90                   	nop
  101316:	c9                   	leave  
  101317:	c3                   	ret    

00101318 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  101318:	55                   	push   %ebp
  101319:	89 e5                	mov    %esp,%ebp
  10131b:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  10131e:	eb 33                	jmp    101353 <cons_intr+0x3b>
        if (c != 0) {
  101320:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  101324:	74 2d                	je     101353 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  101326:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  10132b:	8d 50 01             	lea    0x1(%eax),%edx
  10132e:	89 15 a4 80 11 00    	mov    %edx,0x1180a4
  101334:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101337:	88 90 a0 7e 11 00    	mov    %dl,0x117ea0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  10133d:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  101342:	3d 00 02 00 00       	cmp    $0x200,%eax
  101347:	75 0a                	jne    101353 <cons_intr+0x3b>
                cons.wpos = 0;
  101349:	c7 05 a4 80 11 00 00 	movl   $0x0,0x1180a4
  101350:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  101353:	8b 45 08             	mov    0x8(%ebp),%eax
  101356:	ff d0                	call   *%eax
  101358:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10135b:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  10135f:	75 bf                	jne    101320 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  101361:	90                   	nop
  101362:	c9                   	leave  
  101363:	c3                   	ret    

00101364 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  101364:	55                   	push   %ebp
  101365:	89 e5                	mov    %esp,%ebp
  101367:	83 ec 10             	sub    $0x10,%esp
  10136a:	66 c7 45 f8 fd 03    	movw   $0x3fd,-0x8(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101370:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
  101374:	89 c2                	mov    %eax,%edx
  101376:	ec                   	in     (%dx),%al
  101377:	88 45 f7             	mov    %al,-0x9(%ebp)
    return data;
  10137a:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  10137e:	0f b6 c0             	movzbl %al,%eax
  101381:	83 e0 01             	and    $0x1,%eax
  101384:	85 c0                	test   %eax,%eax
  101386:	75 07                	jne    10138f <serial_proc_data+0x2b>
        return -1;
  101388:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10138d:	eb 2a                	jmp    1013b9 <serial_proc_data+0x55>
  10138f:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101395:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101399:	89 c2                	mov    %eax,%edx
  10139b:	ec                   	in     (%dx),%al
  10139c:	88 45 f6             	mov    %al,-0xa(%ebp)
    return data;
  10139f:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  1013a3:	0f b6 c0             	movzbl %al,%eax
  1013a6:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  1013a9:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  1013ad:	75 07                	jne    1013b6 <serial_proc_data+0x52>
        c = '\b';
  1013af:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  1013b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1013b9:	c9                   	leave  
  1013ba:	c3                   	ret    

001013bb <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  1013bb:	55                   	push   %ebp
  1013bc:	89 e5                	mov    %esp,%ebp
  1013be:	83 ec 08             	sub    $0x8,%esp
    if (serial_exists) {
  1013c1:	a1 88 7e 11 00       	mov    0x117e88,%eax
  1013c6:	85 c0                	test   %eax,%eax
  1013c8:	74 10                	je     1013da <serial_intr+0x1f>
        cons_intr(serial_proc_data);
  1013ca:	83 ec 0c             	sub    $0xc,%esp
  1013cd:	68 64 13 10 00       	push   $0x101364
  1013d2:	e8 41 ff ff ff       	call   101318 <cons_intr>
  1013d7:	83 c4 10             	add    $0x10,%esp
    }
}
  1013da:	90                   	nop
  1013db:	c9                   	leave  
  1013dc:	c3                   	ret    

001013dd <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  1013dd:	55                   	push   %ebp
  1013de:	89 e5                	mov    %esp,%ebp
  1013e0:	83 ec 18             	sub    $0x18,%esp
  1013e3:	66 c7 45 ec 64 00    	movw   $0x64,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013e9:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1013ed:	89 c2                	mov    %eax,%edx
  1013ef:	ec                   	in     (%dx),%al
  1013f0:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  1013f3:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  1013f7:	0f b6 c0             	movzbl %al,%eax
  1013fa:	83 e0 01             	and    $0x1,%eax
  1013fd:	85 c0                	test   %eax,%eax
  1013ff:	75 0a                	jne    10140b <kbd_proc_data+0x2e>
        return -1;
  101401:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101406:	e9 5d 01 00 00       	jmp    101568 <kbd_proc_data+0x18b>
  10140b:	66 c7 45 f0 60 00    	movw   $0x60,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101411:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  101415:	89 c2                	mov    %eax,%edx
  101417:	ec                   	in     (%dx),%al
  101418:	88 45 ea             	mov    %al,-0x16(%ebp)
    return data;
  10141b:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
    }

    data = inb(KBDATAP);
  10141f:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  101422:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  101426:	75 17                	jne    10143f <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  101428:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  10142d:	83 c8 40             	or     $0x40,%eax
  101430:	a3 a8 80 11 00       	mov    %eax,0x1180a8
        return 0;
  101435:	b8 00 00 00 00       	mov    $0x0,%eax
  10143a:	e9 29 01 00 00       	jmp    101568 <kbd_proc_data+0x18b>
    } else if (data & 0x80) {
  10143f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101443:	84 c0                	test   %al,%al
  101445:	79 47                	jns    10148e <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101447:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  10144c:	83 e0 40             	and    $0x40,%eax
  10144f:	85 c0                	test   %eax,%eax
  101451:	75 09                	jne    10145c <kbd_proc_data+0x7f>
  101453:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101457:	83 e0 7f             	and    $0x7f,%eax
  10145a:	eb 04                	jmp    101460 <kbd_proc_data+0x83>
  10145c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101460:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  101463:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101467:	0f b6 80 60 70 11 00 	movzbl 0x117060(%eax),%eax
  10146e:	83 c8 40             	or     $0x40,%eax
  101471:	0f b6 c0             	movzbl %al,%eax
  101474:	f7 d0                	not    %eax
  101476:	89 c2                	mov    %eax,%edx
  101478:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  10147d:	21 d0                	and    %edx,%eax
  10147f:	a3 a8 80 11 00       	mov    %eax,0x1180a8
        return 0;
  101484:	b8 00 00 00 00       	mov    $0x0,%eax
  101489:	e9 da 00 00 00       	jmp    101568 <kbd_proc_data+0x18b>
    } else if (shift & E0ESC) {
  10148e:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101493:	83 e0 40             	and    $0x40,%eax
  101496:	85 c0                	test   %eax,%eax
  101498:	74 11                	je     1014ab <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  10149a:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  10149e:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014a3:	83 e0 bf             	and    $0xffffffbf,%eax
  1014a6:	a3 a8 80 11 00       	mov    %eax,0x1180a8
    }

    shift |= shiftcode[data];
  1014ab:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014af:	0f b6 80 60 70 11 00 	movzbl 0x117060(%eax),%eax
  1014b6:	0f b6 d0             	movzbl %al,%edx
  1014b9:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014be:	09 d0                	or     %edx,%eax
  1014c0:	a3 a8 80 11 00       	mov    %eax,0x1180a8
    shift ^= togglecode[data];
  1014c5:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014c9:	0f b6 80 60 71 11 00 	movzbl 0x117160(%eax),%eax
  1014d0:	0f b6 d0             	movzbl %al,%edx
  1014d3:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014d8:	31 d0                	xor    %edx,%eax
  1014da:	a3 a8 80 11 00       	mov    %eax,0x1180a8

    c = charcode[shift & (CTL | SHIFT)][data];
  1014df:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014e4:	83 e0 03             	and    $0x3,%eax
  1014e7:	8b 14 85 60 75 11 00 	mov    0x117560(,%eax,4),%edx
  1014ee:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014f2:	01 d0                	add    %edx,%eax
  1014f4:	0f b6 00             	movzbl (%eax),%eax
  1014f7:	0f b6 c0             	movzbl %al,%eax
  1014fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  1014fd:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101502:	83 e0 08             	and    $0x8,%eax
  101505:	85 c0                	test   %eax,%eax
  101507:	74 22                	je     10152b <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  101509:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  10150d:	7e 0c                	jle    10151b <kbd_proc_data+0x13e>
  10150f:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  101513:	7f 06                	jg     10151b <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  101515:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  101519:	eb 10                	jmp    10152b <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  10151b:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  10151f:	7e 0a                	jle    10152b <kbd_proc_data+0x14e>
  101521:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  101525:	7f 04                	jg     10152b <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  101527:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  10152b:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101530:	f7 d0                	not    %eax
  101532:	83 e0 06             	and    $0x6,%eax
  101535:	85 c0                	test   %eax,%eax
  101537:	75 2c                	jne    101565 <kbd_proc_data+0x188>
  101539:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  101540:	75 23                	jne    101565 <kbd_proc_data+0x188>
        cprintf("Rebooting!\n");
  101542:	83 ec 0c             	sub    $0xc,%esp
  101545:	68 81 5d 10 00       	push   $0x105d81
  10154a:	e8 18 ed ff ff       	call   100267 <cprintf>
  10154f:	83 c4 10             	add    $0x10,%esp
  101552:	66 c7 45 ee 92 00    	movw   $0x92,-0x12(%ebp)
  101558:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10155c:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101560:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101564:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  101565:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101568:	c9                   	leave  
  101569:	c3                   	ret    

0010156a <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  10156a:	55                   	push   %ebp
  10156b:	89 e5                	mov    %esp,%ebp
  10156d:	83 ec 08             	sub    $0x8,%esp
    cons_intr(kbd_proc_data);
  101570:	83 ec 0c             	sub    $0xc,%esp
  101573:	68 dd 13 10 00       	push   $0x1013dd
  101578:	e8 9b fd ff ff       	call   101318 <cons_intr>
  10157d:	83 c4 10             	add    $0x10,%esp
}
  101580:	90                   	nop
  101581:	c9                   	leave  
  101582:	c3                   	ret    

00101583 <kbd_init>:

static void
kbd_init(void) {
  101583:	55                   	push   %ebp
  101584:	89 e5                	mov    %esp,%ebp
  101586:	83 ec 08             	sub    $0x8,%esp
    // drain the kbd buffer
    kbd_intr();
  101589:	e8 dc ff ff ff       	call   10156a <kbd_intr>
    pic_enable(IRQ_KBD);
  10158e:	83 ec 0c             	sub    $0xc,%esp
  101591:	6a 01                	push   $0x1
  101593:	e8 4b 01 00 00       	call   1016e3 <pic_enable>
  101598:	83 c4 10             	add    $0x10,%esp
}
  10159b:	90                   	nop
  10159c:	c9                   	leave  
  10159d:	c3                   	ret    

0010159e <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  10159e:	55                   	push   %ebp
  10159f:	89 e5                	mov    %esp,%ebp
  1015a1:	83 ec 08             	sub    $0x8,%esp
    cga_init();
  1015a4:	e8 8c f8 ff ff       	call   100e35 <cga_init>
    serial_init();
  1015a9:	e8 6e f9 ff ff       	call   100f1c <serial_init>
    kbd_init();
  1015ae:	e8 d0 ff ff ff       	call   101583 <kbd_init>
    if (!serial_exists) {
  1015b3:	a1 88 7e 11 00       	mov    0x117e88,%eax
  1015b8:	85 c0                	test   %eax,%eax
  1015ba:	75 10                	jne    1015cc <cons_init+0x2e>
        cprintf("serial port does not exist!!\n");
  1015bc:	83 ec 0c             	sub    $0xc,%esp
  1015bf:	68 8d 5d 10 00       	push   $0x105d8d
  1015c4:	e8 9e ec ff ff       	call   100267 <cprintf>
  1015c9:	83 c4 10             	add    $0x10,%esp
    }
}
  1015cc:	90                   	nop
  1015cd:	c9                   	leave  
  1015ce:	c3                   	ret    

001015cf <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  1015cf:	55                   	push   %ebp
  1015d0:	89 e5                	mov    %esp,%ebp
  1015d2:	83 ec 18             	sub    $0x18,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  1015d5:	e8 d4 f7 ff ff       	call   100dae <__intr_save>
  1015da:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
  1015dd:	83 ec 0c             	sub    $0xc,%esp
  1015e0:	ff 75 08             	pushl  0x8(%ebp)
  1015e3:	e8 93 fa ff ff       	call   10107b <lpt_putc>
  1015e8:	83 c4 10             	add    $0x10,%esp
        cga_putc(c);
  1015eb:	83 ec 0c             	sub    $0xc,%esp
  1015ee:	ff 75 08             	pushl  0x8(%ebp)
  1015f1:	e8 bc fa ff ff       	call   1010b2 <cga_putc>
  1015f6:	83 c4 10             	add    $0x10,%esp
        serial_putc(c);
  1015f9:	83 ec 0c             	sub    $0xc,%esp
  1015fc:	ff 75 08             	pushl  0x8(%ebp)
  1015ff:	e8 dd fc ff ff       	call   1012e1 <serial_putc>
  101604:	83 c4 10             	add    $0x10,%esp
    }
    local_intr_restore(intr_flag);
  101607:	83 ec 0c             	sub    $0xc,%esp
  10160a:	ff 75 f4             	pushl  -0xc(%ebp)
  10160d:	e8 c6 f7 ff ff       	call   100dd8 <__intr_restore>
  101612:	83 c4 10             	add    $0x10,%esp
}
  101615:	90                   	nop
  101616:	c9                   	leave  
  101617:	c3                   	ret    

00101618 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  101618:	55                   	push   %ebp
  101619:	89 e5                	mov    %esp,%ebp
  10161b:	83 ec 18             	sub    $0x18,%esp
    int c = 0;
  10161e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  101625:	e8 84 f7 ff ff       	call   100dae <__intr_save>
  10162a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
  10162d:	e8 89 fd ff ff       	call   1013bb <serial_intr>
        kbd_intr();
  101632:	e8 33 ff ff ff       	call   10156a <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
  101637:	8b 15 a0 80 11 00    	mov    0x1180a0,%edx
  10163d:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  101642:	39 c2                	cmp    %eax,%edx
  101644:	74 31                	je     101677 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
  101646:	a1 a0 80 11 00       	mov    0x1180a0,%eax
  10164b:	8d 50 01             	lea    0x1(%eax),%edx
  10164e:	89 15 a0 80 11 00    	mov    %edx,0x1180a0
  101654:	0f b6 80 a0 7e 11 00 	movzbl 0x117ea0(%eax),%eax
  10165b:	0f b6 c0             	movzbl %al,%eax
  10165e:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
  101661:	a1 a0 80 11 00       	mov    0x1180a0,%eax
  101666:	3d 00 02 00 00       	cmp    $0x200,%eax
  10166b:	75 0a                	jne    101677 <cons_getc+0x5f>
                cons.rpos = 0;
  10166d:	c7 05 a0 80 11 00 00 	movl   $0x0,0x1180a0
  101674:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
  101677:	83 ec 0c             	sub    $0xc,%esp
  10167a:	ff 75 f0             	pushl  -0x10(%ebp)
  10167d:	e8 56 f7 ff ff       	call   100dd8 <__intr_restore>
  101682:	83 c4 10             	add    $0x10,%esp
    return c;
  101685:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101688:	c9                   	leave  
  101689:	c3                   	ret    

0010168a <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  10168a:	55                   	push   %ebp
  10168b:	89 e5                	mov    %esp,%ebp
  10168d:	83 ec 14             	sub    $0x14,%esp
  101690:	8b 45 08             	mov    0x8(%ebp),%eax
  101693:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  101697:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10169b:	66 a3 70 75 11 00    	mov    %ax,0x117570
    if (did_init) {
  1016a1:	a1 ac 80 11 00       	mov    0x1180ac,%eax
  1016a6:	85 c0                	test   %eax,%eax
  1016a8:	74 36                	je     1016e0 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  1016aa:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016ae:	0f b6 c0             	movzbl %al,%eax
  1016b1:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1016b7:	88 45 fa             	mov    %al,-0x6(%ebp)
  1016ba:	0f b6 45 fa          	movzbl -0x6(%ebp),%eax
  1016be:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016c2:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  1016c3:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016c7:	66 c1 e8 08          	shr    $0x8,%ax
  1016cb:	0f b6 c0             	movzbl %al,%eax
  1016ce:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
  1016d4:	88 45 fb             	mov    %al,-0x5(%ebp)
  1016d7:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
  1016db:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
  1016df:	ee                   	out    %al,(%dx)
    }
}
  1016e0:	90                   	nop
  1016e1:	c9                   	leave  
  1016e2:	c3                   	ret    

001016e3 <pic_enable>:

void
pic_enable(unsigned int irq) {
  1016e3:	55                   	push   %ebp
  1016e4:	89 e5                	mov    %esp,%ebp
    pic_setmask(irq_mask & ~(1 << irq));
  1016e6:	8b 45 08             	mov    0x8(%ebp),%eax
  1016e9:	ba 01 00 00 00       	mov    $0x1,%edx
  1016ee:	89 c1                	mov    %eax,%ecx
  1016f0:	d3 e2                	shl    %cl,%edx
  1016f2:	89 d0                	mov    %edx,%eax
  1016f4:	f7 d0                	not    %eax
  1016f6:	89 c2                	mov    %eax,%edx
  1016f8:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  1016ff:	21 d0                	and    %edx,%eax
  101701:	0f b7 c0             	movzwl %ax,%eax
  101704:	50                   	push   %eax
  101705:	e8 80 ff ff ff       	call   10168a <pic_setmask>
  10170a:	83 c4 04             	add    $0x4,%esp
}
  10170d:	90                   	nop
  10170e:	c9                   	leave  
  10170f:	c3                   	ret    

00101710 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  101710:	55                   	push   %ebp
  101711:	89 e5                	mov    %esp,%ebp
  101713:	83 ec 30             	sub    $0x30,%esp
    did_init = 1;
  101716:	c7 05 ac 80 11 00 01 	movl   $0x1,0x1180ac
  10171d:	00 00 00 
  101720:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  101726:	c6 45 d6 ff          	movb   $0xff,-0x2a(%ebp)
  10172a:	0f b6 45 d6          	movzbl -0x2a(%ebp),%eax
  10172e:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101732:	ee                   	out    %al,(%dx)
  101733:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
  101739:	c6 45 d7 ff          	movb   $0xff,-0x29(%ebp)
  10173d:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
  101741:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
  101745:	ee                   	out    %al,(%dx)
  101746:	66 c7 45 fa 20 00    	movw   $0x20,-0x6(%ebp)
  10174c:	c6 45 d8 11          	movb   $0x11,-0x28(%ebp)
  101750:	0f b6 45 d8          	movzbl -0x28(%ebp),%eax
  101754:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101758:	ee                   	out    %al,(%dx)
  101759:	66 c7 45 f8 21 00    	movw   $0x21,-0x8(%ebp)
  10175f:	c6 45 d9 20          	movb   $0x20,-0x27(%ebp)
  101763:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101767:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  10176b:	ee                   	out    %al,(%dx)
  10176c:	66 c7 45 f6 21 00    	movw   $0x21,-0xa(%ebp)
  101772:	c6 45 da 04          	movb   $0x4,-0x26(%ebp)
  101776:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
  10177a:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10177e:	ee                   	out    %al,(%dx)
  10177f:	66 c7 45 f4 21 00    	movw   $0x21,-0xc(%ebp)
  101785:	c6 45 db 03          	movb   $0x3,-0x25(%ebp)
  101789:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
  10178d:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
  101791:	ee                   	out    %al,(%dx)
  101792:	66 c7 45 f2 a0 00    	movw   $0xa0,-0xe(%ebp)
  101798:	c6 45 dc 11          	movb   $0x11,-0x24(%ebp)
  10179c:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
  1017a0:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1017a4:	ee                   	out    %al,(%dx)
  1017a5:	66 c7 45 f0 a1 00    	movw   $0xa1,-0x10(%ebp)
  1017ab:	c6 45 dd 28          	movb   $0x28,-0x23(%ebp)
  1017af:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  1017b3:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  1017b7:	ee                   	out    %al,(%dx)
  1017b8:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  1017be:	c6 45 de 02          	movb   $0x2,-0x22(%ebp)
  1017c2:	0f b6 45 de          	movzbl -0x22(%ebp),%eax
  1017c6:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1017ca:	ee                   	out    %al,(%dx)
  1017cb:	66 c7 45 ec a1 00    	movw   $0xa1,-0x14(%ebp)
  1017d1:	c6 45 df 03          	movb   $0x3,-0x21(%ebp)
  1017d5:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
  1017d9:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
  1017dd:	ee                   	out    %al,(%dx)
  1017de:	66 c7 45 ea 20 00    	movw   $0x20,-0x16(%ebp)
  1017e4:	c6 45 e0 68          	movb   $0x68,-0x20(%ebp)
  1017e8:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
  1017ec:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1017f0:	ee                   	out    %al,(%dx)
  1017f1:	66 c7 45 e8 20 00    	movw   $0x20,-0x18(%ebp)
  1017f7:	c6 45 e1 0a          	movb   $0xa,-0x1f(%ebp)
  1017fb:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  1017ff:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  101803:	ee                   	out    %al,(%dx)
  101804:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  10180a:	c6 45 e2 68          	movb   $0x68,-0x1e(%ebp)
  10180e:	0f b6 45 e2          	movzbl -0x1e(%ebp),%eax
  101812:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101816:	ee                   	out    %al,(%dx)
  101817:	66 c7 45 e4 a0 00    	movw   $0xa0,-0x1c(%ebp)
  10181d:	c6 45 e3 0a          	movb   $0xa,-0x1d(%ebp)
  101821:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
  101825:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
  101829:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  10182a:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  101831:	66 83 f8 ff          	cmp    $0xffff,%ax
  101835:	74 13                	je     10184a <pic_init+0x13a>
        pic_setmask(irq_mask);
  101837:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  10183e:	0f b7 c0             	movzwl %ax,%eax
  101841:	50                   	push   %eax
  101842:	e8 43 fe ff ff       	call   10168a <pic_setmask>
  101847:	83 c4 04             	add    $0x4,%esp
    }
}
  10184a:	90                   	nop
  10184b:	c9                   	leave  
  10184c:	c3                   	ret    

0010184d <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  10184d:	55                   	push   %ebp
  10184e:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
  101850:	fb                   	sti    
    sti();
}
  101851:	90                   	nop
  101852:	5d                   	pop    %ebp
  101853:	c3                   	ret    

00101854 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  101854:	55                   	push   %ebp
  101855:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
  101857:	fa                   	cli    
    cli();
}
  101858:	90                   	nop
  101859:	5d                   	pop    %ebp
  10185a:	c3                   	ret    

0010185b <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  10185b:	55                   	push   %ebp
  10185c:	89 e5                	mov    %esp,%ebp
  10185e:	83 ec 08             	sub    $0x8,%esp
    cprintf("%d ticks\n",TICK_NUM);
  101861:	83 ec 08             	sub    $0x8,%esp
  101864:	6a 64                	push   $0x64
  101866:	68 c0 5d 10 00       	push   $0x105dc0
  10186b:	e8 f7 e9 ff ff       	call   100267 <cprintf>
  101870:	83 c4 10             	add    $0x10,%esp
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  101873:	90                   	nop
  101874:	c9                   	leave  
  101875:	c3                   	ret    

00101876 <idt_init>:
    */    
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  101876:	55                   	push   %ebp
  101877:	89 e5                	mov    %esp,%ebp
  101879:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
        extern uintptr_t __vectors[];
        int i;
        for(i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++){
  10187c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101883:	e9 c3 00 00 00       	jmp    10194b <idt_init+0xd5>
                SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  101888:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10188b:	8b 04 85 00 76 11 00 	mov    0x117600(,%eax,4),%eax
  101892:	89 c2                	mov    %eax,%edx
  101894:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101897:	66 89 14 c5 c0 80 11 	mov    %dx,0x1180c0(,%eax,8)
  10189e:	00 
  10189f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018a2:	66 c7 04 c5 c2 80 11 	movw   $0x8,0x1180c2(,%eax,8)
  1018a9:	00 08 00 
  1018ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018af:	0f b6 14 c5 c4 80 11 	movzbl 0x1180c4(,%eax,8),%edx
  1018b6:	00 
  1018b7:	83 e2 e0             	and    $0xffffffe0,%edx
  1018ba:	88 14 c5 c4 80 11 00 	mov    %dl,0x1180c4(,%eax,8)
  1018c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018c4:	0f b6 14 c5 c4 80 11 	movzbl 0x1180c4(,%eax,8),%edx
  1018cb:	00 
  1018cc:	83 e2 1f             	and    $0x1f,%edx
  1018cf:	88 14 c5 c4 80 11 00 	mov    %dl,0x1180c4(,%eax,8)
  1018d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018d9:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  1018e0:	00 
  1018e1:	83 e2 f0             	and    $0xfffffff0,%edx
  1018e4:	83 ca 0e             	or     $0xe,%edx
  1018e7:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  1018ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018f1:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  1018f8:	00 
  1018f9:	83 e2 ef             	and    $0xffffffef,%edx
  1018fc:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101903:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101906:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  10190d:	00 
  10190e:	83 e2 9f             	and    $0xffffff9f,%edx
  101911:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101918:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10191b:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  101922:	00 
  101923:	83 ca 80             	or     $0xffffff80,%edx
  101926:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  10192d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101930:	8b 04 85 00 76 11 00 	mov    0x117600(,%eax,4),%eax
  101937:	c1 e8 10             	shr    $0x10,%eax
  10193a:	89 c2                	mov    %eax,%edx
  10193c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10193f:	66 89 14 c5 c6 80 11 	mov    %dx,0x1180c6(,%eax,8)
  101946:	00 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
        extern uintptr_t __vectors[];
        int i;
        for(i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++){
  101947:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10194b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10194e:	3d ff 00 00 00       	cmp    $0xff,%eax
  101953:	0f 86 2f ff ff ff    	jbe    101888 <idt_init+0x12>
                SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
        }
        SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
  101959:	a1 e4 77 11 00       	mov    0x1177e4,%eax
  10195e:	66 a3 88 84 11 00    	mov    %ax,0x118488
  101964:	66 c7 05 8a 84 11 00 	movw   $0x8,0x11848a
  10196b:	08 00 
  10196d:	0f b6 05 8c 84 11 00 	movzbl 0x11848c,%eax
  101974:	83 e0 e0             	and    $0xffffffe0,%eax
  101977:	a2 8c 84 11 00       	mov    %al,0x11848c
  10197c:	0f b6 05 8c 84 11 00 	movzbl 0x11848c,%eax
  101983:	83 e0 1f             	and    $0x1f,%eax
  101986:	a2 8c 84 11 00       	mov    %al,0x11848c
  10198b:	0f b6 05 8d 84 11 00 	movzbl 0x11848d,%eax
  101992:	83 e0 f0             	and    $0xfffffff0,%eax
  101995:	83 c8 0e             	or     $0xe,%eax
  101998:	a2 8d 84 11 00       	mov    %al,0x11848d
  10199d:	0f b6 05 8d 84 11 00 	movzbl 0x11848d,%eax
  1019a4:	83 e0 ef             	and    $0xffffffef,%eax
  1019a7:	a2 8d 84 11 00       	mov    %al,0x11848d
  1019ac:	0f b6 05 8d 84 11 00 	movzbl 0x11848d,%eax
  1019b3:	83 c8 60             	or     $0x60,%eax
  1019b6:	a2 8d 84 11 00       	mov    %al,0x11848d
  1019bb:	0f b6 05 8d 84 11 00 	movzbl 0x11848d,%eax
  1019c2:	83 c8 80             	or     $0xffffff80,%eax
  1019c5:	a2 8d 84 11 00       	mov    %al,0x11848d
  1019ca:	a1 e4 77 11 00       	mov    0x1177e4,%eax
  1019cf:	c1 e8 10             	shr    $0x10,%eax
  1019d2:	66 a3 8e 84 11 00    	mov    %ax,0x11848e
  1019d8:	c7 45 f8 80 75 11 00 	movl   $0x117580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
  1019df:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1019e2:	0f 01 18             	lidtl  (%eax)

        //load the IDT，和lgdt相似？
        lidt(&idt_pd);
}
  1019e5:	90                   	nop
  1019e6:	c9                   	leave  
  1019e7:	c3                   	ret    

001019e8 <trapname>:

static const char *
trapname(int trapno) {
  1019e8:	55                   	push   %ebp
  1019e9:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  1019eb:	8b 45 08             	mov    0x8(%ebp),%eax
  1019ee:	83 f8 13             	cmp    $0x13,%eax
  1019f1:	77 0c                	ja     1019ff <trapname+0x17>
        return excnames[trapno];
  1019f3:	8b 45 08             	mov    0x8(%ebp),%eax
  1019f6:	8b 04 85 20 61 10 00 	mov    0x106120(,%eax,4),%eax
  1019fd:	eb 18                	jmp    101a17 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  1019ff:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101a03:	7e 0d                	jle    101a12 <trapname+0x2a>
  101a05:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101a09:	7f 07                	jg     101a12 <trapname+0x2a>
        return "Hardware Interrupt";
  101a0b:	b8 ca 5d 10 00       	mov    $0x105dca,%eax
  101a10:	eb 05                	jmp    101a17 <trapname+0x2f>
    }
    return "(unknown trap)";
  101a12:	b8 dd 5d 10 00       	mov    $0x105ddd,%eax
}
  101a17:	5d                   	pop    %ebp
  101a18:	c3                   	ret    

00101a19 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101a19:	55                   	push   %ebp
  101a1a:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  101a1f:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101a23:	66 83 f8 08          	cmp    $0x8,%ax
  101a27:	0f 94 c0             	sete   %al
  101a2a:	0f b6 c0             	movzbl %al,%eax
}
  101a2d:	5d                   	pop    %ebp
  101a2e:	c3                   	ret    

00101a2f <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101a2f:	55                   	push   %ebp
  101a30:	89 e5                	mov    %esp,%ebp
  101a32:	83 ec 18             	sub    $0x18,%esp
    cprintf("trapframe at %p\n", tf);
  101a35:	83 ec 08             	sub    $0x8,%esp
  101a38:	ff 75 08             	pushl  0x8(%ebp)
  101a3b:	68 1e 5e 10 00       	push   $0x105e1e
  101a40:	e8 22 e8 ff ff       	call   100267 <cprintf>
  101a45:	83 c4 10             	add    $0x10,%esp
    print_regs(&tf->tf_regs);
  101a48:	8b 45 08             	mov    0x8(%ebp),%eax
  101a4b:	83 ec 0c             	sub    $0xc,%esp
  101a4e:	50                   	push   %eax
  101a4f:	e8 b8 01 00 00       	call   101c0c <print_regs>
  101a54:	83 c4 10             	add    $0x10,%esp
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101a57:	8b 45 08             	mov    0x8(%ebp),%eax
  101a5a:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101a5e:	0f b7 c0             	movzwl %ax,%eax
  101a61:	83 ec 08             	sub    $0x8,%esp
  101a64:	50                   	push   %eax
  101a65:	68 2f 5e 10 00       	push   $0x105e2f
  101a6a:	e8 f8 e7 ff ff       	call   100267 <cprintf>
  101a6f:	83 c4 10             	add    $0x10,%esp
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101a72:	8b 45 08             	mov    0x8(%ebp),%eax
  101a75:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101a79:	0f b7 c0             	movzwl %ax,%eax
  101a7c:	83 ec 08             	sub    $0x8,%esp
  101a7f:	50                   	push   %eax
  101a80:	68 42 5e 10 00       	push   $0x105e42
  101a85:	e8 dd e7 ff ff       	call   100267 <cprintf>
  101a8a:	83 c4 10             	add    $0x10,%esp
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  101a90:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101a94:	0f b7 c0             	movzwl %ax,%eax
  101a97:	83 ec 08             	sub    $0x8,%esp
  101a9a:	50                   	push   %eax
  101a9b:	68 55 5e 10 00       	push   $0x105e55
  101aa0:	e8 c2 e7 ff ff       	call   100267 <cprintf>
  101aa5:	83 c4 10             	add    $0x10,%esp
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  101aab:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101aaf:	0f b7 c0             	movzwl %ax,%eax
  101ab2:	83 ec 08             	sub    $0x8,%esp
  101ab5:	50                   	push   %eax
  101ab6:	68 68 5e 10 00       	push   $0x105e68
  101abb:	e8 a7 e7 ff ff       	call   100267 <cprintf>
  101ac0:	83 c4 10             	add    $0x10,%esp
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  101ac6:	8b 40 30             	mov    0x30(%eax),%eax
  101ac9:	83 ec 0c             	sub    $0xc,%esp
  101acc:	50                   	push   %eax
  101acd:	e8 16 ff ff ff       	call   1019e8 <trapname>
  101ad2:	83 c4 10             	add    $0x10,%esp
  101ad5:	89 c2                	mov    %eax,%edx
  101ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  101ada:	8b 40 30             	mov    0x30(%eax),%eax
  101add:	83 ec 04             	sub    $0x4,%esp
  101ae0:	52                   	push   %edx
  101ae1:	50                   	push   %eax
  101ae2:	68 7b 5e 10 00       	push   $0x105e7b
  101ae7:	e8 7b e7 ff ff       	call   100267 <cprintf>
  101aec:	83 c4 10             	add    $0x10,%esp
    cprintf("  err  0x%08x\n", tf->tf_err);
  101aef:	8b 45 08             	mov    0x8(%ebp),%eax
  101af2:	8b 40 34             	mov    0x34(%eax),%eax
  101af5:	83 ec 08             	sub    $0x8,%esp
  101af8:	50                   	push   %eax
  101af9:	68 8d 5e 10 00       	push   $0x105e8d
  101afe:	e8 64 e7 ff ff       	call   100267 <cprintf>
  101b03:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101b06:	8b 45 08             	mov    0x8(%ebp),%eax
  101b09:	8b 40 38             	mov    0x38(%eax),%eax
  101b0c:	83 ec 08             	sub    $0x8,%esp
  101b0f:	50                   	push   %eax
  101b10:	68 9c 5e 10 00       	push   $0x105e9c
  101b15:	e8 4d e7 ff ff       	call   100267 <cprintf>
  101b1a:	83 c4 10             	add    $0x10,%esp
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  101b20:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b24:	0f b7 c0             	movzwl %ax,%eax
  101b27:	83 ec 08             	sub    $0x8,%esp
  101b2a:	50                   	push   %eax
  101b2b:	68 ab 5e 10 00       	push   $0x105eab
  101b30:	e8 32 e7 ff ff       	call   100267 <cprintf>
  101b35:	83 c4 10             	add    $0x10,%esp
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101b38:	8b 45 08             	mov    0x8(%ebp),%eax
  101b3b:	8b 40 40             	mov    0x40(%eax),%eax
  101b3e:	83 ec 08             	sub    $0x8,%esp
  101b41:	50                   	push   %eax
  101b42:	68 be 5e 10 00       	push   $0x105ebe
  101b47:	e8 1b e7 ff ff       	call   100267 <cprintf>
  101b4c:	83 c4 10             	add    $0x10,%esp

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b4f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101b56:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101b5d:	eb 3f                	jmp    101b9e <print_trapframe+0x16f>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  101b62:	8b 50 40             	mov    0x40(%eax),%edx
  101b65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101b68:	21 d0                	and    %edx,%eax
  101b6a:	85 c0                	test   %eax,%eax
  101b6c:	74 29                	je     101b97 <print_trapframe+0x168>
  101b6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b71:	8b 04 85 a0 75 11 00 	mov    0x1175a0(,%eax,4),%eax
  101b78:	85 c0                	test   %eax,%eax
  101b7a:	74 1b                	je     101b97 <print_trapframe+0x168>
            cprintf("%s,", IA32flags[i]);
  101b7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b7f:	8b 04 85 a0 75 11 00 	mov    0x1175a0(,%eax,4),%eax
  101b86:	83 ec 08             	sub    $0x8,%esp
  101b89:	50                   	push   %eax
  101b8a:	68 cd 5e 10 00       	push   $0x105ecd
  101b8f:	e8 d3 e6 ff ff       	call   100267 <cprintf>
  101b94:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b97:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101b9b:	d1 65 f0             	shll   -0x10(%ebp)
  101b9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101ba1:	83 f8 17             	cmp    $0x17,%eax
  101ba4:	76 b9                	jbe    101b5f <print_trapframe+0x130>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101ba6:	8b 45 08             	mov    0x8(%ebp),%eax
  101ba9:	8b 40 40             	mov    0x40(%eax),%eax
  101bac:	25 00 30 00 00       	and    $0x3000,%eax
  101bb1:	c1 e8 0c             	shr    $0xc,%eax
  101bb4:	83 ec 08             	sub    $0x8,%esp
  101bb7:	50                   	push   %eax
  101bb8:	68 d1 5e 10 00       	push   $0x105ed1
  101bbd:	e8 a5 e6 ff ff       	call   100267 <cprintf>
  101bc2:	83 c4 10             	add    $0x10,%esp

    if (!trap_in_kernel(tf)) {
  101bc5:	83 ec 0c             	sub    $0xc,%esp
  101bc8:	ff 75 08             	pushl  0x8(%ebp)
  101bcb:	e8 49 fe ff ff       	call   101a19 <trap_in_kernel>
  101bd0:	83 c4 10             	add    $0x10,%esp
  101bd3:	85 c0                	test   %eax,%eax
  101bd5:	75 32                	jne    101c09 <print_trapframe+0x1da>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101bd7:	8b 45 08             	mov    0x8(%ebp),%eax
  101bda:	8b 40 44             	mov    0x44(%eax),%eax
  101bdd:	83 ec 08             	sub    $0x8,%esp
  101be0:	50                   	push   %eax
  101be1:	68 da 5e 10 00       	push   $0x105eda
  101be6:	e8 7c e6 ff ff       	call   100267 <cprintf>
  101beb:	83 c4 10             	add    $0x10,%esp
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101bee:	8b 45 08             	mov    0x8(%ebp),%eax
  101bf1:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101bf5:	0f b7 c0             	movzwl %ax,%eax
  101bf8:	83 ec 08             	sub    $0x8,%esp
  101bfb:	50                   	push   %eax
  101bfc:	68 e9 5e 10 00       	push   $0x105ee9
  101c01:	e8 61 e6 ff ff       	call   100267 <cprintf>
  101c06:	83 c4 10             	add    $0x10,%esp
    }
}
  101c09:	90                   	nop
  101c0a:	c9                   	leave  
  101c0b:	c3                   	ret    

00101c0c <print_regs>:

void
print_regs(struct pushregs *regs) {
  101c0c:	55                   	push   %ebp
  101c0d:	89 e5                	mov    %esp,%ebp
  101c0f:	83 ec 08             	sub    $0x8,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101c12:	8b 45 08             	mov    0x8(%ebp),%eax
  101c15:	8b 00                	mov    (%eax),%eax
  101c17:	83 ec 08             	sub    $0x8,%esp
  101c1a:	50                   	push   %eax
  101c1b:	68 fc 5e 10 00       	push   $0x105efc
  101c20:	e8 42 e6 ff ff       	call   100267 <cprintf>
  101c25:	83 c4 10             	add    $0x10,%esp
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101c28:	8b 45 08             	mov    0x8(%ebp),%eax
  101c2b:	8b 40 04             	mov    0x4(%eax),%eax
  101c2e:	83 ec 08             	sub    $0x8,%esp
  101c31:	50                   	push   %eax
  101c32:	68 0b 5f 10 00       	push   $0x105f0b
  101c37:	e8 2b e6 ff ff       	call   100267 <cprintf>
  101c3c:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  101c42:	8b 40 08             	mov    0x8(%eax),%eax
  101c45:	83 ec 08             	sub    $0x8,%esp
  101c48:	50                   	push   %eax
  101c49:	68 1a 5f 10 00       	push   $0x105f1a
  101c4e:	e8 14 e6 ff ff       	call   100267 <cprintf>
  101c53:	83 c4 10             	add    $0x10,%esp
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101c56:	8b 45 08             	mov    0x8(%ebp),%eax
  101c59:	8b 40 0c             	mov    0xc(%eax),%eax
  101c5c:	83 ec 08             	sub    $0x8,%esp
  101c5f:	50                   	push   %eax
  101c60:	68 29 5f 10 00       	push   $0x105f29
  101c65:	e8 fd e5 ff ff       	call   100267 <cprintf>
  101c6a:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  101c70:	8b 40 10             	mov    0x10(%eax),%eax
  101c73:	83 ec 08             	sub    $0x8,%esp
  101c76:	50                   	push   %eax
  101c77:	68 38 5f 10 00       	push   $0x105f38
  101c7c:	e8 e6 e5 ff ff       	call   100267 <cprintf>
  101c81:	83 c4 10             	add    $0x10,%esp
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101c84:	8b 45 08             	mov    0x8(%ebp),%eax
  101c87:	8b 40 14             	mov    0x14(%eax),%eax
  101c8a:	83 ec 08             	sub    $0x8,%esp
  101c8d:	50                   	push   %eax
  101c8e:	68 47 5f 10 00       	push   $0x105f47
  101c93:	e8 cf e5 ff ff       	call   100267 <cprintf>
  101c98:	83 c4 10             	add    $0x10,%esp
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  101c9e:	8b 40 18             	mov    0x18(%eax),%eax
  101ca1:	83 ec 08             	sub    $0x8,%esp
  101ca4:	50                   	push   %eax
  101ca5:	68 56 5f 10 00       	push   $0x105f56
  101caa:	e8 b8 e5 ff ff       	call   100267 <cprintf>
  101caf:	83 c4 10             	add    $0x10,%esp
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  101cb5:	8b 40 1c             	mov    0x1c(%eax),%eax
  101cb8:	83 ec 08             	sub    $0x8,%esp
  101cbb:	50                   	push   %eax
  101cbc:	68 65 5f 10 00       	push   $0x105f65
  101cc1:	e8 a1 e5 ff ff       	call   100267 <cprintf>
  101cc6:	83 c4 10             	add    $0x10,%esp
}
  101cc9:	90                   	nop
  101cca:	c9                   	leave  
  101ccb:	c3                   	ret    

00101ccc <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101ccc:	55                   	push   %ebp
  101ccd:	89 e5                	mov    %esp,%ebp
  101ccf:	83 ec 18             	sub    $0x18,%esp
    char c;

    switch (tf->tf_trapno) {
  101cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  101cd5:	8b 40 30             	mov    0x30(%eax),%eax
  101cd8:	83 f8 2f             	cmp    $0x2f,%eax
  101cdb:	77 1d                	ja     101cfa <trap_dispatch+0x2e>
  101cdd:	83 f8 2e             	cmp    $0x2e,%eax
  101ce0:	0f 83 f4 00 00 00    	jae    101dda <trap_dispatch+0x10e>
  101ce6:	83 f8 21             	cmp    $0x21,%eax
  101ce9:	74 7e                	je     101d69 <trap_dispatch+0x9d>
  101ceb:	83 f8 24             	cmp    $0x24,%eax
  101cee:	74 55                	je     101d45 <trap_dispatch+0x79>
  101cf0:	83 f8 20             	cmp    $0x20,%eax
  101cf3:	74 16                	je     101d0b <trap_dispatch+0x3f>
  101cf5:	e9 aa 00 00 00       	jmp    101da4 <trap_dispatch+0xd8>
  101cfa:	83 e8 78             	sub    $0x78,%eax
  101cfd:	83 f8 01             	cmp    $0x1,%eax
  101d00:	0f 87 9e 00 00 00    	ja     101da4 <trap_dispatch+0xd8>
  101d06:	e9 82 00 00 00       	jmp    101d8d <trap_dispatch+0xc1>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
  101d0b:	a1 4c 89 11 00       	mov    0x11894c,%eax
  101d10:	83 c0 01             	add    $0x1,%eax
  101d13:	a3 4c 89 11 00       	mov    %eax,0x11894c
        if(ticks % TICK_NUM == 0)
  101d18:	8b 0d 4c 89 11 00    	mov    0x11894c,%ecx
  101d1e:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101d23:	89 c8                	mov    %ecx,%eax
  101d25:	f7 e2                	mul    %edx
  101d27:	89 d0                	mov    %edx,%eax
  101d29:	c1 e8 05             	shr    $0x5,%eax
  101d2c:	6b c0 64             	imul   $0x64,%eax,%eax
  101d2f:	29 c1                	sub    %eax,%ecx
  101d31:	89 c8                	mov    %ecx,%eax
  101d33:	85 c0                	test   %eax,%eax
  101d35:	0f 85 a2 00 00 00    	jne    101ddd <trap_dispatch+0x111>
                print_ticks();
  101d3b:	e8 1b fb ff ff       	call   10185b <print_ticks>
        break;
  101d40:	e9 98 00 00 00       	jmp    101ddd <trap_dispatch+0x111>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101d45:	e8 ce f8 ff ff       	call   101618 <cons_getc>
  101d4a:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101d4d:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101d51:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101d55:	83 ec 04             	sub    $0x4,%esp
  101d58:	52                   	push   %edx
  101d59:	50                   	push   %eax
  101d5a:	68 74 5f 10 00       	push   $0x105f74
  101d5f:	e8 03 e5 ff ff       	call   100267 <cprintf>
  101d64:	83 c4 10             	add    $0x10,%esp
        break;
  101d67:	eb 75                	jmp    101dde <trap_dispatch+0x112>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101d69:	e8 aa f8 ff ff       	call   101618 <cons_getc>
  101d6e:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101d71:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101d75:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101d79:	83 ec 04             	sub    $0x4,%esp
  101d7c:	52                   	push   %edx
  101d7d:	50                   	push   %eax
  101d7e:	68 86 5f 10 00       	push   $0x105f86
  101d83:	e8 df e4 ff ff       	call   100267 <cprintf>
  101d88:	83 c4 10             	add    $0x10,%esp
        break;
  101d8b:	eb 51                	jmp    101dde <trap_dispatch+0x112>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101d8d:	83 ec 04             	sub    $0x4,%esp
  101d90:	68 95 5f 10 00       	push   $0x105f95
  101d95:	68 b4 00 00 00       	push   $0xb4
  101d9a:	68 a5 5f 10 00       	push   $0x105fa5
  101d9f:	e8 29 e6 ff ff       	call   1003cd <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101da4:	8b 45 08             	mov    0x8(%ebp),%eax
  101da7:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101dab:	0f b7 c0             	movzwl %ax,%eax
  101dae:	83 e0 03             	and    $0x3,%eax
  101db1:	85 c0                	test   %eax,%eax
  101db3:	75 29                	jne    101dde <trap_dispatch+0x112>
            print_trapframe(tf);
  101db5:	83 ec 0c             	sub    $0xc,%esp
  101db8:	ff 75 08             	pushl  0x8(%ebp)
  101dbb:	e8 6f fc ff ff       	call   101a2f <print_trapframe>
  101dc0:	83 c4 10             	add    $0x10,%esp
            panic("unexpected trap in kernel.\n");
  101dc3:	83 ec 04             	sub    $0x4,%esp
  101dc6:	68 b6 5f 10 00       	push   $0x105fb6
  101dcb:	68 be 00 00 00       	push   $0xbe
  101dd0:	68 a5 5f 10 00       	push   $0x105fa5
  101dd5:	e8 f3 e5 ff ff       	call   1003cd <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101dda:	90                   	nop
  101ddb:	eb 01                	jmp    101dde <trap_dispatch+0x112>
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
        if(ticks % TICK_NUM == 0)
                print_ticks();
        break;
  101ddd:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101dde:	90                   	nop
  101ddf:	c9                   	leave  
  101de0:	c3                   	ret    

00101de1 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101de1:	55                   	push   %ebp
  101de2:	89 e5                	mov    %esp,%ebp
  101de4:	83 ec 08             	sub    $0x8,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101de7:	83 ec 0c             	sub    $0xc,%esp
  101dea:	ff 75 08             	pushl  0x8(%ebp)
  101ded:	e8 da fe ff ff       	call   101ccc <trap_dispatch>
  101df2:	83 c4 10             	add    $0x10,%esp
}
  101df5:	90                   	nop
  101df6:	c9                   	leave  
  101df7:	c3                   	ret    

00101df8 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101df8:	6a 00                	push   $0x0
  pushl $0
  101dfa:	6a 00                	push   $0x0
  jmp __alltraps
  101dfc:	e9 67 0a 00 00       	jmp    102868 <__alltraps>

00101e01 <vector1>:
.globl vector1
vector1:
  pushl $0
  101e01:	6a 00                	push   $0x0
  pushl $1
  101e03:	6a 01                	push   $0x1
  jmp __alltraps
  101e05:	e9 5e 0a 00 00       	jmp    102868 <__alltraps>

00101e0a <vector2>:
.globl vector2
vector2:
  pushl $0
  101e0a:	6a 00                	push   $0x0
  pushl $2
  101e0c:	6a 02                	push   $0x2
  jmp __alltraps
  101e0e:	e9 55 0a 00 00       	jmp    102868 <__alltraps>

00101e13 <vector3>:
.globl vector3
vector3:
  pushl $0
  101e13:	6a 00                	push   $0x0
  pushl $3
  101e15:	6a 03                	push   $0x3
  jmp __alltraps
  101e17:	e9 4c 0a 00 00       	jmp    102868 <__alltraps>

00101e1c <vector4>:
.globl vector4
vector4:
  pushl $0
  101e1c:	6a 00                	push   $0x0
  pushl $4
  101e1e:	6a 04                	push   $0x4
  jmp __alltraps
  101e20:	e9 43 0a 00 00       	jmp    102868 <__alltraps>

00101e25 <vector5>:
.globl vector5
vector5:
  pushl $0
  101e25:	6a 00                	push   $0x0
  pushl $5
  101e27:	6a 05                	push   $0x5
  jmp __alltraps
  101e29:	e9 3a 0a 00 00       	jmp    102868 <__alltraps>

00101e2e <vector6>:
.globl vector6
vector6:
  pushl $0
  101e2e:	6a 00                	push   $0x0
  pushl $6
  101e30:	6a 06                	push   $0x6
  jmp __alltraps
  101e32:	e9 31 0a 00 00       	jmp    102868 <__alltraps>

00101e37 <vector7>:
.globl vector7
vector7:
  pushl $0
  101e37:	6a 00                	push   $0x0
  pushl $7
  101e39:	6a 07                	push   $0x7
  jmp __alltraps
  101e3b:	e9 28 0a 00 00       	jmp    102868 <__alltraps>

00101e40 <vector8>:
.globl vector8
vector8:
  pushl $8
  101e40:	6a 08                	push   $0x8
  jmp __alltraps
  101e42:	e9 21 0a 00 00       	jmp    102868 <__alltraps>

00101e47 <vector9>:
.globl vector9
vector9:
  pushl $9
  101e47:	6a 09                	push   $0x9
  jmp __alltraps
  101e49:	e9 1a 0a 00 00       	jmp    102868 <__alltraps>

00101e4e <vector10>:
.globl vector10
vector10:
  pushl $10
  101e4e:	6a 0a                	push   $0xa
  jmp __alltraps
  101e50:	e9 13 0a 00 00       	jmp    102868 <__alltraps>

00101e55 <vector11>:
.globl vector11
vector11:
  pushl $11
  101e55:	6a 0b                	push   $0xb
  jmp __alltraps
  101e57:	e9 0c 0a 00 00       	jmp    102868 <__alltraps>

00101e5c <vector12>:
.globl vector12
vector12:
  pushl $12
  101e5c:	6a 0c                	push   $0xc
  jmp __alltraps
  101e5e:	e9 05 0a 00 00       	jmp    102868 <__alltraps>

00101e63 <vector13>:
.globl vector13
vector13:
  pushl $13
  101e63:	6a 0d                	push   $0xd
  jmp __alltraps
  101e65:	e9 fe 09 00 00       	jmp    102868 <__alltraps>

00101e6a <vector14>:
.globl vector14
vector14:
  pushl $14
  101e6a:	6a 0e                	push   $0xe
  jmp __alltraps
  101e6c:	e9 f7 09 00 00       	jmp    102868 <__alltraps>

00101e71 <vector15>:
.globl vector15
vector15:
  pushl $0
  101e71:	6a 00                	push   $0x0
  pushl $15
  101e73:	6a 0f                	push   $0xf
  jmp __alltraps
  101e75:	e9 ee 09 00 00       	jmp    102868 <__alltraps>

00101e7a <vector16>:
.globl vector16
vector16:
  pushl $0
  101e7a:	6a 00                	push   $0x0
  pushl $16
  101e7c:	6a 10                	push   $0x10
  jmp __alltraps
  101e7e:	e9 e5 09 00 00       	jmp    102868 <__alltraps>

00101e83 <vector17>:
.globl vector17
vector17:
  pushl $17
  101e83:	6a 11                	push   $0x11
  jmp __alltraps
  101e85:	e9 de 09 00 00       	jmp    102868 <__alltraps>

00101e8a <vector18>:
.globl vector18
vector18:
  pushl $0
  101e8a:	6a 00                	push   $0x0
  pushl $18
  101e8c:	6a 12                	push   $0x12
  jmp __alltraps
  101e8e:	e9 d5 09 00 00       	jmp    102868 <__alltraps>

00101e93 <vector19>:
.globl vector19
vector19:
  pushl $0
  101e93:	6a 00                	push   $0x0
  pushl $19
  101e95:	6a 13                	push   $0x13
  jmp __alltraps
  101e97:	e9 cc 09 00 00       	jmp    102868 <__alltraps>

00101e9c <vector20>:
.globl vector20
vector20:
  pushl $0
  101e9c:	6a 00                	push   $0x0
  pushl $20
  101e9e:	6a 14                	push   $0x14
  jmp __alltraps
  101ea0:	e9 c3 09 00 00       	jmp    102868 <__alltraps>

00101ea5 <vector21>:
.globl vector21
vector21:
  pushl $0
  101ea5:	6a 00                	push   $0x0
  pushl $21
  101ea7:	6a 15                	push   $0x15
  jmp __alltraps
  101ea9:	e9 ba 09 00 00       	jmp    102868 <__alltraps>

00101eae <vector22>:
.globl vector22
vector22:
  pushl $0
  101eae:	6a 00                	push   $0x0
  pushl $22
  101eb0:	6a 16                	push   $0x16
  jmp __alltraps
  101eb2:	e9 b1 09 00 00       	jmp    102868 <__alltraps>

00101eb7 <vector23>:
.globl vector23
vector23:
  pushl $0
  101eb7:	6a 00                	push   $0x0
  pushl $23
  101eb9:	6a 17                	push   $0x17
  jmp __alltraps
  101ebb:	e9 a8 09 00 00       	jmp    102868 <__alltraps>

00101ec0 <vector24>:
.globl vector24
vector24:
  pushl $0
  101ec0:	6a 00                	push   $0x0
  pushl $24
  101ec2:	6a 18                	push   $0x18
  jmp __alltraps
  101ec4:	e9 9f 09 00 00       	jmp    102868 <__alltraps>

00101ec9 <vector25>:
.globl vector25
vector25:
  pushl $0
  101ec9:	6a 00                	push   $0x0
  pushl $25
  101ecb:	6a 19                	push   $0x19
  jmp __alltraps
  101ecd:	e9 96 09 00 00       	jmp    102868 <__alltraps>

00101ed2 <vector26>:
.globl vector26
vector26:
  pushl $0
  101ed2:	6a 00                	push   $0x0
  pushl $26
  101ed4:	6a 1a                	push   $0x1a
  jmp __alltraps
  101ed6:	e9 8d 09 00 00       	jmp    102868 <__alltraps>

00101edb <vector27>:
.globl vector27
vector27:
  pushl $0
  101edb:	6a 00                	push   $0x0
  pushl $27
  101edd:	6a 1b                	push   $0x1b
  jmp __alltraps
  101edf:	e9 84 09 00 00       	jmp    102868 <__alltraps>

00101ee4 <vector28>:
.globl vector28
vector28:
  pushl $0
  101ee4:	6a 00                	push   $0x0
  pushl $28
  101ee6:	6a 1c                	push   $0x1c
  jmp __alltraps
  101ee8:	e9 7b 09 00 00       	jmp    102868 <__alltraps>

00101eed <vector29>:
.globl vector29
vector29:
  pushl $0
  101eed:	6a 00                	push   $0x0
  pushl $29
  101eef:	6a 1d                	push   $0x1d
  jmp __alltraps
  101ef1:	e9 72 09 00 00       	jmp    102868 <__alltraps>

00101ef6 <vector30>:
.globl vector30
vector30:
  pushl $0
  101ef6:	6a 00                	push   $0x0
  pushl $30
  101ef8:	6a 1e                	push   $0x1e
  jmp __alltraps
  101efa:	e9 69 09 00 00       	jmp    102868 <__alltraps>

00101eff <vector31>:
.globl vector31
vector31:
  pushl $0
  101eff:	6a 00                	push   $0x0
  pushl $31
  101f01:	6a 1f                	push   $0x1f
  jmp __alltraps
  101f03:	e9 60 09 00 00       	jmp    102868 <__alltraps>

00101f08 <vector32>:
.globl vector32
vector32:
  pushl $0
  101f08:	6a 00                	push   $0x0
  pushl $32
  101f0a:	6a 20                	push   $0x20
  jmp __alltraps
  101f0c:	e9 57 09 00 00       	jmp    102868 <__alltraps>

00101f11 <vector33>:
.globl vector33
vector33:
  pushl $0
  101f11:	6a 00                	push   $0x0
  pushl $33
  101f13:	6a 21                	push   $0x21
  jmp __alltraps
  101f15:	e9 4e 09 00 00       	jmp    102868 <__alltraps>

00101f1a <vector34>:
.globl vector34
vector34:
  pushl $0
  101f1a:	6a 00                	push   $0x0
  pushl $34
  101f1c:	6a 22                	push   $0x22
  jmp __alltraps
  101f1e:	e9 45 09 00 00       	jmp    102868 <__alltraps>

00101f23 <vector35>:
.globl vector35
vector35:
  pushl $0
  101f23:	6a 00                	push   $0x0
  pushl $35
  101f25:	6a 23                	push   $0x23
  jmp __alltraps
  101f27:	e9 3c 09 00 00       	jmp    102868 <__alltraps>

00101f2c <vector36>:
.globl vector36
vector36:
  pushl $0
  101f2c:	6a 00                	push   $0x0
  pushl $36
  101f2e:	6a 24                	push   $0x24
  jmp __alltraps
  101f30:	e9 33 09 00 00       	jmp    102868 <__alltraps>

00101f35 <vector37>:
.globl vector37
vector37:
  pushl $0
  101f35:	6a 00                	push   $0x0
  pushl $37
  101f37:	6a 25                	push   $0x25
  jmp __alltraps
  101f39:	e9 2a 09 00 00       	jmp    102868 <__alltraps>

00101f3e <vector38>:
.globl vector38
vector38:
  pushl $0
  101f3e:	6a 00                	push   $0x0
  pushl $38
  101f40:	6a 26                	push   $0x26
  jmp __alltraps
  101f42:	e9 21 09 00 00       	jmp    102868 <__alltraps>

00101f47 <vector39>:
.globl vector39
vector39:
  pushl $0
  101f47:	6a 00                	push   $0x0
  pushl $39
  101f49:	6a 27                	push   $0x27
  jmp __alltraps
  101f4b:	e9 18 09 00 00       	jmp    102868 <__alltraps>

00101f50 <vector40>:
.globl vector40
vector40:
  pushl $0
  101f50:	6a 00                	push   $0x0
  pushl $40
  101f52:	6a 28                	push   $0x28
  jmp __alltraps
  101f54:	e9 0f 09 00 00       	jmp    102868 <__alltraps>

00101f59 <vector41>:
.globl vector41
vector41:
  pushl $0
  101f59:	6a 00                	push   $0x0
  pushl $41
  101f5b:	6a 29                	push   $0x29
  jmp __alltraps
  101f5d:	e9 06 09 00 00       	jmp    102868 <__alltraps>

00101f62 <vector42>:
.globl vector42
vector42:
  pushl $0
  101f62:	6a 00                	push   $0x0
  pushl $42
  101f64:	6a 2a                	push   $0x2a
  jmp __alltraps
  101f66:	e9 fd 08 00 00       	jmp    102868 <__alltraps>

00101f6b <vector43>:
.globl vector43
vector43:
  pushl $0
  101f6b:	6a 00                	push   $0x0
  pushl $43
  101f6d:	6a 2b                	push   $0x2b
  jmp __alltraps
  101f6f:	e9 f4 08 00 00       	jmp    102868 <__alltraps>

00101f74 <vector44>:
.globl vector44
vector44:
  pushl $0
  101f74:	6a 00                	push   $0x0
  pushl $44
  101f76:	6a 2c                	push   $0x2c
  jmp __alltraps
  101f78:	e9 eb 08 00 00       	jmp    102868 <__alltraps>

00101f7d <vector45>:
.globl vector45
vector45:
  pushl $0
  101f7d:	6a 00                	push   $0x0
  pushl $45
  101f7f:	6a 2d                	push   $0x2d
  jmp __alltraps
  101f81:	e9 e2 08 00 00       	jmp    102868 <__alltraps>

00101f86 <vector46>:
.globl vector46
vector46:
  pushl $0
  101f86:	6a 00                	push   $0x0
  pushl $46
  101f88:	6a 2e                	push   $0x2e
  jmp __alltraps
  101f8a:	e9 d9 08 00 00       	jmp    102868 <__alltraps>

00101f8f <vector47>:
.globl vector47
vector47:
  pushl $0
  101f8f:	6a 00                	push   $0x0
  pushl $47
  101f91:	6a 2f                	push   $0x2f
  jmp __alltraps
  101f93:	e9 d0 08 00 00       	jmp    102868 <__alltraps>

00101f98 <vector48>:
.globl vector48
vector48:
  pushl $0
  101f98:	6a 00                	push   $0x0
  pushl $48
  101f9a:	6a 30                	push   $0x30
  jmp __alltraps
  101f9c:	e9 c7 08 00 00       	jmp    102868 <__alltraps>

00101fa1 <vector49>:
.globl vector49
vector49:
  pushl $0
  101fa1:	6a 00                	push   $0x0
  pushl $49
  101fa3:	6a 31                	push   $0x31
  jmp __alltraps
  101fa5:	e9 be 08 00 00       	jmp    102868 <__alltraps>

00101faa <vector50>:
.globl vector50
vector50:
  pushl $0
  101faa:	6a 00                	push   $0x0
  pushl $50
  101fac:	6a 32                	push   $0x32
  jmp __alltraps
  101fae:	e9 b5 08 00 00       	jmp    102868 <__alltraps>

00101fb3 <vector51>:
.globl vector51
vector51:
  pushl $0
  101fb3:	6a 00                	push   $0x0
  pushl $51
  101fb5:	6a 33                	push   $0x33
  jmp __alltraps
  101fb7:	e9 ac 08 00 00       	jmp    102868 <__alltraps>

00101fbc <vector52>:
.globl vector52
vector52:
  pushl $0
  101fbc:	6a 00                	push   $0x0
  pushl $52
  101fbe:	6a 34                	push   $0x34
  jmp __alltraps
  101fc0:	e9 a3 08 00 00       	jmp    102868 <__alltraps>

00101fc5 <vector53>:
.globl vector53
vector53:
  pushl $0
  101fc5:	6a 00                	push   $0x0
  pushl $53
  101fc7:	6a 35                	push   $0x35
  jmp __alltraps
  101fc9:	e9 9a 08 00 00       	jmp    102868 <__alltraps>

00101fce <vector54>:
.globl vector54
vector54:
  pushl $0
  101fce:	6a 00                	push   $0x0
  pushl $54
  101fd0:	6a 36                	push   $0x36
  jmp __alltraps
  101fd2:	e9 91 08 00 00       	jmp    102868 <__alltraps>

00101fd7 <vector55>:
.globl vector55
vector55:
  pushl $0
  101fd7:	6a 00                	push   $0x0
  pushl $55
  101fd9:	6a 37                	push   $0x37
  jmp __alltraps
  101fdb:	e9 88 08 00 00       	jmp    102868 <__alltraps>

00101fe0 <vector56>:
.globl vector56
vector56:
  pushl $0
  101fe0:	6a 00                	push   $0x0
  pushl $56
  101fe2:	6a 38                	push   $0x38
  jmp __alltraps
  101fe4:	e9 7f 08 00 00       	jmp    102868 <__alltraps>

00101fe9 <vector57>:
.globl vector57
vector57:
  pushl $0
  101fe9:	6a 00                	push   $0x0
  pushl $57
  101feb:	6a 39                	push   $0x39
  jmp __alltraps
  101fed:	e9 76 08 00 00       	jmp    102868 <__alltraps>

00101ff2 <vector58>:
.globl vector58
vector58:
  pushl $0
  101ff2:	6a 00                	push   $0x0
  pushl $58
  101ff4:	6a 3a                	push   $0x3a
  jmp __alltraps
  101ff6:	e9 6d 08 00 00       	jmp    102868 <__alltraps>

00101ffb <vector59>:
.globl vector59
vector59:
  pushl $0
  101ffb:	6a 00                	push   $0x0
  pushl $59
  101ffd:	6a 3b                	push   $0x3b
  jmp __alltraps
  101fff:	e9 64 08 00 00       	jmp    102868 <__alltraps>

00102004 <vector60>:
.globl vector60
vector60:
  pushl $0
  102004:	6a 00                	push   $0x0
  pushl $60
  102006:	6a 3c                	push   $0x3c
  jmp __alltraps
  102008:	e9 5b 08 00 00       	jmp    102868 <__alltraps>

0010200d <vector61>:
.globl vector61
vector61:
  pushl $0
  10200d:	6a 00                	push   $0x0
  pushl $61
  10200f:	6a 3d                	push   $0x3d
  jmp __alltraps
  102011:	e9 52 08 00 00       	jmp    102868 <__alltraps>

00102016 <vector62>:
.globl vector62
vector62:
  pushl $0
  102016:	6a 00                	push   $0x0
  pushl $62
  102018:	6a 3e                	push   $0x3e
  jmp __alltraps
  10201a:	e9 49 08 00 00       	jmp    102868 <__alltraps>

0010201f <vector63>:
.globl vector63
vector63:
  pushl $0
  10201f:	6a 00                	push   $0x0
  pushl $63
  102021:	6a 3f                	push   $0x3f
  jmp __alltraps
  102023:	e9 40 08 00 00       	jmp    102868 <__alltraps>

00102028 <vector64>:
.globl vector64
vector64:
  pushl $0
  102028:	6a 00                	push   $0x0
  pushl $64
  10202a:	6a 40                	push   $0x40
  jmp __alltraps
  10202c:	e9 37 08 00 00       	jmp    102868 <__alltraps>

00102031 <vector65>:
.globl vector65
vector65:
  pushl $0
  102031:	6a 00                	push   $0x0
  pushl $65
  102033:	6a 41                	push   $0x41
  jmp __alltraps
  102035:	e9 2e 08 00 00       	jmp    102868 <__alltraps>

0010203a <vector66>:
.globl vector66
vector66:
  pushl $0
  10203a:	6a 00                	push   $0x0
  pushl $66
  10203c:	6a 42                	push   $0x42
  jmp __alltraps
  10203e:	e9 25 08 00 00       	jmp    102868 <__alltraps>

00102043 <vector67>:
.globl vector67
vector67:
  pushl $0
  102043:	6a 00                	push   $0x0
  pushl $67
  102045:	6a 43                	push   $0x43
  jmp __alltraps
  102047:	e9 1c 08 00 00       	jmp    102868 <__alltraps>

0010204c <vector68>:
.globl vector68
vector68:
  pushl $0
  10204c:	6a 00                	push   $0x0
  pushl $68
  10204e:	6a 44                	push   $0x44
  jmp __alltraps
  102050:	e9 13 08 00 00       	jmp    102868 <__alltraps>

00102055 <vector69>:
.globl vector69
vector69:
  pushl $0
  102055:	6a 00                	push   $0x0
  pushl $69
  102057:	6a 45                	push   $0x45
  jmp __alltraps
  102059:	e9 0a 08 00 00       	jmp    102868 <__alltraps>

0010205e <vector70>:
.globl vector70
vector70:
  pushl $0
  10205e:	6a 00                	push   $0x0
  pushl $70
  102060:	6a 46                	push   $0x46
  jmp __alltraps
  102062:	e9 01 08 00 00       	jmp    102868 <__alltraps>

00102067 <vector71>:
.globl vector71
vector71:
  pushl $0
  102067:	6a 00                	push   $0x0
  pushl $71
  102069:	6a 47                	push   $0x47
  jmp __alltraps
  10206b:	e9 f8 07 00 00       	jmp    102868 <__alltraps>

00102070 <vector72>:
.globl vector72
vector72:
  pushl $0
  102070:	6a 00                	push   $0x0
  pushl $72
  102072:	6a 48                	push   $0x48
  jmp __alltraps
  102074:	e9 ef 07 00 00       	jmp    102868 <__alltraps>

00102079 <vector73>:
.globl vector73
vector73:
  pushl $0
  102079:	6a 00                	push   $0x0
  pushl $73
  10207b:	6a 49                	push   $0x49
  jmp __alltraps
  10207d:	e9 e6 07 00 00       	jmp    102868 <__alltraps>

00102082 <vector74>:
.globl vector74
vector74:
  pushl $0
  102082:	6a 00                	push   $0x0
  pushl $74
  102084:	6a 4a                	push   $0x4a
  jmp __alltraps
  102086:	e9 dd 07 00 00       	jmp    102868 <__alltraps>

0010208b <vector75>:
.globl vector75
vector75:
  pushl $0
  10208b:	6a 00                	push   $0x0
  pushl $75
  10208d:	6a 4b                	push   $0x4b
  jmp __alltraps
  10208f:	e9 d4 07 00 00       	jmp    102868 <__alltraps>

00102094 <vector76>:
.globl vector76
vector76:
  pushl $0
  102094:	6a 00                	push   $0x0
  pushl $76
  102096:	6a 4c                	push   $0x4c
  jmp __alltraps
  102098:	e9 cb 07 00 00       	jmp    102868 <__alltraps>

0010209d <vector77>:
.globl vector77
vector77:
  pushl $0
  10209d:	6a 00                	push   $0x0
  pushl $77
  10209f:	6a 4d                	push   $0x4d
  jmp __alltraps
  1020a1:	e9 c2 07 00 00       	jmp    102868 <__alltraps>

001020a6 <vector78>:
.globl vector78
vector78:
  pushl $0
  1020a6:	6a 00                	push   $0x0
  pushl $78
  1020a8:	6a 4e                	push   $0x4e
  jmp __alltraps
  1020aa:	e9 b9 07 00 00       	jmp    102868 <__alltraps>

001020af <vector79>:
.globl vector79
vector79:
  pushl $0
  1020af:	6a 00                	push   $0x0
  pushl $79
  1020b1:	6a 4f                	push   $0x4f
  jmp __alltraps
  1020b3:	e9 b0 07 00 00       	jmp    102868 <__alltraps>

001020b8 <vector80>:
.globl vector80
vector80:
  pushl $0
  1020b8:	6a 00                	push   $0x0
  pushl $80
  1020ba:	6a 50                	push   $0x50
  jmp __alltraps
  1020bc:	e9 a7 07 00 00       	jmp    102868 <__alltraps>

001020c1 <vector81>:
.globl vector81
vector81:
  pushl $0
  1020c1:	6a 00                	push   $0x0
  pushl $81
  1020c3:	6a 51                	push   $0x51
  jmp __alltraps
  1020c5:	e9 9e 07 00 00       	jmp    102868 <__alltraps>

001020ca <vector82>:
.globl vector82
vector82:
  pushl $0
  1020ca:	6a 00                	push   $0x0
  pushl $82
  1020cc:	6a 52                	push   $0x52
  jmp __alltraps
  1020ce:	e9 95 07 00 00       	jmp    102868 <__alltraps>

001020d3 <vector83>:
.globl vector83
vector83:
  pushl $0
  1020d3:	6a 00                	push   $0x0
  pushl $83
  1020d5:	6a 53                	push   $0x53
  jmp __alltraps
  1020d7:	e9 8c 07 00 00       	jmp    102868 <__alltraps>

001020dc <vector84>:
.globl vector84
vector84:
  pushl $0
  1020dc:	6a 00                	push   $0x0
  pushl $84
  1020de:	6a 54                	push   $0x54
  jmp __alltraps
  1020e0:	e9 83 07 00 00       	jmp    102868 <__alltraps>

001020e5 <vector85>:
.globl vector85
vector85:
  pushl $0
  1020e5:	6a 00                	push   $0x0
  pushl $85
  1020e7:	6a 55                	push   $0x55
  jmp __alltraps
  1020e9:	e9 7a 07 00 00       	jmp    102868 <__alltraps>

001020ee <vector86>:
.globl vector86
vector86:
  pushl $0
  1020ee:	6a 00                	push   $0x0
  pushl $86
  1020f0:	6a 56                	push   $0x56
  jmp __alltraps
  1020f2:	e9 71 07 00 00       	jmp    102868 <__alltraps>

001020f7 <vector87>:
.globl vector87
vector87:
  pushl $0
  1020f7:	6a 00                	push   $0x0
  pushl $87
  1020f9:	6a 57                	push   $0x57
  jmp __alltraps
  1020fb:	e9 68 07 00 00       	jmp    102868 <__alltraps>

00102100 <vector88>:
.globl vector88
vector88:
  pushl $0
  102100:	6a 00                	push   $0x0
  pushl $88
  102102:	6a 58                	push   $0x58
  jmp __alltraps
  102104:	e9 5f 07 00 00       	jmp    102868 <__alltraps>

00102109 <vector89>:
.globl vector89
vector89:
  pushl $0
  102109:	6a 00                	push   $0x0
  pushl $89
  10210b:	6a 59                	push   $0x59
  jmp __alltraps
  10210d:	e9 56 07 00 00       	jmp    102868 <__alltraps>

00102112 <vector90>:
.globl vector90
vector90:
  pushl $0
  102112:	6a 00                	push   $0x0
  pushl $90
  102114:	6a 5a                	push   $0x5a
  jmp __alltraps
  102116:	e9 4d 07 00 00       	jmp    102868 <__alltraps>

0010211b <vector91>:
.globl vector91
vector91:
  pushl $0
  10211b:	6a 00                	push   $0x0
  pushl $91
  10211d:	6a 5b                	push   $0x5b
  jmp __alltraps
  10211f:	e9 44 07 00 00       	jmp    102868 <__alltraps>

00102124 <vector92>:
.globl vector92
vector92:
  pushl $0
  102124:	6a 00                	push   $0x0
  pushl $92
  102126:	6a 5c                	push   $0x5c
  jmp __alltraps
  102128:	e9 3b 07 00 00       	jmp    102868 <__alltraps>

0010212d <vector93>:
.globl vector93
vector93:
  pushl $0
  10212d:	6a 00                	push   $0x0
  pushl $93
  10212f:	6a 5d                	push   $0x5d
  jmp __alltraps
  102131:	e9 32 07 00 00       	jmp    102868 <__alltraps>

00102136 <vector94>:
.globl vector94
vector94:
  pushl $0
  102136:	6a 00                	push   $0x0
  pushl $94
  102138:	6a 5e                	push   $0x5e
  jmp __alltraps
  10213a:	e9 29 07 00 00       	jmp    102868 <__alltraps>

0010213f <vector95>:
.globl vector95
vector95:
  pushl $0
  10213f:	6a 00                	push   $0x0
  pushl $95
  102141:	6a 5f                	push   $0x5f
  jmp __alltraps
  102143:	e9 20 07 00 00       	jmp    102868 <__alltraps>

00102148 <vector96>:
.globl vector96
vector96:
  pushl $0
  102148:	6a 00                	push   $0x0
  pushl $96
  10214a:	6a 60                	push   $0x60
  jmp __alltraps
  10214c:	e9 17 07 00 00       	jmp    102868 <__alltraps>

00102151 <vector97>:
.globl vector97
vector97:
  pushl $0
  102151:	6a 00                	push   $0x0
  pushl $97
  102153:	6a 61                	push   $0x61
  jmp __alltraps
  102155:	e9 0e 07 00 00       	jmp    102868 <__alltraps>

0010215a <vector98>:
.globl vector98
vector98:
  pushl $0
  10215a:	6a 00                	push   $0x0
  pushl $98
  10215c:	6a 62                	push   $0x62
  jmp __alltraps
  10215e:	e9 05 07 00 00       	jmp    102868 <__alltraps>

00102163 <vector99>:
.globl vector99
vector99:
  pushl $0
  102163:	6a 00                	push   $0x0
  pushl $99
  102165:	6a 63                	push   $0x63
  jmp __alltraps
  102167:	e9 fc 06 00 00       	jmp    102868 <__alltraps>

0010216c <vector100>:
.globl vector100
vector100:
  pushl $0
  10216c:	6a 00                	push   $0x0
  pushl $100
  10216e:	6a 64                	push   $0x64
  jmp __alltraps
  102170:	e9 f3 06 00 00       	jmp    102868 <__alltraps>

00102175 <vector101>:
.globl vector101
vector101:
  pushl $0
  102175:	6a 00                	push   $0x0
  pushl $101
  102177:	6a 65                	push   $0x65
  jmp __alltraps
  102179:	e9 ea 06 00 00       	jmp    102868 <__alltraps>

0010217e <vector102>:
.globl vector102
vector102:
  pushl $0
  10217e:	6a 00                	push   $0x0
  pushl $102
  102180:	6a 66                	push   $0x66
  jmp __alltraps
  102182:	e9 e1 06 00 00       	jmp    102868 <__alltraps>

00102187 <vector103>:
.globl vector103
vector103:
  pushl $0
  102187:	6a 00                	push   $0x0
  pushl $103
  102189:	6a 67                	push   $0x67
  jmp __alltraps
  10218b:	e9 d8 06 00 00       	jmp    102868 <__alltraps>

00102190 <vector104>:
.globl vector104
vector104:
  pushl $0
  102190:	6a 00                	push   $0x0
  pushl $104
  102192:	6a 68                	push   $0x68
  jmp __alltraps
  102194:	e9 cf 06 00 00       	jmp    102868 <__alltraps>

00102199 <vector105>:
.globl vector105
vector105:
  pushl $0
  102199:	6a 00                	push   $0x0
  pushl $105
  10219b:	6a 69                	push   $0x69
  jmp __alltraps
  10219d:	e9 c6 06 00 00       	jmp    102868 <__alltraps>

001021a2 <vector106>:
.globl vector106
vector106:
  pushl $0
  1021a2:	6a 00                	push   $0x0
  pushl $106
  1021a4:	6a 6a                	push   $0x6a
  jmp __alltraps
  1021a6:	e9 bd 06 00 00       	jmp    102868 <__alltraps>

001021ab <vector107>:
.globl vector107
vector107:
  pushl $0
  1021ab:	6a 00                	push   $0x0
  pushl $107
  1021ad:	6a 6b                	push   $0x6b
  jmp __alltraps
  1021af:	e9 b4 06 00 00       	jmp    102868 <__alltraps>

001021b4 <vector108>:
.globl vector108
vector108:
  pushl $0
  1021b4:	6a 00                	push   $0x0
  pushl $108
  1021b6:	6a 6c                	push   $0x6c
  jmp __alltraps
  1021b8:	e9 ab 06 00 00       	jmp    102868 <__alltraps>

001021bd <vector109>:
.globl vector109
vector109:
  pushl $0
  1021bd:	6a 00                	push   $0x0
  pushl $109
  1021bf:	6a 6d                	push   $0x6d
  jmp __alltraps
  1021c1:	e9 a2 06 00 00       	jmp    102868 <__alltraps>

001021c6 <vector110>:
.globl vector110
vector110:
  pushl $0
  1021c6:	6a 00                	push   $0x0
  pushl $110
  1021c8:	6a 6e                	push   $0x6e
  jmp __alltraps
  1021ca:	e9 99 06 00 00       	jmp    102868 <__alltraps>

001021cf <vector111>:
.globl vector111
vector111:
  pushl $0
  1021cf:	6a 00                	push   $0x0
  pushl $111
  1021d1:	6a 6f                	push   $0x6f
  jmp __alltraps
  1021d3:	e9 90 06 00 00       	jmp    102868 <__alltraps>

001021d8 <vector112>:
.globl vector112
vector112:
  pushl $0
  1021d8:	6a 00                	push   $0x0
  pushl $112
  1021da:	6a 70                	push   $0x70
  jmp __alltraps
  1021dc:	e9 87 06 00 00       	jmp    102868 <__alltraps>

001021e1 <vector113>:
.globl vector113
vector113:
  pushl $0
  1021e1:	6a 00                	push   $0x0
  pushl $113
  1021e3:	6a 71                	push   $0x71
  jmp __alltraps
  1021e5:	e9 7e 06 00 00       	jmp    102868 <__alltraps>

001021ea <vector114>:
.globl vector114
vector114:
  pushl $0
  1021ea:	6a 00                	push   $0x0
  pushl $114
  1021ec:	6a 72                	push   $0x72
  jmp __alltraps
  1021ee:	e9 75 06 00 00       	jmp    102868 <__alltraps>

001021f3 <vector115>:
.globl vector115
vector115:
  pushl $0
  1021f3:	6a 00                	push   $0x0
  pushl $115
  1021f5:	6a 73                	push   $0x73
  jmp __alltraps
  1021f7:	e9 6c 06 00 00       	jmp    102868 <__alltraps>

001021fc <vector116>:
.globl vector116
vector116:
  pushl $0
  1021fc:	6a 00                	push   $0x0
  pushl $116
  1021fe:	6a 74                	push   $0x74
  jmp __alltraps
  102200:	e9 63 06 00 00       	jmp    102868 <__alltraps>

00102205 <vector117>:
.globl vector117
vector117:
  pushl $0
  102205:	6a 00                	push   $0x0
  pushl $117
  102207:	6a 75                	push   $0x75
  jmp __alltraps
  102209:	e9 5a 06 00 00       	jmp    102868 <__alltraps>

0010220e <vector118>:
.globl vector118
vector118:
  pushl $0
  10220e:	6a 00                	push   $0x0
  pushl $118
  102210:	6a 76                	push   $0x76
  jmp __alltraps
  102212:	e9 51 06 00 00       	jmp    102868 <__alltraps>

00102217 <vector119>:
.globl vector119
vector119:
  pushl $0
  102217:	6a 00                	push   $0x0
  pushl $119
  102219:	6a 77                	push   $0x77
  jmp __alltraps
  10221b:	e9 48 06 00 00       	jmp    102868 <__alltraps>

00102220 <vector120>:
.globl vector120
vector120:
  pushl $0
  102220:	6a 00                	push   $0x0
  pushl $120
  102222:	6a 78                	push   $0x78
  jmp __alltraps
  102224:	e9 3f 06 00 00       	jmp    102868 <__alltraps>

00102229 <vector121>:
.globl vector121
vector121:
  pushl $0
  102229:	6a 00                	push   $0x0
  pushl $121
  10222b:	6a 79                	push   $0x79
  jmp __alltraps
  10222d:	e9 36 06 00 00       	jmp    102868 <__alltraps>

00102232 <vector122>:
.globl vector122
vector122:
  pushl $0
  102232:	6a 00                	push   $0x0
  pushl $122
  102234:	6a 7a                	push   $0x7a
  jmp __alltraps
  102236:	e9 2d 06 00 00       	jmp    102868 <__alltraps>

0010223b <vector123>:
.globl vector123
vector123:
  pushl $0
  10223b:	6a 00                	push   $0x0
  pushl $123
  10223d:	6a 7b                	push   $0x7b
  jmp __alltraps
  10223f:	e9 24 06 00 00       	jmp    102868 <__alltraps>

00102244 <vector124>:
.globl vector124
vector124:
  pushl $0
  102244:	6a 00                	push   $0x0
  pushl $124
  102246:	6a 7c                	push   $0x7c
  jmp __alltraps
  102248:	e9 1b 06 00 00       	jmp    102868 <__alltraps>

0010224d <vector125>:
.globl vector125
vector125:
  pushl $0
  10224d:	6a 00                	push   $0x0
  pushl $125
  10224f:	6a 7d                	push   $0x7d
  jmp __alltraps
  102251:	e9 12 06 00 00       	jmp    102868 <__alltraps>

00102256 <vector126>:
.globl vector126
vector126:
  pushl $0
  102256:	6a 00                	push   $0x0
  pushl $126
  102258:	6a 7e                	push   $0x7e
  jmp __alltraps
  10225a:	e9 09 06 00 00       	jmp    102868 <__alltraps>

0010225f <vector127>:
.globl vector127
vector127:
  pushl $0
  10225f:	6a 00                	push   $0x0
  pushl $127
  102261:	6a 7f                	push   $0x7f
  jmp __alltraps
  102263:	e9 00 06 00 00       	jmp    102868 <__alltraps>

00102268 <vector128>:
.globl vector128
vector128:
  pushl $0
  102268:	6a 00                	push   $0x0
  pushl $128
  10226a:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  10226f:	e9 f4 05 00 00       	jmp    102868 <__alltraps>

00102274 <vector129>:
.globl vector129
vector129:
  pushl $0
  102274:	6a 00                	push   $0x0
  pushl $129
  102276:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  10227b:	e9 e8 05 00 00       	jmp    102868 <__alltraps>

00102280 <vector130>:
.globl vector130
vector130:
  pushl $0
  102280:	6a 00                	push   $0x0
  pushl $130
  102282:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  102287:	e9 dc 05 00 00       	jmp    102868 <__alltraps>

0010228c <vector131>:
.globl vector131
vector131:
  pushl $0
  10228c:	6a 00                	push   $0x0
  pushl $131
  10228e:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  102293:	e9 d0 05 00 00       	jmp    102868 <__alltraps>

00102298 <vector132>:
.globl vector132
vector132:
  pushl $0
  102298:	6a 00                	push   $0x0
  pushl $132
  10229a:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  10229f:	e9 c4 05 00 00       	jmp    102868 <__alltraps>

001022a4 <vector133>:
.globl vector133
vector133:
  pushl $0
  1022a4:	6a 00                	push   $0x0
  pushl $133
  1022a6:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  1022ab:	e9 b8 05 00 00       	jmp    102868 <__alltraps>

001022b0 <vector134>:
.globl vector134
vector134:
  pushl $0
  1022b0:	6a 00                	push   $0x0
  pushl $134
  1022b2:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  1022b7:	e9 ac 05 00 00       	jmp    102868 <__alltraps>

001022bc <vector135>:
.globl vector135
vector135:
  pushl $0
  1022bc:	6a 00                	push   $0x0
  pushl $135
  1022be:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  1022c3:	e9 a0 05 00 00       	jmp    102868 <__alltraps>

001022c8 <vector136>:
.globl vector136
vector136:
  pushl $0
  1022c8:	6a 00                	push   $0x0
  pushl $136
  1022ca:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  1022cf:	e9 94 05 00 00       	jmp    102868 <__alltraps>

001022d4 <vector137>:
.globl vector137
vector137:
  pushl $0
  1022d4:	6a 00                	push   $0x0
  pushl $137
  1022d6:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  1022db:	e9 88 05 00 00       	jmp    102868 <__alltraps>

001022e0 <vector138>:
.globl vector138
vector138:
  pushl $0
  1022e0:	6a 00                	push   $0x0
  pushl $138
  1022e2:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  1022e7:	e9 7c 05 00 00       	jmp    102868 <__alltraps>

001022ec <vector139>:
.globl vector139
vector139:
  pushl $0
  1022ec:	6a 00                	push   $0x0
  pushl $139
  1022ee:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  1022f3:	e9 70 05 00 00       	jmp    102868 <__alltraps>

001022f8 <vector140>:
.globl vector140
vector140:
  pushl $0
  1022f8:	6a 00                	push   $0x0
  pushl $140
  1022fa:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  1022ff:	e9 64 05 00 00       	jmp    102868 <__alltraps>

00102304 <vector141>:
.globl vector141
vector141:
  pushl $0
  102304:	6a 00                	push   $0x0
  pushl $141
  102306:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  10230b:	e9 58 05 00 00       	jmp    102868 <__alltraps>

00102310 <vector142>:
.globl vector142
vector142:
  pushl $0
  102310:	6a 00                	push   $0x0
  pushl $142
  102312:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  102317:	e9 4c 05 00 00       	jmp    102868 <__alltraps>

0010231c <vector143>:
.globl vector143
vector143:
  pushl $0
  10231c:	6a 00                	push   $0x0
  pushl $143
  10231e:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  102323:	e9 40 05 00 00       	jmp    102868 <__alltraps>

00102328 <vector144>:
.globl vector144
vector144:
  pushl $0
  102328:	6a 00                	push   $0x0
  pushl $144
  10232a:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  10232f:	e9 34 05 00 00       	jmp    102868 <__alltraps>

00102334 <vector145>:
.globl vector145
vector145:
  pushl $0
  102334:	6a 00                	push   $0x0
  pushl $145
  102336:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  10233b:	e9 28 05 00 00       	jmp    102868 <__alltraps>

00102340 <vector146>:
.globl vector146
vector146:
  pushl $0
  102340:	6a 00                	push   $0x0
  pushl $146
  102342:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  102347:	e9 1c 05 00 00       	jmp    102868 <__alltraps>

0010234c <vector147>:
.globl vector147
vector147:
  pushl $0
  10234c:	6a 00                	push   $0x0
  pushl $147
  10234e:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  102353:	e9 10 05 00 00       	jmp    102868 <__alltraps>

00102358 <vector148>:
.globl vector148
vector148:
  pushl $0
  102358:	6a 00                	push   $0x0
  pushl $148
  10235a:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  10235f:	e9 04 05 00 00       	jmp    102868 <__alltraps>

00102364 <vector149>:
.globl vector149
vector149:
  pushl $0
  102364:	6a 00                	push   $0x0
  pushl $149
  102366:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  10236b:	e9 f8 04 00 00       	jmp    102868 <__alltraps>

00102370 <vector150>:
.globl vector150
vector150:
  pushl $0
  102370:	6a 00                	push   $0x0
  pushl $150
  102372:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  102377:	e9 ec 04 00 00       	jmp    102868 <__alltraps>

0010237c <vector151>:
.globl vector151
vector151:
  pushl $0
  10237c:	6a 00                	push   $0x0
  pushl $151
  10237e:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  102383:	e9 e0 04 00 00       	jmp    102868 <__alltraps>

00102388 <vector152>:
.globl vector152
vector152:
  pushl $0
  102388:	6a 00                	push   $0x0
  pushl $152
  10238a:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  10238f:	e9 d4 04 00 00       	jmp    102868 <__alltraps>

00102394 <vector153>:
.globl vector153
vector153:
  pushl $0
  102394:	6a 00                	push   $0x0
  pushl $153
  102396:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  10239b:	e9 c8 04 00 00       	jmp    102868 <__alltraps>

001023a0 <vector154>:
.globl vector154
vector154:
  pushl $0
  1023a0:	6a 00                	push   $0x0
  pushl $154
  1023a2:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  1023a7:	e9 bc 04 00 00       	jmp    102868 <__alltraps>

001023ac <vector155>:
.globl vector155
vector155:
  pushl $0
  1023ac:	6a 00                	push   $0x0
  pushl $155
  1023ae:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  1023b3:	e9 b0 04 00 00       	jmp    102868 <__alltraps>

001023b8 <vector156>:
.globl vector156
vector156:
  pushl $0
  1023b8:	6a 00                	push   $0x0
  pushl $156
  1023ba:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  1023bf:	e9 a4 04 00 00       	jmp    102868 <__alltraps>

001023c4 <vector157>:
.globl vector157
vector157:
  pushl $0
  1023c4:	6a 00                	push   $0x0
  pushl $157
  1023c6:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  1023cb:	e9 98 04 00 00       	jmp    102868 <__alltraps>

001023d0 <vector158>:
.globl vector158
vector158:
  pushl $0
  1023d0:	6a 00                	push   $0x0
  pushl $158
  1023d2:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  1023d7:	e9 8c 04 00 00       	jmp    102868 <__alltraps>

001023dc <vector159>:
.globl vector159
vector159:
  pushl $0
  1023dc:	6a 00                	push   $0x0
  pushl $159
  1023de:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  1023e3:	e9 80 04 00 00       	jmp    102868 <__alltraps>

001023e8 <vector160>:
.globl vector160
vector160:
  pushl $0
  1023e8:	6a 00                	push   $0x0
  pushl $160
  1023ea:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  1023ef:	e9 74 04 00 00       	jmp    102868 <__alltraps>

001023f4 <vector161>:
.globl vector161
vector161:
  pushl $0
  1023f4:	6a 00                	push   $0x0
  pushl $161
  1023f6:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  1023fb:	e9 68 04 00 00       	jmp    102868 <__alltraps>

00102400 <vector162>:
.globl vector162
vector162:
  pushl $0
  102400:	6a 00                	push   $0x0
  pushl $162
  102402:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  102407:	e9 5c 04 00 00       	jmp    102868 <__alltraps>

0010240c <vector163>:
.globl vector163
vector163:
  pushl $0
  10240c:	6a 00                	push   $0x0
  pushl $163
  10240e:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  102413:	e9 50 04 00 00       	jmp    102868 <__alltraps>

00102418 <vector164>:
.globl vector164
vector164:
  pushl $0
  102418:	6a 00                	push   $0x0
  pushl $164
  10241a:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  10241f:	e9 44 04 00 00       	jmp    102868 <__alltraps>

00102424 <vector165>:
.globl vector165
vector165:
  pushl $0
  102424:	6a 00                	push   $0x0
  pushl $165
  102426:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  10242b:	e9 38 04 00 00       	jmp    102868 <__alltraps>

00102430 <vector166>:
.globl vector166
vector166:
  pushl $0
  102430:	6a 00                	push   $0x0
  pushl $166
  102432:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  102437:	e9 2c 04 00 00       	jmp    102868 <__alltraps>

0010243c <vector167>:
.globl vector167
vector167:
  pushl $0
  10243c:	6a 00                	push   $0x0
  pushl $167
  10243e:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  102443:	e9 20 04 00 00       	jmp    102868 <__alltraps>

00102448 <vector168>:
.globl vector168
vector168:
  pushl $0
  102448:	6a 00                	push   $0x0
  pushl $168
  10244a:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  10244f:	e9 14 04 00 00       	jmp    102868 <__alltraps>

00102454 <vector169>:
.globl vector169
vector169:
  pushl $0
  102454:	6a 00                	push   $0x0
  pushl $169
  102456:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  10245b:	e9 08 04 00 00       	jmp    102868 <__alltraps>

00102460 <vector170>:
.globl vector170
vector170:
  pushl $0
  102460:	6a 00                	push   $0x0
  pushl $170
  102462:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  102467:	e9 fc 03 00 00       	jmp    102868 <__alltraps>

0010246c <vector171>:
.globl vector171
vector171:
  pushl $0
  10246c:	6a 00                	push   $0x0
  pushl $171
  10246e:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  102473:	e9 f0 03 00 00       	jmp    102868 <__alltraps>

00102478 <vector172>:
.globl vector172
vector172:
  pushl $0
  102478:	6a 00                	push   $0x0
  pushl $172
  10247a:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  10247f:	e9 e4 03 00 00       	jmp    102868 <__alltraps>

00102484 <vector173>:
.globl vector173
vector173:
  pushl $0
  102484:	6a 00                	push   $0x0
  pushl $173
  102486:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  10248b:	e9 d8 03 00 00       	jmp    102868 <__alltraps>

00102490 <vector174>:
.globl vector174
vector174:
  pushl $0
  102490:	6a 00                	push   $0x0
  pushl $174
  102492:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  102497:	e9 cc 03 00 00       	jmp    102868 <__alltraps>

0010249c <vector175>:
.globl vector175
vector175:
  pushl $0
  10249c:	6a 00                	push   $0x0
  pushl $175
  10249e:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  1024a3:	e9 c0 03 00 00       	jmp    102868 <__alltraps>

001024a8 <vector176>:
.globl vector176
vector176:
  pushl $0
  1024a8:	6a 00                	push   $0x0
  pushl $176
  1024aa:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  1024af:	e9 b4 03 00 00       	jmp    102868 <__alltraps>

001024b4 <vector177>:
.globl vector177
vector177:
  pushl $0
  1024b4:	6a 00                	push   $0x0
  pushl $177
  1024b6:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  1024bb:	e9 a8 03 00 00       	jmp    102868 <__alltraps>

001024c0 <vector178>:
.globl vector178
vector178:
  pushl $0
  1024c0:	6a 00                	push   $0x0
  pushl $178
  1024c2:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  1024c7:	e9 9c 03 00 00       	jmp    102868 <__alltraps>

001024cc <vector179>:
.globl vector179
vector179:
  pushl $0
  1024cc:	6a 00                	push   $0x0
  pushl $179
  1024ce:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  1024d3:	e9 90 03 00 00       	jmp    102868 <__alltraps>

001024d8 <vector180>:
.globl vector180
vector180:
  pushl $0
  1024d8:	6a 00                	push   $0x0
  pushl $180
  1024da:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  1024df:	e9 84 03 00 00       	jmp    102868 <__alltraps>

001024e4 <vector181>:
.globl vector181
vector181:
  pushl $0
  1024e4:	6a 00                	push   $0x0
  pushl $181
  1024e6:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  1024eb:	e9 78 03 00 00       	jmp    102868 <__alltraps>

001024f0 <vector182>:
.globl vector182
vector182:
  pushl $0
  1024f0:	6a 00                	push   $0x0
  pushl $182
  1024f2:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  1024f7:	e9 6c 03 00 00       	jmp    102868 <__alltraps>

001024fc <vector183>:
.globl vector183
vector183:
  pushl $0
  1024fc:	6a 00                	push   $0x0
  pushl $183
  1024fe:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  102503:	e9 60 03 00 00       	jmp    102868 <__alltraps>

00102508 <vector184>:
.globl vector184
vector184:
  pushl $0
  102508:	6a 00                	push   $0x0
  pushl $184
  10250a:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  10250f:	e9 54 03 00 00       	jmp    102868 <__alltraps>

00102514 <vector185>:
.globl vector185
vector185:
  pushl $0
  102514:	6a 00                	push   $0x0
  pushl $185
  102516:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  10251b:	e9 48 03 00 00       	jmp    102868 <__alltraps>

00102520 <vector186>:
.globl vector186
vector186:
  pushl $0
  102520:	6a 00                	push   $0x0
  pushl $186
  102522:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  102527:	e9 3c 03 00 00       	jmp    102868 <__alltraps>

0010252c <vector187>:
.globl vector187
vector187:
  pushl $0
  10252c:	6a 00                	push   $0x0
  pushl $187
  10252e:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  102533:	e9 30 03 00 00       	jmp    102868 <__alltraps>

00102538 <vector188>:
.globl vector188
vector188:
  pushl $0
  102538:	6a 00                	push   $0x0
  pushl $188
  10253a:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  10253f:	e9 24 03 00 00       	jmp    102868 <__alltraps>

00102544 <vector189>:
.globl vector189
vector189:
  pushl $0
  102544:	6a 00                	push   $0x0
  pushl $189
  102546:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  10254b:	e9 18 03 00 00       	jmp    102868 <__alltraps>

00102550 <vector190>:
.globl vector190
vector190:
  pushl $0
  102550:	6a 00                	push   $0x0
  pushl $190
  102552:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  102557:	e9 0c 03 00 00       	jmp    102868 <__alltraps>

0010255c <vector191>:
.globl vector191
vector191:
  pushl $0
  10255c:	6a 00                	push   $0x0
  pushl $191
  10255e:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  102563:	e9 00 03 00 00       	jmp    102868 <__alltraps>

00102568 <vector192>:
.globl vector192
vector192:
  pushl $0
  102568:	6a 00                	push   $0x0
  pushl $192
  10256a:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  10256f:	e9 f4 02 00 00       	jmp    102868 <__alltraps>

00102574 <vector193>:
.globl vector193
vector193:
  pushl $0
  102574:	6a 00                	push   $0x0
  pushl $193
  102576:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  10257b:	e9 e8 02 00 00       	jmp    102868 <__alltraps>

00102580 <vector194>:
.globl vector194
vector194:
  pushl $0
  102580:	6a 00                	push   $0x0
  pushl $194
  102582:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  102587:	e9 dc 02 00 00       	jmp    102868 <__alltraps>

0010258c <vector195>:
.globl vector195
vector195:
  pushl $0
  10258c:	6a 00                	push   $0x0
  pushl $195
  10258e:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  102593:	e9 d0 02 00 00       	jmp    102868 <__alltraps>

00102598 <vector196>:
.globl vector196
vector196:
  pushl $0
  102598:	6a 00                	push   $0x0
  pushl $196
  10259a:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  10259f:	e9 c4 02 00 00       	jmp    102868 <__alltraps>

001025a4 <vector197>:
.globl vector197
vector197:
  pushl $0
  1025a4:	6a 00                	push   $0x0
  pushl $197
  1025a6:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  1025ab:	e9 b8 02 00 00       	jmp    102868 <__alltraps>

001025b0 <vector198>:
.globl vector198
vector198:
  pushl $0
  1025b0:	6a 00                	push   $0x0
  pushl $198
  1025b2:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  1025b7:	e9 ac 02 00 00       	jmp    102868 <__alltraps>

001025bc <vector199>:
.globl vector199
vector199:
  pushl $0
  1025bc:	6a 00                	push   $0x0
  pushl $199
  1025be:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  1025c3:	e9 a0 02 00 00       	jmp    102868 <__alltraps>

001025c8 <vector200>:
.globl vector200
vector200:
  pushl $0
  1025c8:	6a 00                	push   $0x0
  pushl $200
  1025ca:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  1025cf:	e9 94 02 00 00       	jmp    102868 <__alltraps>

001025d4 <vector201>:
.globl vector201
vector201:
  pushl $0
  1025d4:	6a 00                	push   $0x0
  pushl $201
  1025d6:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  1025db:	e9 88 02 00 00       	jmp    102868 <__alltraps>

001025e0 <vector202>:
.globl vector202
vector202:
  pushl $0
  1025e0:	6a 00                	push   $0x0
  pushl $202
  1025e2:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  1025e7:	e9 7c 02 00 00       	jmp    102868 <__alltraps>

001025ec <vector203>:
.globl vector203
vector203:
  pushl $0
  1025ec:	6a 00                	push   $0x0
  pushl $203
  1025ee:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  1025f3:	e9 70 02 00 00       	jmp    102868 <__alltraps>

001025f8 <vector204>:
.globl vector204
vector204:
  pushl $0
  1025f8:	6a 00                	push   $0x0
  pushl $204
  1025fa:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  1025ff:	e9 64 02 00 00       	jmp    102868 <__alltraps>

00102604 <vector205>:
.globl vector205
vector205:
  pushl $0
  102604:	6a 00                	push   $0x0
  pushl $205
  102606:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  10260b:	e9 58 02 00 00       	jmp    102868 <__alltraps>

00102610 <vector206>:
.globl vector206
vector206:
  pushl $0
  102610:	6a 00                	push   $0x0
  pushl $206
  102612:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  102617:	e9 4c 02 00 00       	jmp    102868 <__alltraps>

0010261c <vector207>:
.globl vector207
vector207:
  pushl $0
  10261c:	6a 00                	push   $0x0
  pushl $207
  10261e:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  102623:	e9 40 02 00 00       	jmp    102868 <__alltraps>

00102628 <vector208>:
.globl vector208
vector208:
  pushl $0
  102628:	6a 00                	push   $0x0
  pushl $208
  10262a:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  10262f:	e9 34 02 00 00       	jmp    102868 <__alltraps>

00102634 <vector209>:
.globl vector209
vector209:
  pushl $0
  102634:	6a 00                	push   $0x0
  pushl $209
  102636:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  10263b:	e9 28 02 00 00       	jmp    102868 <__alltraps>

00102640 <vector210>:
.globl vector210
vector210:
  pushl $0
  102640:	6a 00                	push   $0x0
  pushl $210
  102642:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  102647:	e9 1c 02 00 00       	jmp    102868 <__alltraps>

0010264c <vector211>:
.globl vector211
vector211:
  pushl $0
  10264c:	6a 00                	push   $0x0
  pushl $211
  10264e:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  102653:	e9 10 02 00 00       	jmp    102868 <__alltraps>

00102658 <vector212>:
.globl vector212
vector212:
  pushl $0
  102658:	6a 00                	push   $0x0
  pushl $212
  10265a:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  10265f:	e9 04 02 00 00       	jmp    102868 <__alltraps>

00102664 <vector213>:
.globl vector213
vector213:
  pushl $0
  102664:	6a 00                	push   $0x0
  pushl $213
  102666:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  10266b:	e9 f8 01 00 00       	jmp    102868 <__alltraps>

00102670 <vector214>:
.globl vector214
vector214:
  pushl $0
  102670:	6a 00                	push   $0x0
  pushl $214
  102672:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  102677:	e9 ec 01 00 00       	jmp    102868 <__alltraps>

0010267c <vector215>:
.globl vector215
vector215:
  pushl $0
  10267c:	6a 00                	push   $0x0
  pushl $215
  10267e:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  102683:	e9 e0 01 00 00       	jmp    102868 <__alltraps>

00102688 <vector216>:
.globl vector216
vector216:
  pushl $0
  102688:	6a 00                	push   $0x0
  pushl $216
  10268a:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  10268f:	e9 d4 01 00 00       	jmp    102868 <__alltraps>

00102694 <vector217>:
.globl vector217
vector217:
  pushl $0
  102694:	6a 00                	push   $0x0
  pushl $217
  102696:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  10269b:	e9 c8 01 00 00       	jmp    102868 <__alltraps>

001026a0 <vector218>:
.globl vector218
vector218:
  pushl $0
  1026a0:	6a 00                	push   $0x0
  pushl $218
  1026a2:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  1026a7:	e9 bc 01 00 00       	jmp    102868 <__alltraps>

001026ac <vector219>:
.globl vector219
vector219:
  pushl $0
  1026ac:	6a 00                	push   $0x0
  pushl $219
  1026ae:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  1026b3:	e9 b0 01 00 00       	jmp    102868 <__alltraps>

001026b8 <vector220>:
.globl vector220
vector220:
  pushl $0
  1026b8:	6a 00                	push   $0x0
  pushl $220
  1026ba:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  1026bf:	e9 a4 01 00 00       	jmp    102868 <__alltraps>

001026c4 <vector221>:
.globl vector221
vector221:
  pushl $0
  1026c4:	6a 00                	push   $0x0
  pushl $221
  1026c6:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  1026cb:	e9 98 01 00 00       	jmp    102868 <__alltraps>

001026d0 <vector222>:
.globl vector222
vector222:
  pushl $0
  1026d0:	6a 00                	push   $0x0
  pushl $222
  1026d2:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  1026d7:	e9 8c 01 00 00       	jmp    102868 <__alltraps>

001026dc <vector223>:
.globl vector223
vector223:
  pushl $0
  1026dc:	6a 00                	push   $0x0
  pushl $223
  1026de:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  1026e3:	e9 80 01 00 00       	jmp    102868 <__alltraps>

001026e8 <vector224>:
.globl vector224
vector224:
  pushl $0
  1026e8:	6a 00                	push   $0x0
  pushl $224
  1026ea:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  1026ef:	e9 74 01 00 00       	jmp    102868 <__alltraps>

001026f4 <vector225>:
.globl vector225
vector225:
  pushl $0
  1026f4:	6a 00                	push   $0x0
  pushl $225
  1026f6:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  1026fb:	e9 68 01 00 00       	jmp    102868 <__alltraps>

00102700 <vector226>:
.globl vector226
vector226:
  pushl $0
  102700:	6a 00                	push   $0x0
  pushl $226
  102702:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  102707:	e9 5c 01 00 00       	jmp    102868 <__alltraps>

0010270c <vector227>:
.globl vector227
vector227:
  pushl $0
  10270c:	6a 00                	push   $0x0
  pushl $227
  10270e:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  102713:	e9 50 01 00 00       	jmp    102868 <__alltraps>

00102718 <vector228>:
.globl vector228
vector228:
  pushl $0
  102718:	6a 00                	push   $0x0
  pushl $228
  10271a:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  10271f:	e9 44 01 00 00       	jmp    102868 <__alltraps>

00102724 <vector229>:
.globl vector229
vector229:
  pushl $0
  102724:	6a 00                	push   $0x0
  pushl $229
  102726:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  10272b:	e9 38 01 00 00       	jmp    102868 <__alltraps>

00102730 <vector230>:
.globl vector230
vector230:
  pushl $0
  102730:	6a 00                	push   $0x0
  pushl $230
  102732:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  102737:	e9 2c 01 00 00       	jmp    102868 <__alltraps>

0010273c <vector231>:
.globl vector231
vector231:
  pushl $0
  10273c:	6a 00                	push   $0x0
  pushl $231
  10273e:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  102743:	e9 20 01 00 00       	jmp    102868 <__alltraps>

00102748 <vector232>:
.globl vector232
vector232:
  pushl $0
  102748:	6a 00                	push   $0x0
  pushl $232
  10274a:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  10274f:	e9 14 01 00 00       	jmp    102868 <__alltraps>

00102754 <vector233>:
.globl vector233
vector233:
  pushl $0
  102754:	6a 00                	push   $0x0
  pushl $233
  102756:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  10275b:	e9 08 01 00 00       	jmp    102868 <__alltraps>

00102760 <vector234>:
.globl vector234
vector234:
  pushl $0
  102760:	6a 00                	push   $0x0
  pushl $234
  102762:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  102767:	e9 fc 00 00 00       	jmp    102868 <__alltraps>

0010276c <vector235>:
.globl vector235
vector235:
  pushl $0
  10276c:	6a 00                	push   $0x0
  pushl $235
  10276e:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  102773:	e9 f0 00 00 00       	jmp    102868 <__alltraps>

00102778 <vector236>:
.globl vector236
vector236:
  pushl $0
  102778:	6a 00                	push   $0x0
  pushl $236
  10277a:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  10277f:	e9 e4 00 00 00       	jmp    102868 <__alltraps>

00102784 <vector237>:
.globl vector237
vector237:
  pushl $0
  102784:	6a 00                	push   $0x0
  pushl $237
  102786:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  10278b:	e9 d8 00 00 00       	jmp    102868 <__alltraps>

00102790 <vector238>:
.globl vector238
vector238:
  pushl $0
  102790:	6a 00                	push   $0x0
  pushl $238
  102792:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  102797:	e9 cc 00 00 00       	jmp    102868 <__alltraps>

0010279c <vector239>:
.globl vector239
vector239:
  pushl $0
  10279c:	6a 00                	push   $0x0
  pushl $239
  10279e:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  1027a3:	e9 c0 00 00 00       	jmp    102868 <__alltraps>

001027a8 <vector240>:
.globl vector240
vector240:
  pushl $0
  1027a8:	6a 00                	push   $0x0
  pushl $240
  1027aa:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  1027af:	e9 b4 00 00 00       	jmp    102868 <__alltraps>

001027b4 <vector241>:
.globl vector241
vector241:
  pushl $0
  1027b4:	6a 00                	push   $0x0
  pushl $241
  1027b6:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  1027bb:	e9 a8 00 00 00       	jmp    102868 <__alltraps>

001027c0 <vector242>:
.globl vector242
vector242:
  pushl $0
  1027c0:	6a 00                	push   $0x0
  pushl $242
  1027c2:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  1027c7:	e9 9c 00 00 00       	jmp    102868 <__alltraps>

001027cc <vector243>:
.globl vector243
vector243:
  pushl $0
  1027cc:	6a 00                	push   $0x0
  pushl $243
  1027ce:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  1027d3:	e9 90 00 00 00       	jmp    102868 <__alltraps>

001027d8 <vector244>:
.globl vector244
vector244:
  pushl $0
  1027d8:	6a 00                	push   $0x0
  pushl $244
  1027da:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  1027df:	e9 84 00 00 00       	jmp    102868 <__alltraps>

001027e4 <vector245>:
.globl vector245
vector245:
  pushl $0
  1027e4:	6a 00                	push   $0x0
  pushl $245
  1027e6:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  1027eb:	e9 78 00 00 00       	jmp    102868 <__alltraps>

001027f0 <vector246>:
.globl vector246
vector246:
  pushl $0
  1027f0:	6a 00                	push   $0x0
  pushl $246
  1027f2:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  1027f7:	e9 6c 00 00 00       	jmp    102868 <__alltraps>

001027fc <vector247>:
.globl vector247
vector247:
  pushl $0
  1027fc:	6a 00                	push   $0x0
  pushl $247
  1027fe:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102803:	e9 60 00 00 00       	jmp    102868 <__alltraps>

00102808 <vector248>:
.globl vector248
vector248:
  pushl $0
  102808:	6a 00                	push   $0x0
  pushl $248
  10280a:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  10280f:	e9 54 00 00 00       	jmp    102868 <__alltraps>

00102814 <vector249>:
.globl vector249
vector249:
  pushl $0
  102814:	6a 00                	push   $0x0
  pushl $249
  102816:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  10281b:	e9 48 00 00 00       	jmp    102868 <__alltraps>

00102820 <vector250>:
.globl vector250
vector250:
  pushl $0
  102820:	6a 00                	push   $0x0
  pushl $250
  102822:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  102827:	e9 3c 00 00 00       	jmp    102868 <__alltraps>

0010282c <vector251>:
.globl vector251
vector251:
  pushl $0
  10282c:	6a 00                	push   $0x0
  pushl $251
  10282e:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  102833:	e9 30 00 00 00       	jmp    102868 <__alltraps>

00102838 <vector252>:
.globl vector252
vector252:
  pushl $0
  102838:	6a 00                	push   $0x0
  pushl $252
  10283a:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  10283f:	e9 24 00 00 00       	jmp    102868 <__alltraps>

00102844 <vector253>:
.globl vector253
vector253:
  pushl $0
  102844:	6a 00                	push   $0x0
  pushl $253
  102846:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  10284b:	e9 18 00 00 00       	jmp    102868 <__alltraps>

00102850 <vector254>:
.globl vector254
vector254:
  pushl $0
  102850:	6a 00                	push   $0x0
  pushl $254
  102852:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  102857:	e9 0c 00 00 00       	jmp    102868 <__alltraps>

0010285c <vector255>:
.globl vector255
vector255:
  pushl $0
  10285c:	6a 00                	push   $0x0
  pushl $255
  10285e:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102863:	e9 00 00 00 00       	jmp    102868 <__alltraps>

00102868 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  102868:	1e                   	push   %ds
    pushl %es
  102869:	06                   	push   %es
    pushl %fs
  10286a:	0f a0                	push   %fs
    pushl %gs
  10286c:	0f a8                	push   %gs
    pushal
  10286e:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  10286f:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  102874:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  102876:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  102878:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  102879:	e8 63 f5 ff ff       	call   101de1 <trap>

    # pop the pushed stack pointer
    popl %esp
  10287e:	5c                   	pop    %esp

0010287f <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  10287f:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  102880:	0f a9                	pop    %gs
    popl %fs
  102882:	0f a1                	pop    %fs
    popl %es
  102884:	07                   	pop    %es
    popl %ds
  102885:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  102886:	83 c4 08             	add    $0x8,%esp
    iret
  102889:	cf                   	iret   

0010288a <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  10288a:	55                   	push   %ebp
  10288b:	89 e5                	mov    %esp,%ebp
    return page - pages;
  10288d:	8b 45 08             	mov    0x8(%ebp),%eax
  102890:	8b 15 58 89 11 00    	mov    0x118958,%edx
  102896:	29 d0                	sub    %edx,%eax
  102898:	c1 f8 02             	sar    $0x2,%eax
  10289b:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  1028a1:	5d                   	pop    %ebp
  1028a2:	c3                   	ret    

001028a3 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  1028a3:	55                   	push   %ebp
  1028a4:	89 e5                	mov    %esp,%ebp
    return page2ppn(page) << PGSHIFT;
  1028a6:	ff 75 08             	pushl  0x8(%ebp)
  1028a9:	e8 dc ff ff ff       	call   10288a <page2ppn>
  1028ae:	83 c4 04             	add    $0x4,%esp
  1028b1:	c1 e0 0c             	shl    $0xc,%eax
}
  1028b4:	c9                   	leave  
  1028b5:	c3                   	ret    

001028b6 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
  1028b6:	55                   	push   %ebp
  1028b7:	89 e5                	mov    %esp,%ebp
  1028b9:	83 ec 08             	sub    $0x8,%esp
    if (PPN(pa) >= npage) {
  1028bc:	8b 45 08             	mov    0x8(%ebp),%eax
  1028bf:	c1 e8 0c             	shr    $0xc,%eax
  1028c2:	89 c2                	mov    %eax,%edx
  1028c4:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  1028c9:	39 c2                	cmp    %eax,%edx
  1028cb:	72 14                	jb     1028e1 <pa2page+0x2b>
        panic("pa2page called with invalid pa");
  1028cd:	83 ec 04             	sub    $0x4,%esp
  1028d0:	68 70 61 10 00       	push   $0x106170
  1028d5:	6a 5a                	push   $0x5a
  1028d7:	68 8f 61 10 00       	push   $0x10618f
  1028dc:	e8 ec da ff ff       	call   1003cd <__panic>
    }
    return &pages[PPN(pa)];
  1028e1:	8b 0d 58 89 11 00    	mov    0x118958,%ecx
  1028e7:	8b 45 08             	mov    0x8(%ebp),%eax
  1028ea:	c1 e8 0c             	shr    $0xc,%eax
  1028ed:	89 c2                	mov    %eax,%edx
  1028ef:	89 d0                	mov    %edx,%eax
  1028f1:	c1 e0 02             	shl    $0x2,%eax
  1028f4:	01 d0                	add    %edx,%eax
  1028f6:	c1 e0 02             	shl    $0x2,%eax
  1028f9:	01 c8                	add    %ecx,%eax
}
  1028fb:	c9                   	leave  
  1028fc:	c3                   	ret    

001028fd <page2kva>:

static inline void *
page2kva(struct Page *page) {
  1028fd:	55                   	push   %ebp
  1028fe:	89 e5                	mov    %esp,%ebp
  102900:	83 ec 18             	sub    $0x18,%esp
    return KADDR(page2pa(page));
  102903:	ff 75 08             	pushl  0x8(%ebp)
  102906:	e8 98 ff ff ff       	call   1028a3 <page2pa>
  10290b:	83 c4 04             	add    $0x4,%esp
  10290e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102911:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102914:	c1 e8 0c             	shr    $0xc,%eax
  102917:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10291a:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  10291f:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  102922:	72 14                	jb     102938 <page2kva+0x3b>
  102924:	ff 75 f4             	pushl  -0xc(%ebp)
  102927:	68 a0 61 10 00       	push   $0x1061a0
  10292c:	6a 61                	push   $0x61
  10292e:	68 8f 61 10 00       	push   $0x10618f
  102933:	e8 95 da ff ff       	call   1003cd <__panic>
  102938:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10293b:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  102940:	c9                   	leave  
  102941:	c3                   	ret    

00102942 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
  102942:	55                   	push   %ebp
  102943:	89 e5                	mov    %esp,%ebp
  102945:	83 ec 08             	sub    $0x8,%esp
    if (!(pte & PTE_P)) {
  102948:	8b 45 08             	mov    0x8(%ebp),%eax
  10294b:	83 e0 01             	and    $0x1,%eax
  10294e:	85 c0                	test   %eax,%eax
  102950:	75 14                	jne    102966 <pte2page+0x24>
        panic("pte2page called with invalid pte");
  102952:	83 ec 04             	sub    $0x4,%esp
  102955:	68 c4 61 10 00       	push   $0x1061c4
  10295a:	6a 6c                	push   $0x6c
  10295c:	68 8f 61 10 00       	push   $0x10618f
  102961:	e8 67 da ff ff       	call   1003cd <__panic>
    }
    return pa2page(PTE_ADDR(pte));
  102966:	8b 45 08             	mov    0x8(%ebp),%eax
  102969:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10296e:	83 ec 0c             	sub    $0xc,%esp
  102971:	50                   	push   %eax
  102972:	e8 3f ff ff ff       	call   1028b6 <pa2page>
  102977:	83 c4 10             	add    $0x10,%esp
}
  10297a:	c9                   	leave  
  10297b:	c3                   	ret    

0010297c <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
  10297c:	55                   	push   %ebp
  10297d:	89 e5                	mov    %esp,%ebp
  10297f:	83 ec 08             	sub    $0x8,%esp
    return pa2page(PDE_ADDR(pde));
  102982:	8b 45 08             	mov    0x8(%ebp),%eax
  102985:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10298a:	83 ec 0c             	sub    $0xc,%esp
  10298d:	50                   	push   %eax
  10298e:	e8 23 ff ff ff       	call   1028b6 <pa2page>
  102993:	83 c4 10             	add    $0x10,%esp
}
  102996:	c9                   	leave  
  102997:	c3                   	ret    

00102998 <page_ref>:

static inline int
page_ref(struct Page *page) {
  102998:	55                   	push   %ebp
  102999:	89 e5                	mov    %esp,%ebp
    return page->ref;
  10299b:	8b 45 08             	mov    0x8(%ebp),%eax
  10299e:	8b 00                	mov    (%eax),%eax
}
  1029a0:	5d                   	pop    %ebp
  1029a1:	c3                   	ret    

001029a2 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  1029a2:	55                   	push   %ebp
  1029a3:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  1029a5:	8b 45 08             	mov    0x8(%ebp),%eax
  1029a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  1029ab:	89 10                	mov    %edx,(%eax)
}
  1029ad:	90                   	nop
  1029ae:	5d                   	pop    %ebp
  1029af:	c3                   	ret    

001029b0 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
  1029b0:	55                   	push   %ebp
  1029b1:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
  1029b3:	8b 45 08             	mov    0x8(%ebp),%eax
  1029b6:	8b 00                	mov    (%eax),%eax
  1029b8:	8d 50 01             	lea    0x1(%eax),%edx
  1029bb:	8b 45 08             	mov    0x8(%ebp),%eax
  1029be:	89 10                	mov    %edx,(%eax)
    return page->ref;
  1029c0:	8b 45 08             	mov    0x8(%ebp),%eax
  1029c3:	8b 00                	mov    (%eax),%eax
}
  1029c5:	5d                   	pop    %ebp
  1029c6:	c3                   	ret    

001029c7 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  1029c7:	55                   	push   %ebp
  1029c8:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
  1029ca:	8b 45 08             	mov    0x8(%ebp),%eax
  1029cd:	8b 00                	mov    (%eax),%eax
  1029cf:	8d 50 ff             	lea    -0x1(%eax),%edx
  1029d2:	8b 45 08             	mov    0x8(%ebp),%eax
  1029d5:	89 10                	mov    %edx,(%eax)
    return page->ref;
  1029d7:	8b 45 08             	mov    0x8(%ebp),%eax
  1029da:	8b 00                	mov    (%eax),%eax
}
  1029dc:	5d                   	pop    %ebp
  1029dd:	c3                   	ret    

001029de <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  1029de:	55                   	push   %ebp
  1029df:	89 e5                	mov    %esp,%ebp
  1029e1:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  1029e4:	9c                   	pushf  
  1029e5:	58                   	pop    %eax
  1029e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  1029e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  1029ec:	25 00 02 00 00       	and    $0x200,%eax
  1029f1:	85 c0                	test   %eax,%eax
  1029f3:	74 0c                	je     102a01 <__intr_save+0x23>
        intr_disable();
  1029f5:	e8 5a ee ff ff       	call   101854 <intr_disable>
        return 1;
  1029fa:	b8 01 00 00 00       	mov    $0x1,%eax
  1029ff:	eb 05                	jmp    102a06 <__intr_save+0x28>
    }
    return 0;
  102a01:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102a06:	c9                   	leave  
  102a07:	c3                   	ret    

00102a08 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  102a08:	55                   	push   %ebp
  102a09:	89 e5                	mov    %esp,%ebp
  102a0b:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  102a0e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102a12:	74 05                	je     102a19 <__intr_restore+0x11>
        intr_enable();
  102a14:	e8 34 ee ff ff       	call   10184d <intr_enable>
    }
}
  102a19:	90                   	nop
  102a1a:	c9                   	leave  
  102a1b:	c3                   	ret    

00102a1c <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  102a1c:	55                   	push   %ebp
  102a1d:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  102a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  102a22:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  102a25:	b8 23 00 00 00       	mov    $0x23,%eax
  102a2a:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  102a2c:	b8 23 00 00 00       	mov    $0x23,%eax
  102a31:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102a33:	b8 10 00 00 00       	mov    $0x10,%eax
  102a38:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102a3a:	b8 10 00 00 00       	mov    $0x10,%eax
  102a3f:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102a41:	b8 10 00 00 00       	mov    $0x10,%eax
  102a46:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  102a48:	ea 4f 2a 10 00 08 00 	ljmp   $0x8,$0x102a4f
}
  102a4f:	90                   	nop
  102a50:	5d                   	pop    %ebp
  102a51:	c3                   	ret    

00102a52 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
  102a52:	55                   	push   %ebp
  102a53:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
  102a55:	8b 45 08             	mov    0x8(%ebp),%eax
  102a58:	a3 e4 88 11 00       	mov    %eax,0x1188e4
}
  102a5d:	90                   	nop
  102a5e:	5d                   	pop    %ebp
  102a5f:	c3                   	ret    

00102a60 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102a60:	55                   	push   %ebp
  102a61:	89 e5                	mov    %esp,%ebp
  102a63:	83 ec 10             	sub    $0x10,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
  102a66:	b8 00 70 11 00       	mov    $0x117000,%eax
  102a6b:	50                   	push   %eax
  102a6c:	e8 e1 ff ff ff       	call   102a52 <load_esp0>
  102a71:	83 c4 04             	add    $0x4,%esp
    ts.ts_ss0 = KERNEL_DS;
  102a74:	66 c7 05 e8 88 11 00 	movw   $0x10,0x1188e8
  102a7b:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  102a7d:	66 c7 05 28 7a 11 00 	movw   $0x68,0x117a28
  102a84:	68 00 
  102a86:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  102a8b:	66 a3 2a 7a 11 00    	mov    %ax,0x117a2a
  102a91:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  102a96:	c1 e8 10             	shr    $0x10,%eax
  102a99:	a2 2c 7a 11 00       	mov    %al,0x117a2c
  102a9e:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  102aa5:	83 e0 f0             	and    $0xfffffff0,%eax
  102aa8:	83 c8 09             	or     $0x9,%eax
  102aab:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  102ab0:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  102ab7:	83 e0 ef             	and    $0xffffffef,%eax
  102aba:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  102abf:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  102ac6:	83 e0 9f             	and    $0xffffff9f,%eax
  102ac9:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  102ace:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  102ad5:	83 c8 80             	or     $0xffffff80,%eax
  102ad8:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  102add:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  102ae4:	83 e0 f0             	and    $0xfffffff0,%eax
  102ae7:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  102aec:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  102af3:	83 e0 ef             	and    $0xffffffef,%eax
  102af6:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  102afb:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  102b02:	83 e0 df             	and    $0xffffffdf,%eax
  102b05:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  102b0a:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  102b11:	83 c8 40             	or     $0x40,%eax
  102b14:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  102b19:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  102b20:	83 e0 7f             	and    $0x7f,%eax
  102b23:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  102b28:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  102b2d:	c1 e8 18             	shr    $0x18,%eax
  102b30:	a2 2f 7a 11 00       	mov    %al,0x117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
  102b35:	68 30 7a 11 00       	push   $0x117a30
  102b3a:	e8 dd fe ff ff       	call   102a1c <lgdt>
  102b3f:	83 c4 04             	add    $0x4,%esp
  102b42:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
  102b48:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102b4c:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  102b4f:	90                   	nop
  102b50:	c9                   	leave  
  102b51:	c3                   	ret    

00102b52 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
  102b52:	55                   	push   %ebp
  102b53:	89 e5                	mov    %esp,%ebp
  102b55:	83 ec 08             	sub    $0x8,%esp
    pmm_manager = &default_pmm_manager;
  102b58:	c7 05 50 89 11 00 38 	movl   $0x106b38,0x118950
  102b5f:	6b 10 00 
    cprintf("memory management: %s\n", pmm_manager->name);
  102b62:	a1 50 89 11 00       	mov    0x118950,%eax
  102b67:	8b 00                	mov    (%eax),%eax
  102b69:	83 ec 08             	sub    $0x8,%esp
  102b6c:	50                   	push   %eax
  102b6d:	68 f0 61 10 00       	push   $0x1061f0
  102b72:	e8 f0 d6 ff ff       	call   100267 <cprintf>
  102b77:	83 c4 10             	add    $0x10,%esp
    pmm_manager->init();
  102b7a:	a1 50 89 11 00       	mov    0x118950,%eax
  102b7f:	8b 40 04             	mov    0x4(%eax),%eax
  102b82:	ff d0                	call   *%eax
}
  102b84:	90                   	nop
  102b85:	c9                   	leave  
  102b86:	c3                   	ret    

00102b87 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
  102b87:	55                   	push   %ebp
  102b88:	89 e5                	mov    %esp,%ebp
  102b8a:	83 ec 08             	sub    $0x8,%esp
    pmm_manager->init_memmap(base, n);
  102b8d:	a1 50 89 11 00       	mov    0x118950,%eax
  102b92:	8b 40 08             	mov    0x8(%eax),%eax
  102b95:	83 ec 08             	sub    $0x8,%esp
  102b98:	ff 75 0c             	pushl  0xc(%ebp)
  102b9b:	ff 75 08             	pushl  0x8(%ebp)
  102b9e:	ff d0                	call   *%eax
  102ba0:	83 c4 10             	add    $0x10,%esp
}
  102ba3:	90                   	nop
  102ba4:	c9                   	leave  
  102ba5:	c3                   	ret    

00102ba6 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
  102ba6:	55                   	push   %ebp
  102ba7:	89 e5                	mov    %esp,%ebp
  102ba9:	83 ec 18             	sub    $0x18,%esp
    struct Page *page=NULL;
  102bac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  102bb3:	e8 26 fe ff ff       	call   1029de <__intr_save>
  102bb8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
  102bbb:	a1 50 89 11 00       	mov    0x118950,%eax
  102bc0:	8b 40 0c             	mov    0xc(%eax),%eax
  102bc3:	83 ec 0c             	sub    $0xc,%esp
  102bc6:	ff 75 08             	pushl  0x8(%ebp)
  102bc9:	ff d0                	call   *%eax
  102bcb:	83 c4 10             	add    $0x10,%esp
  102bce:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
  102bd1:	83 ec 0c             	sub    $0xc,%esp
  102bd4:	ff 75 f0             	pushl  -0x10(%ebp)
  102bd7:	e8 2c fe ff ff       	call   102a08 <__intr_restore>
  102bdc:	83 c4 10             	add    $0x10,%esp
    return page;
  102bdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102be2:	c9                   	leave  
  102be3:	c3                   	ret    

00102be4 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
  102be4:	55                   	push   %ebp
  102be5:	89 e5                	mov    %esp,%ebp
  102be7:	83 ec 18             	sub    $0x18,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  102bea:	e8 ef fd ff ff       	call   1029de <__intr_save>
  102bef:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
  102bf2:	a1 50 89 11 00       	mov    0x118950,%eax
  102bf7:	8b 40 10             	mov    0x10(%eax),%eax
  102bfa:	83 ec 08             	sub    $0x8,%esp
  102bfd:	ff 75 0c             	pushl  0xc(%ebp)
  102c00:	ff 75 08             	pushl  0x8(%ebp)
  102c03:	ff d0                	call   *%eax
  102c05:	83 c4 10             	add    $0x10,%esp
    }
    local_intr_restore(intr_flag);
  102c08:	83 ec 0c             	sub    $0xc,%esp
  102c0b:	ff 75 f4             	pushl  -0xc(%ebp)
  102c0e:	e8 f5 fd ff ff       	call   102a08 <__intr_restore>
  102c13:	83 c4 10             	add    $0x10,%esp
}
  102c16:	90                   	nop
  102c17:	c9                   	leave  
  102c18:	c3                   	ret    

00102c19 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
  102c19:	55                   	push   %ebp
  102c1a:	89 e5                	mov    %esp,%ebp
  102c1c:	83 ec 18             	sub    $0x18,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
  102c1f:	e8 ba fd ff ff       	call   1029de <__intr_save>
  102c24:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
  102c27:	a1 50 89 11 00       	mov    0x118950,%eax
  102c2c:	8b 40 14             	mov    0x14(%eax),%eax
  102c2f:	ff d0                	call   *%eax
  102c31:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
  102c34:	83 ec 0c             	sub    $0xc,%esp
  102c37:	ff 75 f4             	pushl  -0xc(%ebp)
  102c3a:	e8 c9 fd ff ff       	call   102a08 <__intr_restore>
  102c3f:	83 c4 10             	add    $0x10,%esp
    return ret;
  102c42:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  102c45:	c9                   	leave  
  102c46:	c3                   	ret    

00102c47 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
  102c47:	55                   	push   %ebp
  102c48:	89 e5                	mov    %esp,%ebp
  102c4a:	57                   	push   %edi
  102c4b:	56                   	push   %esi
  102c4c:	53                   	push   %ebx
  102c4d:	83 ec 7c             	sub    $0x7c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
  102c50:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
  102c57:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  102c5e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
  102c65:	83 ec 0c             	sub    $0xc,%esp
  102c68:	68 07 62 10 00       	push   $0x106207
  102c6d:	e8 f5 d5 ff ff       	call   100267 <cprintf>
  102c72:	83 c4 10             	add    $0x10,%esp
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  102c75:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102c7c:	e9 fc 00 00 00       	jmp    102d7d <page_init+0x136>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  102c81:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102c84:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102c87:	89 d0                	mov    %edx,%eax
  102c89:	c1 e0 02             	shl    $0x2,%eax
  102c8c:	01 d0                	add    %edx,%eax
  102c8e:	c1 e0 02             	shl    $0x2,%eax
  102c91:	01 c8                	add    %ecx,%eax
  102c93:	8b 50 08             	mov    0x8(%eax),%edx
  102c96:	8b 40 04             	mov    0x4(%eax),%eax
  102c99:	89 45 b8             	mov    %eax,-0x48(%ebp)
  102c9c:	89 55 bc             	mov    %edx,-0x44(%ebp)
  102c9f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102ca2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102ca5:	89 d0                	mov    %edx,%eax
  102ca7:	c1 e0 02             	shl    $0x2,%eax
  102caa:	01 d0                	add    %edx,%eax
  102cac:	c1 e0 02             	shl    $0x2,%eax
  102caf:	01 c8                	add    %ecx,%eax
  102cb1:	8b 48 0c             	mov    0xc(%eax),%ecx
  102cb4:	8b 58 10             	mov    0x10(%eax),%ebx
  102cb7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102cba:	8b 55 bc             	mov    -0x44(%ebp),%edx
  102cbd:	01 c8                	add    %ecx,%eax
  102cbf:	11 da                	adc    %ebx,%edx
  102cc1:	89 45 b0             	mov    %eax,-0x50(%ebp)
  102cc4:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  102cc7:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102cca:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102ccd:	89 d0                	mov    %edx,%eax
  102ccf:	c1 e0 02             	shl    $0x2,%eax
  102cd2:	01 d0                	add    %edx,%eax
  102cd4:	c1 e0 02             	shl    $0x2,%eax
  102cd7:	01 c8                	add    %ecx,%eax
  102cd9:	83 c0 14             	add    $0x14,%eax
  102cdc:	8b 00                	mov    (%eax),%eax
  102cde:	89 45 84             	mov    %eax,-0x7c(%ebp)
  102ce1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  102ce4:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  102ce7:	83 c0 ff             	add    $0xffffffff,%eax
  102cea:	83 d2 ff             	adc    $0xffffffff,%edx
  102ced:	89 c1                	mov    %eax,%ecx
  102cef:	89 d3                	mov    %edx,%ebx
  102cf1:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102cf4:	89 55 80             	mov    %edx,-0x80(%ebp)
  102cf7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102cfa:	89 d0                	mov    %edx,%eax
  102cfc:	c1 e0 02             	shl    $0x2,%eax
  102cff:	01 d0                	add    %edx,%eax
  102d01:	c1 e0 02             	shl    $0x2,%eax
  102d04:	03 45 80             	add    -0x80(%ebp),%eax
  102d07:	8b 50 10             	mov    0x10(%eax),%edx
  102d0a:	8b 40 0c             	mov    0xc(%eax),%eax
  102d0d:	ff 75 84             	pushl  -0x7c(%ebp)
  102d10:	53                   	push   %ebx
  102d11:	51                   	push   %ecx
  102d12:	ff 75 bc             	pushl  -0x44(%ebp)
  102d15:	ff 75 b8             	pushl  -0x48(%ebp)
  102d18:	52                   	push   %edx
  102d19:	50                   	push   %eax
  102d1a:	68 14 62 10 00       	push   $0x106214
  102d1f:	e8 43 d5 ff ff       	call   100267 <cprintf>
  102d24:	83 c4 20             	add    $0x20,%esp
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
  102d27:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102d2a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102d2d:	89 d0                	mov    %edx,%eax
  102d2f:	c1 e0 02             	shl    $0x2,%eax
  102d32:	01 d0                	add    %edx,%eax
  102d34:	c1 e0 02             	shl    $0x2,%eax
  102d37:	01 c8                	add    %ecx,%eax
  102d39:	83 c0 14             	add    $0x14,%eax
  102d3c:	8b 00                	mov    (%eax),%eax
  102d3e:	83 f8 01             	cmp    $0x1,%eax
  102d41:	75 36                	jne    102d79 <page_init+0x132>
            if (maxpa < end && begin < KMEMSIZE) {
  102d43:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102d46:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102d49:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  102d4c:	77 2b                	ja     102d79 <page_init+0x132>
  102d4e:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  102d51:	72 05                	jb     102d58 <page_init+0x111>
  102d53:	3b 45 b0             	cmp    -0x50(%ebp),%eax
  102d56:	73 21                	jae    102d79 <page_init+0x132>
  102d58:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  102d5c:	77 1b                	ja     102d79 <page_init+0x132>
  102d5e:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  102d62:	72 09                	jb     102d6d <page_init+0x126>
  102d64:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
  102d6b:	77 0c                	ja     102d79 <page_init+0x132>
                maxpa = end;
  102d6d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  102d70:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  102d73:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102d76:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  102d79:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  102d7d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102d80:	8b 00                	mov    (%eax),%eax
  102d82:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  102d85:	0f 8f f6 fe ff ff    	jg     102c81 <page_init+0x3a>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
  102d8b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102d8f:	72 1d                	jb     102dae <page_init+0x167>
  102d91:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102d95:	77 09                	ja     102da0 <page_init+0x159>
  102d97:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
  102d9e:	76 0e                	jbe    102dae <page_init+0x167>
        maxpa = KMEMSIZE;
  102da0:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  102da7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
  102dae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102db1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102db4:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  102db8:	c1 ea 0c             	shr    $0xc,%edx
  102dbb:	a3 c0 88 11 00       	mov    %eax,0x1188c0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  102dc0:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  102dc7:	b8 68 89 11 00       	mov    $0x118968,%eax
  102dcc:	8d 50 ff             	lea    -0x1(%eax),%edx
  102dcf:	8b 45 ac             	mov    -0x54(%ebp),%eax
  102dd2:	01 d0                	add    %edx,%eax
  102dd4:	89 45 a8             	mov    %eax,-0x58(%ebp)
  102dd7:	8b 45 a8             	mov    -0x58(%ebp),%eax
  102dda:	ba 00 00 00 00       	mov    $0x0,%edx
  102ddf:	f7 75 ac             	divl   -0x54(%ebp)
  102de2:	8b 45 a8             	mov    -0x58(%ebp),%eax
  102de5:	29 d0                	sub    %edx,%eax
  102de7:	a3 58 89 11 00       	mov    %eax,0x118958

    for (i = 0; i < npage; i ++) {
  102dec:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102df3:	eb 2f                	jmp    102e24 <page_init+0x1dd>
        SetPageReserved(pages + i);
  102df5:	8b 0d 58 89 11 00    	mov    0x118958,%ecx
  102dfb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102dfe:	89 d0                	mov    %edx,%eax
  102e00:	c1 e0 02             	shl    $0x2,%eax
  102e03:	01 d0                	add    %edx,%eax
  102e05:	c1 e0 02             	shl    $0x2,%eax
  102e08:	01 c8                	add    %ecx,%eax
  102e0a:	83 c0 04             	add    $0x4,%eax
  102e0d:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
  102e14:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102e17:	8b 45 8c             	mov    -0x74(%ebp),%eax
  102e1a:	8b 55 90             	mov    -0x70(%ebp),%edx
  102e1d:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
  102e20:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  102e24:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102e27:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  102e2c:	39 c2                	cmp    %eax,%edx
  102e2e:	72 c5                	jb     102df5 <page_init+0x1ae>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
  102e30:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  102e36:	89 d0                	mov    %edx,%eax
  102e38:	c1 e0 02             	shl    $0x2,%eax
  102e3b:	01 d0                	add    %edx,%eax
  102e3d:	c1 e0 02             	shl    $0x2,%eax
  102e40:	89 c2                	mov    %eax,%edx
  102e42:	a1 58 89 11 00       	mov    0x118958,%eax
  102e47:	01 d0                	add    %edx,%eax
  102e49:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  102e4c:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
  102e53:	77 17                	ja     102e6c <page_init+0x225>
  102e55:	ff 75 a4             	pushl  -0x5c(%ebp)
  102e58:	68 44 62 10 00       	push   $0x106244
  102e5d:	68 db 00 00 00       	push   $0xdb
  102e62:	68 68 62 10 00       	push   $0x106268
  102e67:	e8 61 d5 ff ff       	call   1003cd <__panic>
  102e6c:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  102e6f:	05 00 00 00 40       	add    $0x40000000,%eax
  102e74:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
  102e77:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102e7e:	e9 69 01 00 00       	jmp    102fec <page_init+0x3a5>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  102e83:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102e86:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102e89:	89 d0                	mov    %edx,%eax
  102e8b:	c1 e0 02             	shl    $0x2,%eax
  102e8e:	01 d0                	add    %edx,%eax
  102e90:	c1 e0 02             	shl    $0x2,%eax
  102e93:	01 c8                	add    %ecx,%eax
  102e95:	8b 50 08             	mov    0x8(%eax),%edx
  102e98:	8b 40 04             	mov    0x4(%eax),%eax
  102e9b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102e9e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102ea1:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102ea4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102ea7:	89 d0                	mov    %edx,%eax
  102ea9:	c1 e0 02             	shl    $0x2,%eax
  102eac:	01 d0                	add    %edx,%eax
  102eae:	c1 e0 02             	shl    $0x2,%eax
  102eb1:	01 c8                	add    %ecx,%eax
  102eb3:	8b 48 0c             	mov    0xc(%eax),%ecx
  102eb6:	8b 58 10             	mov    0x10(%eax),%ebx
  102eb9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102ebc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102ebf:	01 c8                	add    %ecx,%eax
  102ec1:	11 da                	adc    %ebx,%edx
  102ec3:	89 45 c8             	mov    %eax,-0x38(%ebp)
  102ec6:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
  102ec9:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102ecc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102ecf:	89 d0                	mov    %edx,%eax
  102ed1:	c1 e0 02             	shl    $0x2,%eax
  102ed4:	01 d0                	add    %edx,%eax
  102ed6:	c1 e0 02             	shl    $0x2,%eax
  102ed9:	01 c8                	add    %ecx,%eax
  102edb:	83 c0 14             	add    $0x14,%eax
  102ede:	8b 00                	mov    (%eax),%eax
  102ee0:	83 f8 01             	cmp    $0x1,%eax
  102ee3:	0f 85 ff 00 00 00    	jne    102fe8 <page_init+0x3a1>
            if (begin < freemem) {
  102ee9:	8b 45 a0             	mov    -0x60(%ebp),%eax
  102eec:	ba 00 00 00 00       	mov    $0x0,%edx
  102ef1:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102ef4:	72 17                	jb     102f0d <page_init+0x2c6>
  102ef6:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102ef9:	77 05                	ja     102f00 <page_init+0x2b9>
  102efb:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  102efe:	76 0d                	jbe    102f0d <page_init+0x2c6>
                begin = freemem;
  102f00:	8b 45 a0             	mov    -0x60(%ebp),%eax
  102f03:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102f06:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
  102f0d:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  102f11:	72 1d                	jb     102f30 <page_init+0x2e9>
  102f13:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  102f17:	77 09                	ja     102f22 <page_init+0x2db>
  102f19:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
  102f20:	76 0e                	jbe    102f30 <page_init+0x2e9>
                end = KMEMSIZE;
  102f22:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
  102f29:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
  102f30:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102f33:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102f36:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  102f39:	0f 87 a9 00 00 00    	ja     102fe8 <page_init+0x3a1>
  102f3f:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  102f42:	72 09                	jb     102f4d <page_init+0x306>
  102f44:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  102f47:	0f 83 9b 00 00 00    	jae    102fe8 <page_init+0x3a1>
                begin = ROUNDUP(begin, PGSIZE);
  102f4d:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
  102f54:	8b 55 d0             	mov    -0x30(%ebp),%edx
  102f57:	8b 45 9c             	mov    -0x64(%ebp),%eax
  102f5a:	01 d0                	add    %edx,%eax
  102f5c:	83 e8 01             	sub    $0x1,%eax
  102f5f:	89 45 98             	mov    %eax,-0x68(%ebp)
  102f62:	8b 45 98             	mov    -0x68(%ebp),%eax
  102f65:	ba 00 00 00 00       	mov    $0x0,%edx
  102f6a:	f7 75 9c             	divl   -0x64(%ebp)
  102f6d:	8b 45 98             	mov    -0x68(%ebp),%eax
  102f70:	29 d0                	sub    %edx,%eax
  102f72:	ba 00 00 00 00       	mov    $0x0,%edx
  102f77:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102f7a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  102f7d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102f80:	89 45 94             	mov    %eax,-0x6c(%ebp)
  102f83:	8b 45 94             	mov    -0x6c(%ebp),%eax
  102f86:	ba 00 00 00 00       	mov    $0x0,%edx
  102f8b:	89 c3                	mov    %eax,%ebx
  102f8d:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  102f93:	89 de                	mov    %ebx,%esi
  102f95:	89 d0                	mov    %edx,%eax
  102f97:	83 e0 00             	and    $0x0,%eax
  102f9a:	89 c7                	mov    %eax,%edi
  102f9c:	89 75 c8             	mov    %esi,-0x38(%ebp)
  102f9f:	89 7d cc             	mov    %edi,-0x34(%ebp)
                if (begin < end) {
  102fa2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102fa5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102fa8:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  102fab:	77 3b                	ja     102fe8 <page_init+0x3a1>
  102fad:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  102fb0:	72 05                	jb     102fb7 <page_init+0x370>
  102fb2:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  102fb5:	73 31                	jae    102fe8 <page_init+0x3a1>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  102fb7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102fba:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102fbd:	2b 45 d0             	sub    -0x30(%ebp),%eax
  102fc0:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
  102fc3:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  102fc7:	c1 ea 0c             	shr    $0xc,%edx
  102fca:	89 c3                	mov    %eax,%ebx
  102fcc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102fcf:	83 ec 0c             	sub    $0xc,%esp
  102fd2:	50                   	push   %eax
  102fd3:	e8 de f8 ff ff       	call   1028b6 <pa2page>
  102fd8:	83 c4 10             	add    $0x10,%esp
  102fdb:	83 ec 08             	sub    $0x8,%esp
  102fde:	53                   	push   %ebx
  102fdf:	50                   	push   %eax
  102fe0:	e8 a2 fb ff ff       	call   102b87 <init_memmap>
  102fe5:	83 c4 10             	add    $0x10,%esp
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
  102fe8:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  102fec:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102fef:	8b 00                	mov    (%eax),%eax
  102ff1:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  102ff4:	0f 8f 89 fe ff ff    	jg     102e83 <page_init+0x23c>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
  102ffa:	90                   	nop
  102ffb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  102ffe:	5b                   	pop    %ebx
  102fff:	5e                   	pop    %esi
  103000:	5f                   	pop    %edi
  103001:	5d                   	pop    %ebp
  103002:	c3                   	ret    

00103003 <enable_paging>:

static void
enable_paging(void) {
  103003:	55                   	push   %ebp
  103004:	89 e5                	mov    %esp,%ebp
  103006:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
  103009:	a1 54 89 11 00       	mov    0x118954,%eax
  10300e:	89 45 fc             	mov    %eax,-0x4(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
  103011:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103014:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
  103017:	0f 20 c0             	mov    %cr0,%eax
  10301a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
  10301d:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
  103020:	89 45 f8             	mov    %eax,-0x8(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
  103023:	81 4d f8 2f 00 05 80 	orl    $0x8005002f,-0x8(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
  10302a:	83 65 f8 f3          	andl   $0xfffffff3,-0x8(%ebp)
  10302e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103031:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
  103034:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103037:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
  10303a:	90                   	nop
  10303b:	c9                   	leave  
  10303c:	c3                   	ret    

0010303d <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
  10303d:	55                   	push   %ebp
  10303e:	89 e5                	mov    %esp,%ebp
  103040:	83 ec 28             	sub    $0x28,%esp
    assert(PGOFF(la) == PGOFF(pa));
  103043:	8b 45 0c             	mov    0xc(%ebp),%eax
  103046:	33 45 14             	xor    0x14(%ebp),%eax
  103049:	25 ff 0f 00 00       	and    $0xfff,%eax
  10304e:	85 c0                	test   %eax,%eax
  103050:	74 19                	je     10306b <boot_map_segment+0x2e>
  103052:	68 76 62 10 00       	push   $0x106276
  103057:	68 8d 62 10 00       	push   $0x10628d
  10305c:	68 04 01 00 00       	push   $0x104
  103061:	68 68 62 10 00       	push   $0x106268
  103066:	e8 62 d3 ff ff       	call   1003cd <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  10306b:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  103072:	8b 45 0c             	mov    0xc(%ebp),%eax
  103075:	25 ff 0f 00 00       	and    $0xfff,%eax
  10307a:	89 c2                	mov    %eax,%edx
  10307c:	8b 45 10             	mov    0x10(%ebp),%eax
  10307f:	01 c2                	add    %eax,%edx
  103081:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103084:	01 d0                	add    %edx,%eax
  103086:	83 e8 01             	sub    $0x1,%eax
  103089:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10308c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10308f:	ba 00 00 00 00       	mov    $0x0,%edx
  103094:	f7 75 f0             	divl   -0x10(%ebp)
  103097:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10309a:	29 d0                	sub    %edx,%eax
  10309c:	c1 e8 0c             	shr    $0xc,%eax
  10309f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  1030a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030a5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1030a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1030ab:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1030b0:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  1030b3:	8b 45 14             	mov    0x14(%ebp),%eax
  1030b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1030b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1030bc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1030c1:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  1030c4:	eb 57                	jmp    10311d <boot_map_segment+0xe0>
        pte_t *ptep = get_pte(pgdir, la, 1);
  1030c6:	83 ec 04             	sub    $0x4,%esp
  1030c9:	6a 01                	push   $0x1
  1030cb:	ff 75 0c             	pushl  0xc(%ebp)
  1030ce:	ff 75 08             	pushl  0x8(%ebp)
  1030d1:	e8 98 01 00 00       	call   10326e <get_pte>
  1030d6:	83 c4 10             	add    $0x10,%esp
  1030d9:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  1030dc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  1030e0:	75 19                	jne    1030fb <boot_map_segment+0xbe>
  1030e2:	68 a2 62 10 00       	push   $0x1062a2
  1030e7:	68 8d 62 10 00       	push   $0x10628d
  1030ec:	68 0a 01 00 00       	push   $0x10a
  1030f1:	68 68 62 10 00       	push   $0x106268
  1030f6:	e8 d2 d2 ff ff       	call   1003cd <__panic>
        *ptep = pa | PTE_P | perm;
  1030fb:	8b 45 14             	mov    0x14(%ebp),%eax
  1030fe:	0b 45 18             	or     0x18(%ebp),%eax
  103101:	83 c8 01             	or     $0x1,%eax
  103104:	89 c2                	mov    %eax,%edx
  103106:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103109:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  10310b:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  10310f:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  103116:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  10311d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103121:	75 a3                	jne    1030c6 <boot_map_segment+0x89>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
  103123:	90                   	nop
  103124:	c9                   	leave  
  103125:	c3                   	ret    

00103126 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
  103126:	55                   	push   %ebp
  103127:	89 e5                	mov    %esp,%ebp
  103129:	83 ec 18             	sub    $0x18,%esp
    struct Page *p = alloc_page();
  10312c:	83 ec 0c             	sub    $0xc,%esp
  10312f:	6a 01                	push   $0x1
  103131:	e8 70 fa ff ff       	call   102ba6 <alloc_pages>
  103136:	83 c4 10             	add    $0x10,%esp
  103139:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
  10313c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103140:	75 17                	jne    103159 <boot_alloc_page+0x33>
        panic("boot_alloc_page failed.\n");
  103142:	83 ec 04             	sub    $0x4,%esp
  103145:	68 af 62 10 00       	push   $0x1062af
  10314a:	68 16 01 00 00       	push   $0x116
  10314f:	68 68 62 10 00       	push   $0x106268
  103154:	e8 74 d2 ff ff       	call   1003cd <__panic>
    }
    return page2kva(p);
  103159:	83 ec 0c             	sub    $0xc,%esp
  10315c:	ff 75 f4             	pushl  -0xc(%ebp)
  10315f:	e8 99 f7 ff ff       	call   1028fd <page2kva>
  103164:	83 c4 10             	add    $0x10,%esp
}
  103167:	c9                   	leave  
  103168:	c3                   	ret    

00103169 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
  103169:	55                   	push   %ebp
  10316a:	89 e5                	mov    %esp,%ebp
  10316c:	83 ec 18             	sub    $0x18,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  10316f:	e8 de f9 ff ff       	call   102b52 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  103174:	e8 ce fa ff ff       	call   102c47 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  103179:	e8 0a 04 00 00       	call   103588 <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
  10317e:	e8 a3 ff ff ff       	call   103126 <boot_alloc_page>
  103183:	a3 c4 88 11 00       	mov    %eax,0x1188c4
    memset(boot_pgdir, 0, PGSIZE);
  103188:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10318d:	83 ec 04             	sub    $0x4,%esp
  103190:	68 00 10 00 00       	push   $0x1000
  103195:	6a 00                	push   $0x0
  103197:	50                   	push   %eax
  103198:	e8 15 21 00 00       	call   1052b2 <memset>
  10319d:	83 c4 10             	add    $0x10,%esp
    boot_cr3 = PADDR(boot_pgdir);
  1031a0:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1031a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1031a8:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  1031af:	77 17                	ja     1031c8 <pmm_init+0x5f>
  1031b1:	ff 75 f4             	pushl  -0xc(%ebp)
  1031b4:	68 44 62 10 00       	push   $0x106244
  1031b9:	68 30 01 00 00       	push   $0x130
  1031be:	68 68 62 10 00       	push   $0x106268
  1031c3:	e8 05 d2 ff ff       	call   1003cd <__panic>
  1031c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1031cb:	05 00 00 00 40       	add    $0x40000000,%eax
  1031d0:	a3 54 89 11 00       	mov    %eax,0x118954

    check_pgdir();
  1031d5:	e8 d1 03 00 00       	call   1035ab <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  1031da:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1031df:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
  1031e5:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1031ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1031ed:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  1031f4:	77 17                	ja     10320d <pmm_init+0xa4>
  1031f6:	ff 75 f0             	pushl  -0x10(%ebp)
  1031f9:	68 44 62 10 00       	push   $0x106244
  1031fe:	68 38 01 00 00       	push   $0x138
  103203:	68 68 62 10 00       	push   $0x106268
  103208:	e8 c0 d1 ff ff       	call   1003cd <__panic>
  10320d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103210:	05 00 00 00 40       	add    $0x40000000,%eax
  103215:	83 c8 03             	or     $0x3,%eax
  103218:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  10321a:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10321f:	83 ec 0c             	sub    $0xc,%esp
  103222:	6a 02                	push   $0x2
  103224:	6a 00                	push   $0x0
  103226:	68 00 00 00 38       	push   $0x38000000
  10322b:	68 00 00 00 c0       	push   $0xc0000000
  103230:	50                   	push   %eax
  103231:	e8 07 fe ff ff       	call   10303d <boot_map_segment>
  103236:	83 c4 20             	add    $0x20,%esp

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
  103239:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10323e:	8b 15 c4 88 11 00    	mov    0x1188c4,%edx
  103244:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
  10324a:	89 10                	mov    %edx,(%eax)

    enable_paging();
  10324c:	e8 b2 fd ff ff       	call   103003 <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  103251:	e8 0a f8 ff ff       	call   102a60 <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
  103256:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10325b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  103261:	e8 ab 08 00 00       	call   103b11 <check_boot_pgdir>

    print_pgdir();
  103266:	e8 a1 0c 00 00       	call   103f0c <print_pgdir>

}
  10326b:	90                   	nop
  10326c:	c9                   	leave  
  10326d:	c3                   	ret    

0010326e <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
  10326e:	55                   	push   %ebp
  10326f:	89 e5                	mov    %esp,%ebp
  103271:	83 ec 28             	sub    $0x28,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    pde_t *pdep = &pgdir[PDX(la)];              //由PDX(la)找到pdt的index，从而得知该线性地址的二级页表的起始地址pde
  103274:	8b 45 0c             	mov    0xc(%ebp),%eax
  103277:	c1 e8 16             	shr    $0x16,%eax
  10327a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  103281:	8b 45 08             	mov    0x8(%ebp),%eax
  103284:	01 d0                	add    %edx,%eax
  103286:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(!(*pdep & PTE_P))                        //若入口不存在页表
  103289:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10328c:	8b 00                	mov    (%eax),%eax
  10328e:	83 e0 01             	and    $0x1,%eax
  103291:	85 c0                	test   %eax,%eax
  103293:	0f 85 9f 00 00 00    	jne    103338 <get_pte+0xca>
    {
            struct Page *p;                     //创建页表p
            if(!create || (p = alloc_page()) == NULL)
  103299:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10329d:	74 16                	je     1032b5 <get_pte+0x47>
  10329f:	83 ec 0c             	sub    $0xc,%esp
  1032a2:	6a 01                	push   $0x1
  1032a4:	e8 fd f8 ff ff       	call   102ba6 <alloc_pages>
  1032a9:	83 c4 10             	add    $0x10,%esp
  1032ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1032af:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1032b3:	75 0a                	jne    1032bf <get_pte+0x51>
                    return NULL;
  1032b5:	b8 00 00 00 00       	mov    $0x0,%eax
  1032ba:	e9 ca 00 00 00       	jmp    103389 <get_pte+0x11b>
            set_page_ref(p, 1);              //设置该页被引用过一次
  1032bf:	83 ec 08             	sub    $0x8,%esp
  1032c2:	6a 01                	push   $0x1
  1032c4:	ff 75 f0             	pushl  -0x10(%ebp)
  1032c7:	e8 d6 f6 ff ff       	call   1029a2 <set_page_ref>
  1032cc:	83 c4 10             	add    $0x10,%esp
            uintptr_t pa = page2pa(p);          //获得页表p的物理地址
  1032cf:	83 ec 0c             	sub    $0xc,%esp
  1032d2:	ff 75 f0             	pushl  -0x10(%ebp)
  1032d5:	e8 c9 f5 ff ff       	call   1028a3 <page2pa>
  1032da:	83 c4 10             	add    $0x10,%esp
  1032dd:	89 45 ec             	mov    %eax,-0x14(%ebp)
            memset(KADDR(pa), 0, PGSIZE);       //清空页表
  1032e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1032e3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1032e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1032e9:	c1 e8 0c             	shr    $0xc,%eax
  1032ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1032ef:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  1032f4:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  1032f7:	72 17                	jb     103310 <get_pte+0xa2>
  1032f9:	ff 75 e8             	pushl  -0x18(%ebp)
  1032fc:	68 a0 61 10 00       	push   $0x1061a0
  103301:	68 87 01 00 00       	push   $0x187
  103306:	68 68 62 10 00       	push   $0x106268
  10330b:	e8 bd d0 ff ff       	call   1003cd <__panic>
  103310:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103313:	2d 00 00 00 40       	sub    $0x40000000,%eax
  103318:	83 ec 04             	sub    $0x4,%esp
  10331b:	68 00 10 00 00       	push   $0x1000
  103320:	6a 00                	push   $0x0
  103322:	50                   	push   %eax
  103323:	e8 8a 1f 00 00       	call   1052b2 <memset>
  103328:	83 c4 10             	add    $0x10,%esp
            *pdep = pa | PTE_U | PTE_W | PTE_P;
  10332b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10332e:	83 c8 07             	or     $0x7,%eax
  103331:	89 c2                	mov    %eax,%edx
  103333:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103336:	89 10                	mov    %edx,(%eax)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];  //由PTX(la)找到页表的index,结合pde，得到页帧起始地址pte
  103338:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10333b:	8b 00                	mov    (%eax),%eax
  10333d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103342:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103345:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103348:	c1 e8 0c             	shr    $0xc,%eax
  10334b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  10334e:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  103353:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  103356:	72 17                	jb     10336f <get_pte+0x101>
  103358:	ff 75 e0             	pushl  -0x20(%ebp)
  10335b:	68 a0 61 10 00       	push   $0x1061a0
  103360:	68 8a 01 00 00       	push   $0x18a
  103365:	68 68 62 10 00       	push   $0x106268
  10336a:	e8 5e d0 ff ff       	call   1003cd <__panic>
  10336f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103372:	2d 00 00 00 40       	sub    $0x40000000,%eax
  103377:	89 c2                	mov    %eax,%edx
  103379:	8b 45 0c             	mov    0xc(%ebp),%eax
  10337c:	c1 e8 0c             	shr    $0xc,%eax
  10337f:	25 ff 03 00 00       	and    $0x3ff,%eax
  103384:	c1 e0 02             	shl    $0x2,%eax
  103387:	01 d0                	add    %edx,%eax
}
  103389:	c9                   	leave  
  10338a:	c3                   	ret    

0010338b <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
  10338b:	55                   	push   %ebp
  10338c:	89 e5                	mov    %esp,%ebp
  10338e:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  103391:	83 ec 04             	sub    $0x4,%esp
  103394:	6a 00                	push   $0x0
  103396:	ff 75 0c             	pushl  0xc(%ebp)
  103399:	ff 75 08             	pushl  0x8(%ebp)
  10339c:	e8 cd fe ff ff       	call   10326e <get_pte>
  1033a1:	83 c4 10             	add    $0x10,%esp
  1033a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
  1033a7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1033ab:	74 08                	je     1033b5 <get_page+0x2a>
        *ptep_store = ptep;
  1033ad:	8b 45 10             	mov    0x10(%ebp),%eax
  1033b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1033b3:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
  1033b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1033b9:	74 1f                	je     1033da <get_page+0x4f>
  1033bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1033be:	8b 00                	mov    (%eax),%eax
  1033c0:	83 e0 01             	and    $0x1,%eax
  1033c3:	85 c0                	test   %eax,%eax
  1033c5:	74 13                	je     1033da <get_page+0x4f>
        return pte2page(*ptep);
  1033c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1033ca:	8b 00                	mov    (%eax),%eax
  1033cc:	83 ec 0c             	sub    $0xc,%esp
  1033cf:	50                   	push   %eax
  1033d0:	e8 6d f5 ff ff       	call   102942 <pte2page>
  1033d5:	83 c4 10             	add    $0x10,%esp
  1033d8:	eb 05                	jmp    1033df <get_page+0x54>
    }
    return NULL;
  1033da:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1033df:	c9                   	leave  
  1033e0:	c3                   	ret    

001033e1 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
  1033e1:	55                   	push   %ebp
  1033e2:	89 e5                	mov    %esp,%ebp
  1033e4:	83 ec 18             	sub    $0x18,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    if(*ptep & PTE_P)
  1033e7:	8b 45 10             	mov    0x10(%ebp),%eax
  1033ea:	8b 00                	mov    (%eax),%eax
  1033ec:	83 e0 01             	and    $0x1,%eax
  1033ef:	85 c0                	test   %eax,%eax
  1033f1:	74 50                	je     103443 <page_remove_pte+0x62>
    {
            struct Page *p = pte2page(*ptep);       //找到放该ptep的页表p
  1033f3:	8b 45 10             	mov    0x10(%ebp),%eax
  1033f6:	8b 00                	mov    (%eax),%eax
  1033f8:	83 ec 0c             	sub    $0xc,%esp
  1033fb:	50                   	push   %eax
  1033fc:	e8 41 f5 ff ff       	call   102942 <pte2page>
  103401:	83 c4 10             	add    $0x10,%esp
  103404:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if(page_ref_dec(p) == 0)
  103407:	83 ec 0c             	sub    $0xc,%esp
  10340a:	ff 75 f4             	pushl  -0xc(%ebp)
  10340d:	e8 b5 f5 ff ff       	call   1029c7 <page_ref_dec>
  103412:	83 c4 10             	add    $0x10,%esp
  103415:	85 c0                	test   %eax,%eax
  103417:	75 10                	jne    103429 <page_remove_pte+0x48>
                    free_page(p);
  103419:	83 ec 08             	sub    $0x8,%esp
  10341c:	6a 01                	push   $0x1
  10341e:	ff 75 f4             	pushl  -0xc(%ebp)
  103421:	e8 be f7 ff ff       	call   102be4 <free_pages>
  103426:	83 c4 10             	add    $0x10,%esp
            *ptep = 0;                              //清空pte
  103429:	8b 45 10             	mov    0x10(%ebp),%eax
  10342c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            tlb_invalidate(pgdir, la);
  103432:	83 ec 08             	sub    $0x8,%esp
  103435:	ff 75 0c             	pushl  0xc(%ebp)
  103438:	ff 75 08             	pushl  0x8(%ebp)
  10343b:	e8 f8 00 00 00       	call   103538 <tlb_invalidate>
  103440:	83 c4 10             	add    $0x10,%esp
    }
}
  103443:	90                   	nop
  103444:	c9                   	leave  
  103445:	c3                   	ret    

00103446 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
  103446:	55                   	push   %ebp
  103447:	89 e5                	mov    %esp,%ebp
  103449:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  10344c:	83 ec 04             	sub    $0x4,%esp
  10344f:	6a 00                	push   $0x0
  103451:	ff 75 0c             	pushl  0xc(%ebp)
  103454:	ff 75 08             	pushl  0x8(%ebp)
  103457:	e8 12 fe ff ff       	call   10326e <get_pte>
  10345c:	83 c4 10             	add    $0x10,%esp
  10345f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
  103462:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103466:	74 14                	je     10347c <page_remove+0x36>
        page_remove_pte(pgdir, la, ptep);
  103468:	83 ec 04             	sub    $0x4,%esp
  10346b:	ff 75 f4             	pushl  -0xc(%ebp)
  10346e:	ff 75 0c             	pushl  0xc(%ebp)
  103471:	ff 75 08             	pushl  0x8(%ebp)
  103474:	e8 68 ff ff ff       	call   1033e1 <page_remove_pte>
  103479:	83 c4 10             	add    $0x10,%esp
    }
}
  10347c:	90                   	nop
  10347d:	c9                   	leave  
  10347e:	c3                   	ret    

0010347f <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
  10347f:	55                   	push   %ebp
  103480:	89 e5                	mov    %esp,%ebp
  103482:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
  103485:	83 ec 04             	sub    $0x4,%esp
  103488:	6a 01                	push   $0x1
  10348a:	ff 75 10             	pushl  0x10(%ebp)
  10348d:	ff 75 08             	pushl  0x8(%ebp)
  103490:	e8 d9 fd ff ff       	call   10326e <get_pte>
  103495:	83 c4 10             	add    $0x10,%esp
  103498:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
  10349b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10349f:	75 0a                	jne    1034ab <page_insert+0x2c>
        return -E_NO_MEM;
  1034a1:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  1034a6:	e9 8b 00 00 00       	jmp    103536 <page_insert+0xb7>
    }
    page_ref_inc(page);
  1034ab:	83 ec 0c             	sub    $0xc,%esp
  1034ae:	ff 75 0c             	pushl  0xc(%ebp)
  1034b1:	e8 fa f4 ff ff       	call   1029b0 <page_ref_inc>
  1034b6:	83 c4 10             	add    $0x10,%esp
    if (*ptep & PTE_P) {
  1034b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1034bc:	8b 00                	mov    (%eax),%eax
  1034be:	83 e0 01             	and    $0x1,%eax
  1034c1:	85 c0                	test   %eax,%eax
  1034c3:	74 40                	je     103505 <page_insert+0x86>
        struct Page *p = pte2page(*ptep);
  1034c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1034c8:	8b 00                	mov    (%eax),%eax
  1034ca:	83 ec 0c             	sub    $0xc,%esp
  1034cd:	50                   	push   %eax
  1034ce:	e8 6f f4 ff ff       	call   102942 <pte2page>
  1034d3:	83 c4 10             	add    $0x10,%esp
  1034d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
  1034d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1034dc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1034df:	75 10                	jne    1034f1 <page_insert+0x72>
            page_ref_dec(page);
  1034e1:	83 ec 0c             	sub    $0xc,%esp
  1034e4:	ff 75 0c             	pushl  0xc(%ebp)
  1034e7:	e8 db f4 ff ff       	call   1029c7 <page_ref_dec>
  1034ec:	83 c4 10             	add    $0x10,%esp
  1034ef:	eb 14                	jmp    103505 <page_insert+0x86>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
  1034f1:	83 ec 04             	sub    $0x4,%esp
  1034f4:	ff 75 f4             	pushl  -0xc(%ebp)
  1034f7:	ff 75 10             	pushl  0x10(%ebp)
  1034fa:	ff 75 08             	pushl  0x8(%ebp)
  1034fd:	e8 df fe ff ff       	call   1033e1 <page_remove_pte>
  103502:	83 c4 10             	add    $0x10,%esp
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  103505:	83 ec 0c             	sub    $0xc,%esp
  103508:	ff 75 0c             	pushl  0xc(%ebp)
  10350b:	e8 93 f3 ff ff       	call   1028a3 <page2pa>
  103510:	83 c4 10             	add    $0x10,%esp
  103513:	0b 45 14             	or     0x14(%ebp),%eax
  103516:	83 c8 01             	or     $0x1,%eax
  103519:	89 c2                	mov    %eax,%edx
  10351b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10351e:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  103520:	83 ec 08             	sub    $0x8,%esp
  103523:	ff 75 10             	pushl  0x10(%ebp)
  103526:	ff 75 08             	pushl  0x8(%ebp)
  103529:	e8 0a 00 00 00       	call   103538 <tlb_invalidate>
  10352e:	83 c4 10             	add    $0x10,%esp
    return 0;
  103531:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103536:	c9                   	leave  
  103537:	c3                   	ret    

00103538 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
  103538:	55                   	push   %ebp
  103539:	89 e5                	mov    %esp,%ebp
  10353b:	83 ec 18             	sub    $0x18,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
  10353e:	0f 20 d8             	mov    %cr3,%eax
  103541:	89 45 ec             	mov    %eax,-0x14(%ebp)
    return cr3;
  103544:	8b 55 ec             	mov    -0x14(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
  103547:	8b 45 08             	mov    0x8(%ebp),%eax
  10354a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10354d:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  103554:	77 17                	ja     10356d <tlb_invalidate+0x35>
  103556:	ff 75 f0             	pushl  -0x10(%ebp)
  103559:	68 44 62 10 00       	push   $0x106244
  10355e:	68 ec 01 00 00       	push   $0x1ec
  103563:	68 68 62 10 00       	push   $0x106268
  103568:	e8 60 ce ff ff       	call   1003cd <__panic>
  10356d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103570:	05 00 00 00 40       	add    $0x40000000,%eax
  103575:	39 c2                	cmp    %eax,%edx
  103577:	75 0c                	jne    103585 <tlb_invalidate+0x4d>
        invlpg((void *)la);
  103579:	8b 45 0c             	mov    0xc(%ebp),%eax
  10357c:	89 45 f4             	mov    %eax,-0xc(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
  10357f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103582:	0f 01 38             	invlpg (%eax)
    }
}
  103585:	90                   	nop
  103586:	c9                   	leave  
  103587:	c3                   	ret    

00103588 <check_alloc_page>:

static void
check_alloc_page(void) {
  103588:	55                   	push   %ebp
  103589:	89 e5                	mov    %esp,%ebp
  10358b:	83 ec 08             	sub    $0x8,%esp
    pmm_manager->check();
  10358e:	a1 50 89 11 00       	mov    0x118950,%eax
  103593:	8b 40 18             	mov    0x18(%eax),%eax
  103596:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  103598:	83 ec 0c             	sub    $0xc,%esp
  10359b:	68 c8 62 10 00       	push   $0x1062c8
  1035a0:	e8 c2 cc ff ff       	call   100267 <cprintf>
  1035a5:	83 c4 10             	add    $0x10,%esp
}
  1035a8:	90                   	nop
  1035a9:	c9                   	leave  
  1035aa:	c3                   	ret    

001035ab <check_pgdir>:

static void
check_pgdir(void) {
  1035ab:	55                   	push   %ebp
  1035ac:	89 e5                	mov    %esp,%ebp
  1035ae:	83 ec 28             	sub    $0x28,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
  1035b1:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  1035b6:	3d 00 80 03 00       	cmp    $0x38000,%eax
  1035bb:	76 19                	jbe    1035d6 <check_pgdir+0x2b>
  1035bd:	68 e7 62 10 00       	push   $0x1062e7
  1035c2:	68 8d 62 10 00       	push   $0x10628d
  1035c7:	68 f9 01 00 00       	push   $0x1f9
  1035cc:	68 68 62 10 00       	push   $0x106268
  1035d1:	e8 f7 cd ff ff       	call   1003cd <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  1035d6:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1035db:	85 c0                	test   %eax,%eax
  1035dd:	74 0e                	je     1035ed <check_pgdir+0x42>
  1035df:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1035e4:	25 ff 0f 00 00       	and    $0xfff,%eax
  1035e9:	85 c0                	test   %eax,%eax
  1035eb:	74 19                	je     103606 <check_pgdir+0x5b>
  1035ed:	68 04 63 10 00       	push   $0x106304
  1035f2:	68 8d 62 10 00       	push   $0x10628d
  1035f7:	68 fa 01 00 00       	push   $0x1fa
  1035fc:	68 68 62 10 00       	push   $0x106268
  103601:	e8 c7 cd ff ff       	call   1003cd <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  103606:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10360b:	83 ec 04             	sub    $0x4,%esp
  10360e:	6a 00                	push   $0x0
  103610:	6a 00                	push   $0x0
  103612:	50                   	push   %eax
  103613:	e8 73 fd ff ff       	call   10338b <get_page>
  103618:	83 c4 10             	add    $0x10,%esp
  10361b:	85 c0                	test   %eax,%eax
  10361d:	74 19                	je     103638 <check_pgdir+0x8d>
  10361f:	68 3c 63 10 00       	push   $0x10633c
  103624:	68 8d 62 10 00       	push   $0x10628d
  103629:	68 fb 01 00 00       	push   $0x1fb
  10362e:	68 68 62 10 00       	push   $0x106268
  103633:	e8 95 cd ff ff       	call   1003cd <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  103638:	83 ec 0c             	sub    $0xc,%esp
  10363b:	6a 01                	push   $0x1
  10363d:	e8 64 f5 ff ff       	call   102ba6 <alloc_pages>
  103642:	83 c4 10             	add    $0x10,%esp
  103645:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  103648:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10364d:	6a 00                	push   $0x0
  10364f:	6a 00                	push   $0x0
  103651:	ff 75 f4             	pushl  -0xc(%ebp)
  103654:	50                   	push   %eax
  103655:	e8 25 fe ff ff       	call   10347f <page_insert>
  10365a:	83 c4 10             	add    $0x10,%esp
  10365d:	85 c0                	test   %eax,%eax
  10365f:	74 19                	je     10367a <check_pgdir+0xcf>
  103661:	68 64 63 10 00       	push   $0x106364
  103666:	68 8d 62 10 00       	push   $0x10628d
  10366b:	68 ff 01 00 00       	push   $0x1ff
  103670:	68 68 62 10 00       	push   $0x106268
  103675:	e8 53 cd ff ff       	call   1003cd <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  10367a:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10367f:	83 ec 04             	sub    $0x4,%esp
  103682:	6a 00                	push   $0x0
  103684:	6a 00                	push   $0x0
  103686:	50                   	push   %eax
  103687:	e8 e2 fb ff ff       	call   10326e <get_pte>
  10368c:	83 c4 10             	add    $0x10,%esp
  10368f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103692:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103696:	75 19                	jne    1036b1 <check_pgdir+0x106>
  103698:	68 90 63 10 00       	push   $0x106390
  10369d:	68 8d 62 10 00       	push   $0x10628d
  1036a2:	68 02 02 00 00       	push   $0x202
  1036a7:	68 68 62 10 00       	push   $0x106268
  1036ac:	e8 1c cd ff ff       	call   1003cd <__panic>
    assert(pte2page(*ptep) == p1);
  1036b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1036b4:	8b 00                	mov    (%eax),%eax
  1036b6:	83 ec 0c             	sub    $0xc,%esp
  1036b9:	50                   	push   %eax
  1036ba:	e8 83 f2 ff ff       	call   102942 <pte2page>
  1036bf:	83 c4 10             	add    $0x10,%esp
  1036c2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1036c5:	74 19                	je     1036e0 <check_pgdir+0x135>
  1036c7:	68 bd 63 10 00       	push   $0x1063bd
  1036cc:	68 8d 62 10 00       	push   $0x10628d
  1036d1:	68 03 02 00 00       	push   $0x203
  1036d6:	68 68 62 10 00       	push   $0x106268
  1036db:	e8 ed cc ff ff       	call   1003cd <__panic>
    assert(page_ref(p1) == 1);
  1036e0:	83 ec 0c             	sub    $0xc,%esp
  1036e3:	ff 75 f4             	pushl  -0xc(%ebp)
  1036e6:	e8 ad f2 ff ff       	call   102998 <page_ref>
  1036eb:	83 c4 10             	add    $0x10,%esp
  1036ee:	83 f8 01             	cmp    $0x1,%eax
  1036f1:	74 19                	je     10370c <check_pgdir+0x161>
  1036f3:	68 d3 63 10 00       	push   $0x1063d3
  1036f8:	68 8d 62 10 00       	push   $0x10628d
  1036fd:	68 04 02 00 00       	push   $0x204
  103702:	68 68 62 10 00       	push   $0x106268
  103707:	e8 c1 cc ff ff       	call   1003cd <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  10370c:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103711:	8b 00                	mov    (%eax),%eax
  103713:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103718:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10371b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10371e:	c1 e8 0c             	shr    $0xc,%eax
  103721:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103724:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  103729:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  10372c:	72 17                	jb     103745 <check_pgdir+0x19a>
  10372e:	ff 75 ec             	pushl  -0x14(%ebp)
  103731:	68 a0 61 10 00       	push   $0x1061a0
  103736:	68 06 02 00 00       	push   $0x206
  10373b:	68 68 62 10 00       	push   $0x106268
  103740:	e8 88 cc ff ff       	call   1003cd <__panic>
  103745:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103748:	2d 00 00 00 40       	sub    $0x40000000,%eax
  10374d:	83 c0 04             	add    $0x4,%eax
  103750:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  103753:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103758:	83 ec 04             	sub    $0x4,%esp
  10375b:	6a 00                	push   $0x0
  10375d:	68 00 10 00 00       	push   $0x1000
  103762:	50                   	push   %eax
  103763:	e8 06 fb ff ff       	call   10326e <get_pte>
  103768:	83 c4 10             	add    $0x10,%esp
  10376b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  10376e:	74 19                	je     103789 <check_pgdir+0x1de>
  103770:	68 e8 63 10 00       	push   $0x1063e8
  103775:	68 8d 62 10 00       	push   $0x10628d
  10377a:	68 07 02 00 00       	push   $0x207
  10377f:	68 68 62 10 00       	push   $0x106268
  103784:	e8 44 cc ff ff       	call   1003cd <__panic>

    p2 = alloc_page();
  103789:	83 ec 0c             	sub    $0xc,%esp
  10378c:	6a 01                	push   $0x1
  10378e:	e8 13 f4 ff ff       	call   102ba6 <alloc_pages>
  103793:	83 c4 10             	add    $0x10,%esp
  103796:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  103799:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10379e:	6a 06                	push   $0x6
  1037a0:	68 00 10 00 00       	push   $0x1000
  1037a5:	ff 75 e4             	pushl  -0x1c(%ebp)
  1037a8:	50                   	push   %eax
  1037a9:	e8 d1 fc ff ff       	call   10347f <page_insert>
  1037ae:	83 c4 10             	add    $0x10,%esp
  1037b1:	85 c0                	test   %eax,%eax
  1037b3:	74 19                	je     1037ce <check_pgdir+0x223>
  1037b5:	68 10 64 10 00       	push   $0x106410
  1037ba:	68 8d 62 10 00       	push   $0x10628d
  1037bf:	68 0a 02 00 00       	push   $0x20a
  1037c4:	68 68 62 10 00       	push   $0x106268
  1037c9:	e8 ff cb ff ff       	call   1003cd <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  1037ce:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1037d3:	83 ec 04             	sub    $0x4,%esp
  1037d6:	6a 00                	push   $0x0
  1037d8:	68 00 10 00 00       	push   $0x1000
  1037dd:	50                   	push   %eax
  1037de:	e8 8b fa ff ff       	call   10326e <get_pte>
  1037e3:	83 c4 10             	add    $0x10,%esp
  1037e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1037e9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1037ed:	75 19                	jne    103808 <check_pgdir+0x25d>
  1037ef:	68 48 64 10 00       	push   $0x106448
  1037f4:	68 8d 62 10 00       	push   $0x10628d
  1037f9:	68 0b 02 00 00       	push   $0x20b
  1037fe:	68 68 62 10 00       	push   $0x106268
  103803:	e8 c5 cb ff ff       	call   1003cd <__panic>
    assert(*ptep & PTE_U);
  103808:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10380b:	8b 00                	mov    (%eax),%eax
  10380d:	83 e0 04             	and    $0x4,%eax
  103810:	85 c0                	test   %eax,%eax
  103812:	75 19                	jne    10382d <check_pgdir+0x282>
  103814:	68 78 64 10 00       	push   $0x106478
  103819:	68 8d 62 10 00       	push   $0x10628d
  10381e:	68 0c 02 00 00       	push   $0x20c
  103823:	68 68 62 10 00       	push   $0x106268
  103828:	e8 a0 cb ff ff       	call   1003cd <__panic>
    assert(*ptep & PTE_W);
  10382d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103830:	8b 00                	mov    (%eax),%eax
  103832:	83 e0 02             	and    $0x2,%eax
  103835:	85 c0                	test   %eax,%eax
  103837:	75 19                	jne    103852 <check_pgdir+0x2a7>
  103839:	68 86 64 10 00       	push   $0x106486
  10383e:	68 8d 62 10 00       	push   $0x10628d
  103843:	68 0d 02 00 00       	push   $0x20d
  103848:	68 68 62 10 00       	push   $0x106268
  10384d:	e8 7b cb ff ff       	call   1003cd <__panic>
    assert(boot_pgdir[0] & PTE_U);
  103852:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103857:	8b 00                	mov    (%eax),%eax
  103859:	83 e0 04             	and    $0x4,%eax
  10385c:	85 c0                	test   %eax,%eax
  10385e:	75 19                	jne    103879 <check_pgdir+0x2ce>
  103860:	68 94 64 10 00       	push   $0x106494
  103865:	68 8d 62 10 00       	push   $0x10628d
  10386a:	68 0e 02 00 00       	push   $0x20e
  10386f:	68 68 62 10 00       	push   $0x106268
  103874:	e8 54 cb ff ff       	call   1003cd <__panic>
    assert(page_ref(p2) == 1);
  103879:	83 ec 0c             	sub    $0xc,%esp
  10387c:	ff 75 e4             	pushl  -0x1c(%ebp)
  10387f:	e8 14 f1 ff ff       	call   102998 <page_ref>
  103884:	83 c4 10             	add    $0x10,%esp
  103887:	83 f8 01             	cmp    $0x1,%eax
  10388a:	74 19                	je     1038a5 <check_pgdir+0x2fa>
  10388c:	68 aa 64 10 00       	push   $0x1064aa
  103891:	68 8d 62 10 00       	push   $0x10628d
  103896:	68 0f 02 00 00       	push   $0x20f
  10389b:	68 68 62 10 00       	push   $0x106268
  1038a0:	e8 28 cb ff ff       	call   1003cd <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  1038a5:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1038aa:	6a 00                	push   $0x0
  1038ac:	68 00 10 00 00       	push   $0x1000
  1038b1:	ff 75 f4             	pushl  -0xc(%ebp)
  1038b4:	50                   	push   %eax
  1038b5:	e8 c5 fb ff ff       	call   10347f <page_insert>
  1038ba:	83 c4 10             	add    $0x10,%esp
  1038bd:	85 c0                	test   %eax,%eax
  1038bf:	74 19                	je     1038da <check_pgdir+0x32f>
  1038c1:	68 bc 64 10 00       	push   $0x1064bc
  1038c6:	68 8d 62 10 00       	push   $0x10628d
  1038cb:	68 11 02 00 00       	push   $0x211
  1038d0:	68 68 62 10 00       	push   $0x106268
  1038d5:	e8 f3 ca ff ff       	call   1003cd <__panic>
    assert(page_ref(p1) == 2);
  1038da:	83 ec 0c             	sub    $0xc,%esp
  1038dd:	ff 75 f4             	pushl  -0xc(%ebp)
  1038e0:	e8 b3 f0 ff ff       	call   102998 <page_ref>
  1038e5:	83 c4 10             	add    $0x10,%esp
  1038e8:	83 f8 02             	cmp    $0x2,%eax
  1038eb:	74 19                	je     103906 <check_pgdir+0x35b>
  1038ed:	68 e8 64 10 00       	push   $0x1064e8
  1038f2:	68 8d 62 10 00       	push   $0x10628d
  1038f7:	68 12 02 00 00       	push   $0x212
  1038fc:	68 68 62 10 00       	push   $0x106268
  103901:	e8 c7 ca ff ff       	call   1003cd <__panic>
    assert(page_ref(p2) == 0);
  103906:	83 ec 0c             	sub    $0xc,%esp
  103909:	ff 75 e4             	pushl  -0x1c(%ebp)
  10390c:	e8 87 f0 ff ff       	call   102998 <page_ref>
  103911:	83 c4 10             	add    $0x10,%esp
  103914:	85 c0                	test   %eax,%eax
  103916:	74 19                	je     103931 <check_pgdir+0x386>
  103918:	68 fa 64 10 00       	push   $0x1064fa
  10391d:	68 8d 62 10 00       	push   $0x10628d
  103922:	68 13 02 00 00       	push   $0x213
  103927:	68 68 62 10 00       	push   $0x106268
  10392c:	e8 9c ca ff ff       	call   1003cd <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  103931:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103936:	83 ec 04             	sub    $0x4,%esp
  103939:	6a 00                	push   $0x0
  10393b:	68 00 10 00 00       	push   $0x1000
  103940:	50                   	push   %eax
  103941:	e8 28 f9 ff ff       	call   10326e <get_pte>
  103946:	83 c4 10             	add    $0x10,%esp
  103949:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10394c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103950:	75 19                	jne    10396b <check_pgdir+0x3c0>
  103952:	68 48 64 10 00       	push   $0x106448
  103957:	68 8d 62 10 00       	push   $0x10628d
  10395c:	68 14 02 00 00       	push   $0x214
  103961:	68 68 62 10 00       	push   $0x106268
  103966:	e8 62 ca ff ff       	call   1003cd <__panic>
    assert(pte2page(*ptep) == p1);
  10396b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10396e:	8b 00                	mov    (%eax),%eax
  103970:	83 ec 0c             	sub    $0xc,%esp
  103973:	50                   	push   %eax
  103974:	e8 c9 ef ff ff       	call   102942 <pte2page>
  103979:	83 c4 10             	add    $0x10,%esp
  10397c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  10397f:	74 19                	je     10399a <check_pgdir+0x3ef>
  103981:	68 bd 63 10 00       	push   $0x1063bd
  103986:	68 8d 62 10 00       	push   $0x10628d
  10398b:	68 15 02 00 00       	push   $0x215
  103990:	68 68 62 10 00       	push   $0x106268
  103995:	e8 33 ca ff ff       	call   1003cd <__panic>
    assert((*ptep & PTE_U) == 0);
  10399a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10399d:	8b 00                	mov    (%eax),%eax
  10399f:	83 e0 04             	and    $0x4,%eax
  1039a2:	85 c0                	test   %eax,%eax
  1039a4:	74 19                	je     1039bf <check_pgdir+0x414>
  1039a6:	68 0c 65 10 00       	push   $0x10650c
  1039ab:	68 8d 62 10 00       	push   $0x10628d
  1039b0:	68 16 02 00 00       	push   $0x216
  1039b5:	68 68 62 10 00       	push   $0x106268
  1039ba:	e8 0e ca ff ff       	call   1003cd <__panic>

    page_remove(boot_pgdir, 0x0);
  1039bf:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1039c4:	83 ec 08             	sub    $0x8,%esp
  1039c7:	6a 00                	push   $0x0
  1039c9:	50                   	push   %eax
  1039ca:	e8 77 fa ff ff       	call   103446 <page_remove>
  1039cf:	83 c4 10             	add    $0x10,%esp
    assert(page_ref(p1) == 1);
  1039d2:	83 ec 0c             	sub    $0xc,%esp
  1039d5:	ff 75 f4             	pushl  -0xc(%ebp)
  1039d8:	e8 bb ef ff ff       	call   102998 <page_ref>
  1039dd:	83 c4 10             	add    $0x10,%esp
  1039e0:	83 f8 01             	cmp    $0x1,%eax
  1039e3:	74 19                	je     1039fe <check_pgdir+0x453>
  1039e5:	68 d3 63 10 00       	push   $0x1063d3
  1039ea:	68 8d 62 10 00       	push   $0x10628d
  1039ef:	68 19 02 00 00       	push   $0x219
  1039f4:	68 68 62 10 00       	push   $0x106268
  1039f9:	e8 cf c9 ff ff       	call   1003cd <__panic>
    assert(page_ref(p2) == 0);
  1039fe:	83 ec 0c             	sub    $0xc,%esp
  103a01:	ff 75 e4             	pushl  -0x1c(%ebp)
  103a04:	e8 8f ef ff ff       	call   102998 <page_ref>
  103a09:	83 c4 10             	add    $0x10,%esp
  103a0c:	85 c0                	test   %eax,%eax
  103a0e:	74 19                	je     103a29 <check_pgdir+0x47e>
  103a10:	68 fa 64 10 00       	push   $0x1064fa
  103a15:	68 8d 62 10 00       	push   $0x10628d
  103a1a:	68 1a 02 00 00       	push   $0x21a
  103a1f:	68 68 62 10 00       	push   $0x106268
  103a24:	e8 a4 c9 ff ff       	call   1003cd <__panic>

    page_remove(boot_pgdir, PGSIZE);
  103a29:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103a2e:	83 ec 08             	sub    $0x8,%esp
  103a31:	68 00 10 00 00       	push   $0x1000
  103a36:	50                   	push   %eax
  103a37:	e8 0a fa ff ff       	call   103446 <page_remove>
  103a3c:	83 c4 10             	add    $0x10,%esp
    assert(page_ref(p1) == 0);
  103a3f:	83 ec 0c             	sub    $0xc,%esp
  103a42:	ff 75 f4             	pushl  -0xc(%ebp)
  103a45:	e8 4e ef ff ff       	call   102998 <page_ref>
  103a4a:	83 c4 10             	add    $0x10,%esp
  103a4d:	85 c0                	test   %eax,%eax
  103a4f:	74 19                	je     103a6a <check_pgdir+0x4bf>
  103a51:	68 21 65 10 00       	push   $0x106521
  103a56:	68 8d 62 10 00       	push   $0x10628d
  103a5b:	68 1d 02 00 00       	push   $0x21d
  103a60:	68 68 62 10 00       	push   $0x106268
  103a65:	e8 63 c9 ff ff       	call   1003cd <__panic>
    assert(page_ref(p2) == 0);
  103a6a:	83 ec 0c             	sub    $0xc,%esp
  103a6d:	ff 75 e4             	pushl  -0x1c(%ebp)
  103a70:	e8 23 ef ff ff       	call   102998 <page_ref>
  103a75:	83 c4 10             	add    $0x10,%esp
  103a78:	85 c0                	test   %eax,%eax
  103a7a:	74 19                	je     103a95 <check_pgdir+0x4ea>
  103a7c:	68 fa 64 10 00       	push   $0x1064fa
  103a81:	68 8d 62 10 00       	push   $0x10628d
  103a86:	68 1e 02 00 00       	push   $0x21e
  103a8b:	68 68 62 10 00       	push   $0x106268
  103a90:	e8 38 c9 ff ff       	call   1003cd <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
  103a95:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103a9a:	8b 00                	mov    (%eax),%eax
  103a9c:	83 ec 0c             	sub    $0xc,%esp
  103a9f:	50                   	push   %eax
  103aa0:	e8 d7 ee ff ff       	call   10297c <pde2page>
  103aa5:	83 c4 10             	add    $0x10,%esp
  103aa8:	83 ec 0c             	sub    $0xc,%esp
  103aab:	50                   	push   %eax
  103aac:	e8 e7 ee ff ff       	call   102998 <page_ref>
  103ab1:	83 c4 10             	add    $0x10,%esp
  103ab4:	83 f8 01             	cmp    $0x1,%eax
  103ab7:	74 19                	je     103ad2 <check_pgdir+0x527>
  103ab9:	68 34 65 10 00       	push   $0x106534
  103abe:	68 8d 62 10 00       	push   $0x10628d
  103ac3:	68 20 02 00 00       	push   $0x220
  103ac8:	68 68 62 10 00       	push   $0x106268
  103acd:	e8 fb c8 ff ff       	call   1003cd <__panic>
    free_page(pde2page(boot_pgdir[0]));
  103ad2:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103ad7:	8b 00                	mov    (%eax),%eax
  103ad9:	83 ec 0c             	sub    $0xc,%esp
  103adc:	50                   	push   %eax
  103add:	e8 9a ee ff ff       	call   10297c <pde2page>
  103ae2:	83 c4 10             	add    $0x10,%esp
  103ae5:	83 ec 08             	sub    $0x8,%esp
  103ae8:	6a 01                	push   $0x1
  103aea:	50                   	push   %eax
  103aeb:	e8 f4 f0 ff ff       	call   102be4 <free_pages>
  103af0:	83 c4 10             	add    $0x10,%esp
    boot_pgdir[0] = 0;
  103af3:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103af8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  103afe:	83 ec 0c             	sub    $0xc,%esp
  103b01:	68 5b 65 10 00       	push   $0x10655b
  103b06:	e8 5c c7 ff ff       	call   100267 <cprintf>
  103b0b:	83 c4 10             	add    $0x10,%esp
}
  103b0e:	90                   	nop
  103b0f:	c9                   	leave  
  103b10:	c3                   	ret    

00103b11 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
  103b11:	55                   	push   %ebp
  103b12:	89 e5                	mov    %esp,%ebp
  103b14:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  103b17:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  103b1e:	e9 a3 00 00 00       	jmp    103bc6 <check_boot_pgdir+0xb5>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  103b23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103b26:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103b29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103b2c:	c1 e8 0c             	shr    $0xc,%eax
  103b2f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103b32:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  103b37:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  103b3a:	72 17                	jb     103b53 <check_boot_pgdir+0x42>
  103b3c:	ff 75 f0             	pushl  -0x10(%ebp)
  103b3f:	68 a0 61 10 00       	push   $0x1061a0
  103b44:	68 2c 02 00 00       	push   $0x22c
  103b49:	68 68 62 10 00       	push   $0x106268
  103b4e:	e8 7a c8 ff ff       	call   1003cd <__panic>
  103b53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103b56:	2d 00 00 00 40       	sub    $0x40000000,%eax
  103b5b:	89 c2                	mov    %eax,%edx
  103b5d:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103b62:	83 ec 04             	sub    $0x4,%esp
  103b65:	6a 00                	push   $0x0
  103b67:	52                   	push   %edx
  103b68:	50                   	push   %eax
  103b69:	e8 00 f7 ff ff       	call   10326e <get_pte>
  103b6e:	83 c4 10             	add    $0x10,%esp
  103b71:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103b74:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103b78:	75 19                	jne    103b93 <check_boot_pgdir+0x82>
  103b7a:	68 78 65 10 00       	push   $0x106578
  103b7f:	68 8d 62 10 00       	push   $0x10628d
  103b84:	68 2c 02 00 00       	push   $0x22c
  103b89:	68 68 62 10 00       	push   $0x106268
  103b8e:	e8 3a c8 ff ff       	call   1003cd <__panic>
        assert(PTE_ADDR(*ptep) == i);
  103b93:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103b96:	8b 00                	mov    (%eax),%eax
  103b98:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103b9d:	89 c2                	mov    %eax,%edx
  103b9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103ba2:	39 c2                	cmp    %eax,%edx
  103ba4:	74 19                	je     103bbf <check_boot_pgdir+0xae>
  103ba6:	68 b5 65 10 00       	push   $0x1065b5
  103bab:	68 8d 62 10 00       	push   $0x10628d
  103bb0:	68 2d 02 00 00       	push   $0x22d
  103bb5:	68 68 62 10 00       	push   $0x106268
  103bba:	e8 0e c8 ff ff       	call   1003cd <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  103bbf:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  103bc6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103bc9:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  103bce:	39 c2                	cmp    %eax,%edx
  103bd0:	0f 82 4d ff ff ff    	jb     103b23 <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  103bd6:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103bdb:	05 ac 0f 00 00       	add    $0xfac,%eax
  103be0:	8b 00                	mov    (%eax),%eax
  103be2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103be7:	89 c2                	mov    %eax,%edx
  103be9:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103bee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103bf1:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
  103bf8:	77 17                	ja     103c11 <check_boot_pgdir+0x100>
  103bfa:	ff 75 e4             	pushl  -0x1c(%ebp)
  103bfd:	68 44 62 10 00       	push   $0x106244
  103c02:	68 30 02 00 00       	push   $0x230
  103c07:	68 68 62 10 00       	push   $0x106268
  103c0c:	e8 bc c7 ff ff       	call   1003cd <__panic>
  103c11:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103c14:	05 00 00 00 40       	add    $0x40000000,%eax
  103c19:	39 c2                	cmp    %eax,%edx
  103c1b:	74 19                	je     103c36 <check_boot_pgdir+0x125>
  103c1d:	68 cc 65 10 00       	push   $0x1065cc
  103c22:	68 8d 62 10 00       	push   $0x10628d
  103c27:	68 30 02 00 00       	push   $0x230
  103c2c:	68 68 62 10 00       	push   $0x106268
  103c31:	e8 97 c7 ff ff       	call   1003cd <__panic>

    assert(boot_pgdir[0] == 0);
  103c36:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103c3b:	8b 00                	mov    (%eax),%eax
  103c3d:	85 c0                	test   %eax,%eax
  103c3f:	74 19                	je     103c5a <check_boot_pgdir+0x149>
  103c41:	68 00 66 10 00       	push   $0x106600
  103c46:	68 8d 62 10 00       	push   $0x10628d
  103c4b:	68 32 02 00 00       	push   $0x232
  103c50:	68 68 62 10 00       	push   $0x106268
  103c55:	e8 73 c7 ff ff       	call   1003cd <__panic>

    struct Page *p;
    p = alloc_page();
  103c5a:	83 ec 0c             	sub    $0xc,%esp
  103c5d:	6a 01                	push   $0x1
  103c5f:	e8 42 ef ff ff       	call   102ba6 <alloc_pages>
  103c64:	83 c4 10             	add    $0x10,%esp
  103c67:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  103c6a:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103c6f:	6a 02                	push   $0x2
  103c71:	68 00 01 00 00       	push   $0x100
  103c76:	ff 75 e0             	pushl  -0x20(%ebp)
  103c79:	50                   	push   %eax
  103c7a:	e8 00 f8 ff ff       	call   10347f <page_insert>
  103c7f:	83 c4 10             	add    $0x10,%esp
  103c82:	85 c0                	test   %eax,%eax
  103c84:	74 19                	je     103c9f <check_boot_pgdir+0x18e>
  103c86:	68 14 66 10 00       	push   $0x106614
  103c8b:	68 8d 62 10 00       	push   $0x10628d
  103c90:	68 36 02 00 00       	push   $0x236
  103c95:	68 68 62 10 00       	push   $0x106268
  103c9a:	e8 2e c7 ff ff       	call   1003cd <__panic>
    assert(page_ref(p) == 1);
  103c9f:	83 ec 0c             	sub    $0xc,%esp
  103ca2:	ff 75 e0             	pushl  -0x20(%ebp)
  103ca5:	e8 ee ec ff ff       	call   102998 <page_ref>
  103caa:	83 c4 10             	add    $0x10,%esp
  103cad:	83 f8 01             	cmp    $0x1,%eax
  103cb0:	74 19                	je     103ccb <check_boot_pgdir+0x1ba>
  103cb2:	68 42 66 10 00       	push   $0x106642
  103cb7:	68 8d 62 10 00       	push   $0x10628d
  103cbc:	68 37 02 00 00       	push   $0x237
  103cc1:	68 68 62 10 00       	push   $0x106268
  103cc6:	e8 02 c7 ff ff       	call   1003cd <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  103ccb:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103cd0:	6a 02                	push   $0x2
  103cd2:	68 00 11 00 00       	push   $0x1100
  103cd7:	ff 75 e0             	pushl  -0x20(%ebp)
  103cda:	50                   	push   %eax
  103cdb:	e8 9f f7 ff ff       	call   10347f <page_insert>
  103ce0:	83 c4 10             	add    $0x10,%esp
  103ce3:	85 c0                	test   %eax,%eax
  103ce5:	74 19                	je     103d00 <check_boot_pgdir+0x1ef>
  103ce7:	68 54 66 10 00       	push   $0x106654
  103cec:	68 8d 62 10 00       	push   $0x10628d
  103cf1:	68 38 02 00 00       	push   $0x238
  103cf6:	68 68 62 10 00       	push   $0x106268
  103cfb:	e8 cd c6 ff ff       	call   1003cd <__panic>
    assert(page_ref(p) == 2);
  103d00:	83 ec 0c             	sub    $0xc,%esp
  103d03:	ff 75 e0             	pushl  -0x20(%ebp)
  103d06:	e8 8d ec ff ff       	call   102998 <page_ref>
  103d0b:	83 c4 10             	add    $0x10,%esp
  103d0e:	83 f8 02             	cmp    $0x2,%eax
  103d11:	74 19                	je     103d2c <check_boot_pgdir+0x21b>
  103d13:	68 8b 66 10 00       	push   $0x10668b
  103d18:	68 8d 62 10 00       	push   $0x10628d
  103d1d:	68 39 02 00 00       	push   $0x239
  103d22:	68 68 62 10 00       	push   $0x106268
  103d27:	e8 a1 c6 ff ff       	call   1003cd <__panic>

    const char *str = "ucore: Hello world!!";
  103d2c:	c7 45 dc 9c 66 10 00 	movl   $0x10669c,-0x24(%ebp)
    strcpy((void *)0x100, str);
  103d33:	83 ec 08             	sub    $0x8,%esp
  103d36:	ff 75 dc             	pushl  -0x24(%ebp)
  103d39:	68 00 01 00 00       	push   $0x100
  103d3e:	e8 96 12 00 00       	call   104fd9 <strcpy>
  103d43:	83 c4 10             	add    $0x10,%esp
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  103d46:	83 ec 08             	sub    $0x8,%esp
  103d49:	68 00 11 00 00       	push   $0x1100
  103d4e:	68 00 01 00 00       	push   $0x100
  103d53:	e8 fb 12 00 00       	call   105053 <strcmp>
  103d58:	83 c4 10             	add    $0x10,%esp
  103d5b:	85 c0                	test   %eax,%eax
  103d5d:	74 19                	je     103d78 <check_boot_pgdir+0x267>
  103d5f:	68 b4 66 10 00       	push   $0x1066b4
  103d64:	68 8d 62 10 00       	push   $0x10628d
  103d69:	68 3d 02 00 00       	push   $0x23d
  103d6e:	68 68 62 10 00       	push   $0x106268
  103d73:	e8 55 c6 ff ff       	call   1003cd <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  103d78:	83 ec 0c             	sub    $0xc,%esp
  103d7b:	ff 75 e0             	pushl  -0x20(%ebp)
  103d7e:	e8 7a eb ff ff       	call   1028fd <page2kva>
  103d83:	83 c4 10             	add    $0x10,%esp
  103d86:	05 00 01 00 00       	add    $0x100,%eax
  103d8b:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  103d8e:	83 ec 0c             	sub    $0xc,%esp
  103d91:	68 00 01 00 00       	push   $0x100
  103d96:	e8 e6 11 00 00       	call   104f81 <strlen>
  103d9b:	83 c4 10             	add    $0x10,%esp
  103d9e:	85 c0                	test   %eax,%eax
  103da0:	74 19                	je     103dbb <check_boot_pgdir+0x2aa>
  103da2:	68 ec 66 10 00       	push   $0x1066ec
  103da7:	68 8d 62 10 00       	push   $0x10628d
  103dac:	68 40 02 00 00       	push   $0x240
  103db1:	68 68 62 10 00       	push   $0x106268
  103db6:	e8 12 c6 ff ff       	call   1003cd <__panic>

    free_page(p);
  103dbb:	83 ec 08             	sub    $0x8,%esp
  103dbe:	6a 01                	push   $0x1
  103dc0:	ff 75 e0             	pushl  -0x20(%ebp)
  103dc3:	e8 1c ee ff ff       	call   102be4 <free_pages>
  103dc8:	83 c4 10             	add    $0x10,%esp
    free_page(pde2page(boot_pgdir[0]));
  103dcb:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103dd0:	8b 00                	mov    (%eax),%eax
  103dd2:	83 ec 0c             	sub    $0xc,%esp
  103dd5:	50                   	push   %eax
  103dd6:	e8 a1 eb ff ff       	call   10297c <pde2page>
  103ddb:	83 c4 10             	add    $0x10,%esp
  103dde:	83 ec 08             	sub    $0x8,%esp
  103de1:	6a 01                	push   $0x1
  103de3:	50                   	push   %eax
  103de4:	e8 fb ed ff ff       	call   102be4 <free_pages>
  103de9:	83 c4 10             	add    $0x10,%esp
    boot_pgdir[0] = 0;
  103dec:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103df1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  103df7:	83 ec 0c             	sub    $0xc,%esp
  103dfa:	68 10 67 10 00       	push   $0x106710
  103dff:	e8 63 c4 ff ff       	call   100267 <cprintf>
  103e04:	83 c4 10             	add    $0x10,%esp
}
  103e07:	90                   	nop
  103e08:	c9                   	leave  
  103e09:	c3                   	ret    

00103e0a <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
  103e0a:	55                   	push   %ebp
  103e0b:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  103e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  103e10:	83 e0 04             	and    $0x4,%eax
  103e13:	85 c0                	test   %eax,%eax
  103e15:	74 07                	je     103e1e <perm2str+0x14>
  103e17:	b8 75 00 00 00       	mov    $0x75,%eax
  103e1c:	eb 05                	jmp    103e23 <perm2str+0x19>
  103e1e:	b8 2d 00 00 00       	mov    $0x2d,%eax
  103e23:	a2 48 89 11 00       	mov    %al,0x118948
    str[1] = 'r';
  103e28:	c6 05 49 89 11 00 72 	movb   $0x72,0x118949
    str[2] = (perm & PTE_W) ? 'w' : '-';
  103e2f:	8b 45 08             	mov    0x8(%ebp),%eax
  103e32:	83 e0 02             	and    $0x2,%eax
  103e35:	85 c0                	test   %eax,%eax
  103e37:	74 07                	je     103e40 <perm2str+0x36>
  103e39:	b8 77 00 00 00       	mov    $0x77,%eax
  103e3e:	eb 05                	jmp    103e45 <perm2str+0x3b>
  103e40:	b8 2d 00 00 00       	mov    $0x2d,%eax
  103e45:	a2 4a 89 11 00       	mov    %al,0x11894a
    str[3] = '\0';
  103e4a:	c6 05 4b 89 11 00 00 	movb   $0x0,0x11894b
    return str;
  103e51:	b8 48 89 11 00       	mov    $0x118948,%eax
}
  103e56:	5d                   	pop    %ebp
  103e57:	c3                   	ret    

00103e58 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
  103e58:	55                   	push   %ebp
  103e59:	89 e5                	mov    %esp,%ebp
  103e5b:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
  103e5e:	8b 45 10             	mov    0x10(%ebp),%eax
  103e61:	3b 45 0c             	cmp    0xc(%ebp),%eax
  103e64:	72 0e                	jb     103e74 <get_pgtable_items+0x1c>
        return 0;
  103e66:	b8 00 00 00 00       	mov    $0x0,%eax
  103e6b:	e9 9a 00 00 00       	jmp    103f0a <get_pgtable_items+0xb2>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
  103e70:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
  103e74:	8b 45 10             	mov    0x10(%ebp),%eax
  103e77:	3b 45 0c             	cmp    0xc(%ebp),%eax
  103e7a:	73 18                	jae    103e94 <get_pgtable_items+0x3c>
  103e7c:	8b 45 10             	mov    0x10(%ebp),%eax
  103e7f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  103e86:	8b 45 14             	mov    0x14(%ebp),%eax
  103e89:	01 d0                	add    %edx,%eax
  103e8b:	8b 00                	mov    (%eax),%eax
  103e8d:	83 e0 01             	and    $0x1,%eax
  103e90:	85 c0                	test   %eax,%eax
  103e92:	74 dc                	je     103e70 <get_pgtable_items+0x18>
        start ++;
    }
    if (start < right) {
  103e94:	8b 45 10             	mov    0x10(%ebp),%eax
  103e97:	3b 45 0c             	cmp    0xc(%ebp),%eax
  103e9a:	73 69                	jae    103f05 <get_pgtable_items+0xad>
        if (left_store != NULL) {
  103e9c:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  103ea0:	74 08                	je     103eaa <get_pgtable_items+0x52>
            *left_store = start;
  103ea2:	8b 45 18             	mov    0x18(%ebp),%eax
  103ea5:	8b 55 10             	mov    0x10(%ebp),%edx
  103ea8:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
  103eaa:	8b 45 10             	mov    0x10(%ebp),%eax
  103ead:	8d 50 01             	lea    0x1(%eax),%edx
  103eb0:	89 55 10             	mov    %edx,0x10(%ebp)
  103eb3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  103eba:	8b 45 14             	mov    0x14(%ebp),%eax
  103ebd:	01 d0                	add    %edx,%eax
  103ebf:	8b 00                	mov    (%eax),%eax
  103ec1:	83 e0 07             	and    $0x7,%eax
  103ec4:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  103ec7:	eb 04                	jmp    103ecd <get_pgtable_items+0x75>
            start ++;
  103ec9:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
  103ecd:	8b 45 10             	mov    0x10(%ebp),%eax
  103ed0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  103ed3:	73 1d                	jae    103ef2 <get_pgtable_items+0x9a>
  103ed5:	8b 45 10             	mov    0x10(%ebp),%eax
  103ed8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  103edf:	8b 45 14             	mov    0x14(%ebp),%eax
  103ee2:	01 d0                	add    %edx,%eax
  103ee4:	8b 00                	mov    (%eax),%eax
  103ee6:	83 e0 07             	and    $0x7,%eax
  103ee9:	89 c2                	mov    %eax,%edx
  103eeb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103eee:	39 c2                	cmp    %eax,%edx
  103ef0:	74 d7                	je     103ec9 <get_pgtable_items+0x71>
            start ++;
        }
        if (right_store != NULL) {
  103ef2:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  103ef6:	74 08                	je     103f00 <get_pgtable_items+0xa8>
            *right_store = start;
  103ef8:	8b 45 1c             	mov    0x1c(%ebp),%eax
  103efb:	8b 55 10             	mov    0x10(%ebp),%edx
  103efe:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  103f00:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103f03:	eb 05                	jmp    103f0a <get_pgtable_items+0xb2>
    }
    return 0;
  103f05:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103f0a:	c9                   	leave  
  103f0b:	c3                   	ret    

00103f0c <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  103f0c:	55                   	push   %ebp
  103f0d:	89 e5                	mov    %esp,%ebp
  103f0f:	57                   	push   %edi
  103f10:	56                   	push   %esi
  103f11:	53                   	push   %ebx
  103f12:	83 ec 2c             	sub    $0x2c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
  103f15:	83 ec 0c             	sub    $0xc,%esp
  103f18:	68 30 67 10 00       	push   $0x106730
  103f1d:	e8 45 c3 ff ff       	call   100267 <cprintf>
  103f22:	83 c4 10             	add    $0x10,%esp
    size_t left, right = 0, perm;
  103f25:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  103f2c:	e9 e5 00 00 00       	jmp    104016 <print_pgdir+0x10a>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  103f31:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103f34:	83 ec 0c             	sub    $0xc,%esp
  103f37:	50                   	push   %eax
  103f38:	e8 cd fe ff ff       	call   103e0a <perm2str>
  103f3d:	83 c4 10             	add    $0x10,%esp
  103f40:	89 c7                	mov    %eax,%edi
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  103f42:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103f45:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103f48:	29 c2                	sub    %eax,%edx
  103f4a:	89 d0                	mov    %edx,%eax
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  103f4c:	c1 e0 16             	shl    $0x16,%eax
  103f4f:	89 c3                	mov    %eax,%ebx
  103f51:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103f54:	c1 e0 16             	shl    $0x16,%eax
  103f57:	89 c1                	mov    %eax,%ecx
  103f59:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103f5c:	c1 e0 16             	shl    $0x16,%eax
  103f5f:	89 c2                	mov    %eax,%edx
  103f61:	8b 75 dc             	mov    -0x24(%ebp),%esi
  103f64:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103f67:	29 c6                	sub    %eax,%esi
  103f69:	89 f0                	mov    %esi,%eax
  103f6b:	83 ec 08             	sub    $0x8,%esp
  103f6e:	57                   	push   %edi
  103f6f:	53                   	push   %ebx
  103f70:	51                   	push   %ecx
  103f71:	52                   	push   %edx
  103f72:	50                   	push   %eax
  103f73:	68 61 67 10 00       	push   $0x106761
  103f78:	e8 ea c2 ff ff       	call   100267 <cprintf>
  103f7d:	83 c4 20             	add    $0x20,%esp
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
  103f80:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103f83:	c1 e0 0a             	shl    $0xa,%eax
  103f86:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  103f89:	eb 4f                	jmp    103fda <print_pgdir+0xce>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  103f8b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103f8e:	83 ec 0c             	sub    $0xc,%esp
  103f91:	50                   	push   %eax
  103f92:	e8 73 fe ff ff       	call   103e0a <perm2str>
  103f97:	83 c4 10             	add    $0x10,%esp
  103f9a:	89 c7                	mov    %eax,%edi
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  103f9c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103f9f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103fa2:	29 c2                	sub    %eax,%edx
  103fa4:	89 d0                	mov    %edx,%eax
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  103fa6:	c1 e0 0c             	shl    $0xc,%eax
  103fa9:	89 c3                	mov    %eax,%ebx
  103fab:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  103fae:	c1 e0 0c             	shl    $0xc,%eax
  103fb1:	89 c1                	mov    %eax,%ecx
  103fb3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103fb6:	c1 e0 0c             	shl    $0xc,%eax
  103fb9:	89 c2                	mov    %eax,%edx
  103fbb:	8b 75 d4             	mov    -0x2c(%ebp),%esi
  103fbe:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103fc1:	29 c6                	sub    %eax,%esi
  103fc3:	89 f0                	mov    %esi,%eax
  103fc5:	83 ec 08             	sub    $0x8,%esp
  103fc8:	57                   	push   %edi
  103fc9:	53                   	push   %ebx
  103fca:	51                   	push   %ecx
  103fcb:	52                   	push   %edx
  103fcc:	50                   	push   %eax
  103fcd:	68 80 67 10 00       	push   $0x106780
  103fd2:	e8 90 c2 ff ff       	call   100267 <cprintf>
  103fd7:	83 c4 20             	add    $0x20,%esp
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  103fda:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
  103fdf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  103fe2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103fe5:	89 d3                	mov    %edx,%ebx
  103fe7:	c1 e3 0a             	shl    $0xa,%ebx
  103fea:	8b 55 e0             	mov    -0x20(%ebp),%edx
  103fed:	89 d1                	mov    %edx,%ecx
  103fef:	c1 e1 0a             	shl    $0xa,%ecx
  103ff2:	83 ec 08             	sub    $0x8,%esp
  103ff5:	8d 55 d4             	lea    -0x2c(%ebp),%edx
  103ff8:	52                   	push   %edx
  103ff9:	8d 55 d8             	lea    -0x28(%ebp),%edx
  103ffc:	52                   	push   %edx
  103ffd:	56                   	push   %esi
  103ffe:	50                   	push   %eax
  103fff:	53                   	push   %ebx
  104000:	51                   	push   %ecx
  104001:	e8 52 fe ff ff       	call   103e58 <get_pgtable_items>
  104006:	83 c4 20             	add    $0x20,%esp
  104009:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10400c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  104010:	0f 85 75 ff ff ff    	jne    103f8b <print_pgdir+0x7f>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  104016:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
  10401b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10401e:	83 ec 08             	sub    $0x8,%esp
  104021:	8d 55 dc             	lea    -0x24(%ebp),%edx
  104024:	52                   	push   %edx
  104025:	8d 55 e0             	lea    -0x20(%ebp),%edx
  104028:	52                   	push   %edx
  104029:	51                   	push   %ecx
  10402a:	50                   	push   %eax
  10402b:	68 00 04 00 00       	push   $0x400
  104030:	6a 00                	push   $0x0
  104032:	e8 21 fe ff ff       	call   103e58 <get_pgtable_items>
  104037:	83 c4 20             	add    $0x20,%esp
  10403a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10403d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  104041:	0f 85 ea fe ff ff    	jne    103f31 <print_pgdir+0x25>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
  104047:	83 ec 0c             	sub    $0xc,%esp
  10404a:	68 a4 67 10 00       	push   $0x1067a4
  10404f:	e8 13 c2 ff ff       	call   100267 <cprintf>
  104054:	83 c4 10             	add    $0x10,%esp
}
  104057:	90                   	nop
  104058:	8d 65 f4             	lea    -0xc(%ebp),%esp
  10405b:	5b                   	pop    %ebx
  10405c:	5e                   	pop    %esi
  10405d:	5f                   	pop    %edi
  10405e:	5d                   	pop    %ebp
  10405f:	c3                   	ret    

00104060 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  104060:	55                   	push   %ebp
  104061:	89 e5                	mov    %esp,%ebp
    return page - pages;
  104063:	8b 45 08             	mov    0x8(%ebp),%eax
  104066:	8b 15 58 89 11 00    	mov    0x118958,%edx
  10406c:	29 d0                	sub    %edx,%eax
  10406e:	c1 f8 02             	sar    $0x2,%eax
  104071:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  104077:	5d                   	pop    %ebp
  104078:	c3                   	ret    

00104079 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  104079:	55                   	push   %ebp
  10407a:	89 e5                	mov    %esp,%ebp
    return page2ppn(page) << PGSHIFT;
  10407c:	ff 75 08             	pushl  0x8(%ebp)
  10407f:	e8 dc ff ff ff       	call   104060 <page2ppn>
  104084:	83 c4 04             	add    $0x4,%esp
  104087:	c1 e0 0c             	shl    $0xc,%eax
}
  10408a:	c9                   	leave  
  10408b:	c3                   	ret    

0010408c <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  10408c:	55                   	push   %ebp
  10408d:	89 e5                	mov    %esp,%ebp
    return page->ref;
  10408f:	8b 45 08             	mov    0x8(%ebp),%eax
  104092:	8b 00                	mov    (%eax),%eax
}
  104094:	5d                   	pop    %ebp
  104095:	c3                   	ret    

00104096 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  104096:	55                   	push   %ebp
  104097:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  104099:	8b 45 08             	mov    0x8(%ebp),%eax
  10409c:	8b 55 0c             	mov    0xc(%ebp),%edx
  10409f:	89 10                	mov    %edx,(%eax)
}
  1040a1:	90                   	nop
  1040a2:	5d                   	pop    %ebp
  1040a3:	c3                   	ret    

001040a4 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
  1040a4:	55                   	push   %ebp
  1040a5:	89 e5                	mov    %esp,%ebp
  1040a7:	83 ec 10             	sub    $0x10,%esp
  1040aa:	c7 45 fc 5c 89 11 00 	movl   $0x11895c,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  1040b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1040b4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1040b7:	89 50 04             	mov    %edx,0x4(%eax)
  1040ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1040bd:	8b 50 04             	mov    0x4(%eax),%edx
  1040c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1040c3:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
  1040c5:	c7 05 64 89 11 00 00 	movl   $0x0,0x118964
  1040cc:	00 00 00 
}
  1040cf:	90                   	nop
  1040d0:	c9                   	leave  
  1040d1:	c3                   	ret    

001040d2 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
  1040d2:	55                   	push   %ebp
  1040d3:	89 e5                	mov    %esp,%ebp
  1040d5:	83 ec 38             	sub    $0x38,%esp
    assert(n > 0);
  1040d8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1040dc:	75 16                	jne    1040f4 <default_init_memmap+0x22>
  1040de:	68 d8 67 10 00       	push   $0x1067d8
  1040e3:	68 de 67 10 00       	push   $0x1067de
  1040e8:	6a 46                	push   $0x46
  1040ea:	68 f3 67 10 00       	push   $0x1067f3
  1040ef:	e8 d9 c2 ff ff       	call   1003cd <__panic>
    struct Page *p = base;
  1040f4:	8b 45 08             	mov    0x8(%ebp),%eax
  1040f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  1040fa:	e9 cb 00 00 00       	jmp    1041ca <default_init_memmap+0xf8>
        assert(PageReserved(p));    //测试page->flags的PG_reserved是否为1（即是否为unusable），不是即报错
  1040ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104102:	83 c0 04             	add    $0x4,%eax
  104105:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  10410c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10410f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104112:	8b 55 e8             	mov    -0x18(%ebp),%edx
  104115:	0f a3 10             	bt     %edx,(%eax)
  104118:	19 c0                	sbb    %eax,%eax
  10411a:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return oldbit != 0;
  10411d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  104121:	0f 95 c0             	setne  %al
  104124:	0f b6 c0             	movzbl %al,%eax
  104127:	85 c0                	test   %eax,%eax
  104129:	75 16                	jne    104141 <default_init_memmap+0x6f>
  10412b:	68 09 68 10 00       	push   $0x106809
  104130:	68 de 67 10 00       	push   $0x1067de
  104135:	6a 49                	push   $0x49
  104137:	68 f3 67 10 00       	push   $0x1067f3
  10413c:	e8 8c c2 ff ff       	call   1003cd <__panic>
        p->flags = 0;               //将flags置0，将PG_reserved改为0，变为usable
  104141:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104144:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        SetPageProperty(p);         //使page->property valid,从而设置其值
  10414b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10414e:	83 c0 04             	add    $0x4,%eax
  104151:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
  104158:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  10415b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  10415e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  104161:	0f ab 10             	bts    %edx,(%eax)
        p->property = 0;
  104164:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104167:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        set_page_ref(p, 0);
  10416e:	83 ec 08             	sub    $0x8,%esp
  104171:	6a 00                	push   $0x0
  104173:	ff 75 f4             	pushl  -0xc(%ebp)
  104176:	e8 1b ff ff ff       	call   104096 <set_page_ref>
  10417b:	83 c4 10             	add    $0x10,%esp
        list_add_before(&free_list, &(p->page_link));
  10417e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104181:	83 c0 0c             	add    $0xc,%eax
  104184:	c7 45 f0 5c 89 11 00 	movl   $0x11895c,-0x10(%ebp)
  10418b:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  10418e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104191:	8b 00                	mov    (%eax),%eax
  104193:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104196:	89 55 d8             	mov    %edx,-0x28(%ebp)
  104199:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  10419c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10419f:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  1041a2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1041a5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1041a8:	89 10                	mov    %edx,(%eax)
  1041aa:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1041ad:	8b 10                	mov    (%eax),%edx
  1041af:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1041b2:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  1041b5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1041b8:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1041bb:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  1041be:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1041c1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1041c4:	89 10                	mov    %edx,(%eax)

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
  1041c6:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  1041ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  1041cd:	89 d0                	mov    %edx,%eax
  1041cf:	c1 e0 02             	shl    $0x2,%eax
  1041d2:	01 d0                	add    %edx,%eax
  1041d4:	c1 e0 02             	shl    $0x2,%eax
  1041d7:	89 c2                	mov    %eax,%edx
  1041d9:	8b 45 08             	mov    0x8(%ebp),%eax
  1041dc:	01 d0                	add    %edx,%eax
  1041de:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1041e1:	0f 85 18 ff ff ff    	jne    1040ff <default_init_memmap+0x2d>
        SetPageProperty(p);         //使page->property valid,从而设置其值
        p->property = 0;
        set_page_ref(p, 0);
        list_add_before(&free_list, &(p->page_link));
    }
    nr_free += n;
  1041e7:	8b 15 64 89 11 00    	mov    0x118964,%edx
  1041ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  1041f0:	01 d0                	add    %edx,%eax
  1041f2:	a3 64 89 11 00       	mov    %eax,0x118964
    //第一个块
    base->property = n;
  1041f7:	8b 45 08             	mov    0x8(%ebp),%eax
  1041fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  1041fd:	89 50 08             	mov    %edx,0x8(%eax)
}
  104200:	90                   	nop
  104201:	c9                   	leave  
  104202:	c3                   	ret    

00104203 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
  104203:	55                   	push   %ebp
  104204:	89 e5                	mov    %esp,%ebp
  104206:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
  104209:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10420d:	75 16                	jne    104225 <default_alloc_pages+0x22>
  10420f:	68 d8 67 10 00       	push   $0x1067d8
  104214:	68 de 67 10 00       	push   $0x1067de
  104219:	6a 57                	push   $0x57
  10421b:	68 f3 67 10 00       	push   $0x1067f3
  104220:	e8 a8 c1 ff ff       	call   1003cd <__panic>
    if (n > nr_free) {
  104225:	a1 64 89 11 00       	mov    0x118964,%eax
  10422a:	3b 45 08             	cmp    0x8(%ebp),%eax
  10422d:	73 0a                	jae    104239 <default_alloc_pages+0x36>
        return NULL;
  10422f:	b8 00 00 00 00       	mov    $0x0,%eax
  104234:	e9 37 01 00 00       	jmp    104370 <default_alloc_pages+0x16d>
    }

    list_entry_t *le = &free_list;
  104239:	c7 45 f4 5c 89 11 00 	movl   $0x11895c,-0xc(%ebp)

    while ((le = list_next(le)) != &free_list) 
  104240:	e9 0a 01 00 00       	jmp    10434f <default_alloc_pages+0x14c>
    {
        struct Page *p = le2page(le, page_link);
  104245:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104248:	83 e8 0c             	sub    $0xc,%eax
  10424b:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) 
  10424e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104251:	8b 40 08             	mov    0x8(%eax),%eax
  104254:	3b 45 08             	cmp    0x8(%ebp),%eax
  104257:	0f 82 f2 00 00 00    	jb     10434f <default_alloc_pages+0x14c>
        {
            int i;
            list_entry_t *len;
            for(i = 0; i < n; i ++)
  10425d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  104264:	eb 7c                	jmp    1042e2 <default_alloc_pages+0xdf>
  104266:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104269:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  10426c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10426f:	8b 40 04             	mov    0x4(%eax),%eax
            {
                len = list_next(le);
  104272:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                struct Page *pp = le2page(le, page_link);
  104275:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104278:	83 e8 0c             	sub    $0xc,%eax
  10427b:	89 45 e0             	mov    %eax,-0x20(%ebp)
                SetPageReserved(pp);
  10427e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104281:	83 c0 04             	add    $0x4,%eax
  104284:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  10428b:	89 45 b8             	mov    %eax,-0x48(%ebp)
  10428e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  104291:	8b 55 d8             	mov    -0x28(%ebp),%edx
  104294:	0f ab 10             	bts    %edx,(%eax)
                ClearPageProperty(pp);
  104297:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10429a:	83 c0 04             	add    $0x4,%eax
  10429d:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  1042a4:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  1042a7:	8b 45 bc             	mov    -0x44(%ebp),%eax
  1042aa:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1042ad:	0f b3 10             	btr    %edx,(%eax)
  1042b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1042b3:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  1042b6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1042b9:	8b 40 04             	mov    0x4(%eax),%eax
  1042bc:	8b 55 c8             	mov    -0x38(%ebp),%edx
  1042bf:	8b 12                	mov    (%edx),%edx
  1042c1:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  1042c4:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  1042c7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1042ca:	8b 55 c0             	mov    -0x40(%ebp),%edx
  1042cd:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  1042d0:	8b 45 c0             	mov    -0x40(%ebp),%eax
  1042d3:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  1042d6:	89 10                	mov    %edx,(%eax)
                list_del(le);   //从free_list中删除le
                le = len;
  1042d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1042db:	89 45 f4             	mov    %eax,-0xc(%ebp)
        struct Page *p = le2page(le, page_link);
        if (p->property >= n) 
        {
            int i;
            list_entry_t *len;
            for(i = 0; i < n; i ++)
  1042de:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  1042e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1042e5:	3b 45 08             	cmp    0x8(%ebp),%eax
  1042e8:	0f 82 78 ff ff ff    	jb     104266 <default_alloc_pages+0x63>
                ClearPageProperty(pp);
                list_del(le);   //从free_list中删除le
                le = len;
            }

            if(p->property > n)
  1042ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1042f1:	8b 40 08             	mov    0x8(%eax),%eax
  1042f4:	3b 45 08             	cmp    0x8(%ebp),%eax
  1042f7:	76 12                	jbe    10430b <default_alloc_pages+0x108>
                (le2page(le,page_link))->property = p->property - n;
  1042f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1042fc:	8d 50 f4             	lea    -0xc(%eax),%edx
  1042ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104302:	8b 40 08             	mov    0x8(%eax),%eax
  104305:	2b 45 08             	sub    0x8(%ebp),%eax
  104308:	89 42 08             	mov    %eax,0x8(%edx)

            ClearPageProperty(p);
  10430b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10430e:	83 c0 04             	add    $0x4,%eax
  104311:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
  104318:	89 45 b0             	mov    %eax,-0x50(%ebp)
  10431b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  10431e:	8b 55 cc             	mov    -0x34(%ebp),%edx
  104321:	0f b3 10             	btr    %edx,(%eax)
            SetPageReserved(p);
  104324:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104327:	83 c0 04             	add    $0x4,%eax
  10432a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  104331:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104334:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  104337:	8b 55 e8             	mov    -0x18(%ebp),%edx
  10433a:	0f ab 10             	bts    %edx,(%eax)
            nr_free -= n;
  10433d:	a1 64 89 11 00       	mov    0x118964,%eax
  104342:	2b 45 08             	sub    0x8(%ebp),%eax
  104345:	a3 64 89 11 00       	mov    %eax,0x118964

            return p;   //返回分配内存的首地址
  10434a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10434d:	eb 21                	jmp    104370 <default_alloc_pages+0x16d>
  10434f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104352:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  104355:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104358:	8b 40 04             	mov    0x4(%eax),%eax
        return NULL;
    }

    list_entry_t *le = &free_list;

    while ((le = list_next(le)) != &free_list) 
  10435b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10435e:	81 7d f4 5c 89 11 00 	cmpl   $0x11895c,-0xc(%ebp)
  104365:	0f 85 da fe ff ff    	jne    104245 <default_alloc_pages+0x42>
            nr_free -= n;

            return p;   //返回分配内存的首地址
        }
    }
    return NULL;    //没有找到比n大的块
  10436b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  104370:	c9                   	leave  
  104371:	c3                   	ret    

00104372 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
  104372:	55                   	push   %ebp
  104373:	89 e5                	mov    %esp,%ebp
  104375:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
  104378:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10437c:	75 16                	jne    104394 <default_free_pages+0x22>
  10437e:	68 d8 67 10 00       	push   $0x1067d8
  104383:	68 de 67 10 00       	push   $0x1067de
  104388:	6a 7e                	push   $0x7e
  10438a:	68 f3 67 10 00       	push   $0x1067f3
  10438f:	e8 39 c0 ff ff       	call   1003cd <__panic>
    assert(PageReserved(base));
  104394:	8b 45 08             	mov    0x8(%ebp),%eax
  104397:	83 c0 04             	add    $0x4,%eax
  10439a:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  1043a1:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1043a4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1043a7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1043aa:	0f a3 10             	bt     %edx,(%eax)
  1043ad:	19 c0                	sbb    %eax,%eax
  1043af:	89 45 cc             	mov    %eax,-0x34(%ebp)
    return oldbit != 0;
  1043b2:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  1043b6:	0f 95 c0             	setne  %al
  1043b9:	0f b6 c0             	movzbl %al,%eax
  1043bc:	85 c0                	test   %eax,%eax
  1043be:	75 16                	jne    1043d6 <default_free_pages+0x64>
  1043c0:	68 19 68 10 00       	push   $0x106819
  1043c5:	68 de 67 10 00       	push   $0x1067de
  1043ca:	6a 7f                	push   $0x7f
  1043cc:	68 f3 67 10 00       	push   $0x1067f3
  1043d1:	e8 f7 bf ff ff       	call   1003cd <__panic>

    list_entry_t *le = &free_list;
  1043d6:	c7 45 f4 5c 89 11 00 	movl   $0x11895c,-0xc(%ebp)
    struct Page *p;
    while((le = list_next(le)) != &free_list)
  1043dd:	eb 11                	jmp    1043f0 <default_free_pages+0x7e>
    {
            p = le2page(le, page_link);
  1043df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1043e2:	83 e8 0c             	sub    $0xc,%eax
  1043e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
            if(p > base)
  1043e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1043eb:	3b 45 08             	cmp    0x8(%ebp),%eax
  1043ee:	77 1a                	ja     10440a <default_free_pages+0x98>
  1043f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1043f3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1043f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1043f9:	8b 40 04             	mov    0x4(%eax),%eax
    assert(n > 0);
    assert(PageReserved(base));

    list_entry_t *le = &free_list;
    struct Page *p;
    while((le = list_next(le)) != &free_list)
  1043fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1043ff:	81 7d f4 5c 89 11 00 	cmpl   $0x11895c,-0xc(%ebp)
  104406:	75 d7                	jne    1043df <default_free_pages+0x6d>
  104408:	eb 01                	jmp    10440b <default_free_pages+0x99>
    {
            p = le2page(le, page_link);
            if(p > base)
                    break;  //找到回收位置
  10440a:	90                   	nop
    }

    //插入
    for(p = base; p < base + n; p ++)
  10440b:	8b 45 08             	mov    0x8(%ebp),%eax
  10440e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104411:	eb 4b                	jmp    10445e <default_free_pages+0xec>
    {
            list_add_before(le, &(p->page_link));
  104413:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104416:	8d 50 0c             	lea    0xc(%eax),%edx
  104419:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10441c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10441f:	89 55 c8             	mov    %edx,-0x38(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  104422:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104425:	8b 00                	mov    (%eax),%eax
  104427:	8b 55 c8             	mov    -0x38(%ebp),%edx
  10442a:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  10442d:	89 45 c0             	mov    %eax,-0x40(%ebp)
  104430:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104433:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  104436:	8b 45 bc             	mov    -0x44(%ebp),%eax
  104439:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  10443c:	89 10                	mov    %edx,(%eax)
  10443e:	8b 45 bc             	mov    -0x44(%ebp),%eax
  104441:	8b 10                	mov    (%eax),%edx
  104443:	8b 45 c0             	mov    -0x40(%ebp),%eax
  104446:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  104449:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  10444c:	8b 55 bc             	mov    -0x44(%ebp),%edx
  10444f:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  104452:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104455:	8b 55 c0             	mov    -0x40(%ebp),%edx
  104458:	89 10                	mov    %edx,(%eax)
            if(p > base)
                    break;  //找到回收位置
    }

    //插入
    for(p = base; p < base + n; p ++)
  10445a:	83 45 f0 14          	addl   $0x14,-0x10(%ebp)
  10445e:	8b 55 0c             	mov    0xc(%ebp),%edx
  104461:	89 d0                	mov    %edx,%eax
  104463:	c1 e0 02             	shl    $0x2,%eax
  104466:	01 d0                	add    %edx,%eax
  104468:	c1 e0 02             	shl    $0x2,%eax
  10446b:	89 c2                	mov    %eax,%edx
  10446d:	8b 45 08             	mov    0x8(%ebp),%eax
  104470:	01 d0                	add    %edx,%eax
  104472:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  104475:	77 9c                	ja     104413 <default_free_pages+0xa1>
    {
            list_add_before(le, &(p->page_link));
    }

    //重置pages,flags和refs
    base->flags = 0;
  104477:	8b 45 08             	mov    0x8(%ebp),%eax
  10447a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    set_page_ref(base, 0);
  104481:	83 ec 08             	sub    $0x8,%esp
  104484:	6a 00                	push   $0x0
  104486:	ff 75 08             	pushl  0x8(%ebp)
  104489:	e8 08 fc ff ff       	call   104096 <set_page_ref>
  10448e:	83 c4 10             	add    $0x10,%esp
    ClearPageProperty(base);
  104491:	8b 45 08             	mov    0x8(%ebp),%eax
  104494:	83 c0 04             	add    $0x4,%eax
  104497:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
  10449e:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  1044a1:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1044a4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1044a7:	0f b3 10             	btr    %edx,(%eax)
    SetPageProperty(base);
  1044aa:	8b 45 08             	mov    0x8(%ebp),%eax
  1044ad:	83 c0 04             	add    $0x4,%eax
  1044b0:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  1044b7:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  1044ba:	8b 45 b8             	mov    -0x48(%ebp),%eax
  1044bd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1044c0:	0f ab 10             	bts    %edx,(%eax)
    base->property = n;
  1044c3:	8b 45 08             	mov    0x8(%ebp),%eax
  1044c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  1044c9:	89 50 08             	mov    %edx,0x8(%eax)
    
    //测试是否可与高位合并
    p = le2page(le, page_link);
  1044cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1044cf:	83 e8 0c             	sub    $0xc,%eax
  1044d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((base + n) == p)     //可合并
  1044d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  1044d8:	89 d0                	mov    %edx,%eax
  1044da:	c1 e0 02             	shl    $0x2,%eax
  1044dd:	01 d0                	add    %edx,%eax
  1044df:	c1 e0 02             	shl    $0x2,%eax
  1044e2:	89 c2                	mov    %eax,%edx
  1044e4:	8b 45 08             	mov    0x8(%ebp),%eax
  1044e7:	01 d0                	add    %edx,%eax
  1044e9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  1044ec:	75 1e                	jne    10450c <default_free_pages+0x19a>
    {
            base->property += p->property;
  1044ee:	8b 45 08             	mov    0x8(%ebp),%eax
  1044f1:	8b 50 08             	mov    0x8(%eax),%edx
  1044f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1044f7:	8b 40 08             	mov    0x8(%eax),%eax
  1044fa:	01 c2                	add    %eax,%edx
  1044fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1044ff:	89 50 08             	mov    %edx,0x8(%eax)
            p->property = 0;
  104502:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104505:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    }

    //测试是否可与低位合并
    le = list_prev((&(base->page_link)));
  10450c:	8b 45 08             	mov    0x8(%ebp),%eax
  10450f:	83 c0 0c             	add    $0xc,%eax
  104512:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
  104515:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104518:	8b 00                	mov    (%eax),%eax
  10451a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    p = le2page(le, page_link);
  10451d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104520:	83 e8 0c             	sub    $0xc,%eax
  104523:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(le != &free_list && p == base - 1)
  104526:	81 7d f4 5c 89 11 00 	cmpl   $0x11895c,-0xc(%ebp)
  10452d:	74 57                	je     104586 <default_free_pages+0x214>
  10452f:	8b 45 08             	mov    0x8(%ebp),%eax
  104532:	83 e8 14             	sub    $0x14,%eax
  104535:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  104538:	75 4c                	jne    104586 <default_free_pages+0x214>
    {
            while(le != &free_list)
  10453a:	eb 41                	jmp    10457d <default_free_pages+0x20b>
            {
                    if(p->property)     //可合并
  10453c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10453f:	8b 40 08             	mov    0x8(%eax),%eax
  104542:	85 c0                	test   %eax,%eax
  104544:	74 20                	je     104566 <default_free_pages+0x1f4>
                    {
                            p->property += base->property;
  104546:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104549:	8b 50 08             	mov    0x8(%eax),%edx
  10454c:	8b 45 08             	mov    0x8(%ebp),%eax
  10454f:	8b 40 08             	mov    0x8(%eax),%eax
  104552:	01 c2                	add    %eax,%edx
  104554:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104557:	89 50 08             	mov    %edx,0x8(%eax)
                            base->property = 0;
  10455a:	8b 45 08             	mov    0x8(%ebp),%eax
  10455d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
                            break;
  104564:	eb 20                	jmp    104586 <default_free_pages+0x214>
  104566:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104569:	89 45 d8             	mov    %eax,-0x28(%ebp)
  10456c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10456f:	8b 00                	mov    (%eax),%eax
                    }
            le = list_prev(le);
  104571:	89 45 f4             	mov    %eax,-0xc(%ebp)
            p = le2page(le, page_link);
  104574:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104577:	83 e8 0c             	sub    $0xc,%eax
  10457a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    //测试是否可与低位合并
    le = list_prev((&(base->page_link)));
    p = le2page(le, page_link);
    if(le != &free_list && p == base - 1)
    {
            while(le != &free_list)
  10457d:	81 7d f4 5c 89 11 00 	cmpl   $0x11895c,-0xc(%ebp)
  104584:	75 b6                	jne    10453c <default_free_pages+0x1ca>
            le = list_prev(le);
            p = le2page(le, page_link);
            }
    }

    nr_free += n;
  104586:	8b 15 64 89 11 00    	mov    0x118964,%edx
  10458c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10458f:	01 d0                	add    %edx,%eax
  104591:	a3 64 89 11 00       	mov    %eax,0x118964
    return ;
  104596:	90                   	nop

}
  104597:	c9                   	leave  
  104598:	c3                   	ret    

00104599 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
  104599:	55                   	push   %ebp
  10459a:	89 e5                	mov    %esp,%ebp
    return nr_free;
  10459c:	a1 64 89 11 00       	mov    0x118964,%eax
}
  1045a1:	5d                   	pop    %ebp
  1045a2:	c3                   	ret    

001045a3 <basic_check>:

static void
basic_check(void) {
  1045a3:	55                   	push   %ebp
  1045a4:	89 e5                	mov    %esp,%ebp
  1045a6:	83 ec 38             	sub    $0x38,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  1045a9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1045b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1045b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1045b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1045b9:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
  1045bc:	83 ec 0c             	sub    $0xc,%esp
  1045bf:	6a 01                	push   $0x1
  1045c1:	e8 e0 e5 ff ff       	call   102ba6 <alloc_pages>
  1045c6:	83 c4 10             	add    $0x10,%esp
  1045c9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1045cc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  1045d0:	75 19                	jne    1045eb <basic_check+0x48>
  1045d2:	68 2c 68 10 00       	push   $0x10682c
  1045d7:	68 de 67 10 00       	push   $0x1067de
  1045dc:	68 bf 00 00 00       	push   $0xbf
  1045e1:	68 f3 67 10 00       	push   $0x1067f3
  1045e6:	e8 e2 bd ff ff       	call   1003cd <__panic>
    assert((p1 = alloc_page()) != NULL);
  1045eb:	83 ec 0c             	sub    $0xc,%esp
  1045ee:	6a 01                	push   $0x1
  1045f0:	e8 b1 e5 ff ff       	call   102ba6 <alloc_pages>
  1045f5:	83 c4 10             	add    $0x10,%esp
  1045f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1045fb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1045ff:	75 19                	jne    10461a <basic_check+0x77>
  104601:	68 48 68 10 00       	push   $0x106848
  104606:	68 de 67 10 00       	push   $0x1067de
  10460b:	68 c0 00 00 00       	push   $0xc0
  104610:	68 f3 67 10 00       	push   $0x1067f3
  104615:	e8 b3 bd ff ff       	call   1003cd <__panic>
    assert((p2 = alloc_page()) != NULL);
  10461a:	83 ec 0c             	sub    $0xc,%esp
  10461d:	6a 01                	push   $0x1
  10461f:	e8 82 e5 ff ff       	call   102ba6 <alloc_pages>
  104624:	83 c4 10             	add    $0x10,%esp
  104627:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10462a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10462e:	75 19                	jne    104649 <basic_check+0xa6>
  104630:	68 64 68 10 00       	push   $0x106864
  104635:	68 de 67 10 00       	push   $0x1067de
  10463a:	68 c1 00 00 00       	push   $0xc1
  10463f:	68 f3 67 10 00       	push   $0x1067f3
  104644:	e8 84 bd ff ff       	call   1003cd <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  104649:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10464c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  10464f:	74 10                	je     104661 <basic_check+0xbe>
  104651:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104654:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104657:	74 08                	je     104661 <basic_check+0xbe>
  104659:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10465c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  10465f:	75 19                	jne    10467a <basic_check+0xd7>
  104661:	68 80 68 10 00       	push   $0x106880
  104666:	68 de 67 10 00       	push   $0x1067de
  10466b:	68 c3 00 00 00       	push   $0xc3
  104670:	68 f3 67 10 00       	push   $0x1067f3
  104675:	e8 53 bd ff ff       	call   1003cd <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  10467a:	83 ec 0c             	sub    $0xc,%esp
  10467d:	ff 75 ec             	pushl  -0x14(%ebp)
  104680:	e8 07 fa ff ff       	call   10408c <page_ref>
  104685:	83 c4 10             	add    $0x10,%esp
  104688:	85 c0                	test   %eax,%eax
  10468a:	75 24                	jne    1046b0 <basic_check+0x10d>
  10468c:	83 ec 0c             	sub    $0xc,%esp
  10468f:	ff 75 f0             	pushl  -0x10(%ebp)
  104692:	e8 f5 f9 ff ff       	call   10408c <page_ref>
  104697:	83 c4 10             	add    $0x10,%esp
  10469a:	85 c0                	test   %eax,%eax
  10469c:	75 12                	jne    1046b0 <basic_check+0x10d>
  10469e:	83 ec 0c             	sub    $0xc,%esp
  1046a1:	ff 75 f4             	pushl  -0xc(%ebp)
  1046a4:	e8 e3 f9 ff ff       	call   10408c <page_ref>
  1046a9:	83 c4 10             	add    $0x10,%esp
  1046ac:	85 c0                	test   %eax,%eax
  1046ae:	74 19                	je     1046c9 <basic_check+0x126>
  1046b0:	68 a4 68 10 00       	push   $0x1068a4
  1046b5:	68 de 67 10 00       	push   $0x1067de
  1046ba:	68 c4 00 00 00       	push   $0xc4
  1046bf:	68 f3 67 10 00       	push   $0x1067f3
  1046c4:	e8 04 bd ff ff       	call   1003cd <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  1046c9:	83 ec 0c             	sub    $0xc,%esp
  1046cc:	ff 75 ec             	pushl  -0x14(%ebp)
  1046cf:	e8 a5 f9 ff ff       	call   104079 <page2pa>
  1046d4:	83 c4 10             	add    $0x10,%esp
  1046d7:	89 c2                	mov    %eax,%edx
  1046d9:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  1046de:	c1 e0 0c             	shl    $0xc,%eax
  1046e1:	39 c2                	cmp    %eax,%edx
  1046e3:	72 19                	jb     1046fe <basic_check+0x15b>
  1046e5:	68 e0 68 10 00       	push   $0x1068e0
  1046ea:	68 de 67 10 00       	push   $0x1067de
  1046ef:	68 c6 00 00 00       	push   $0xc6
  1046f4:	68 f3 67 10 00       	push   $0x1067f3
  1046f9:	e8 cf bc ff ff       	call   1003cd <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  1046fe:	83 ec 0c             	sub    $0xc,%esp
  104701:	ff 75 f0             	pushl  -0x10(%ebp)
  104704:	e8 70 f9 ff ff       	call   104079 <page2pa>
  104709:	83 c4 10             	add    $0x10,%esp
  10470c:	89 c2                	mov    %eax,%edx
  10470e:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104713:	c1 e0 0c             	shl    $0xc,%eax
  104716:	39 c2                	cmp    %eax,%edx
  104718:	72 19                	jb     104733 <basic_check+0x190>
  10471a:	68 fd 68 10 00       	push   $0x1068fd
  10471f:	68 de 67 10 00       	push   $0x1067de
  104724:	68 c7 00 00 00       	push   $0xc7
  104729:	68 f3 67 10 00       	push   $0x1067f3
  10472e:	e8 9a bc ff ff       	call   1003cd <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  104733:	83 ec 0c             	sub    $0xc,%esp
  104736:	ff 75 f4             	pushl  -0xc(%ebp)
  104739:	e8 3b f9 ff ff       	call   104079 <page2pa>
  10473e:	83 c4 10             	add    $0x10,%esp
  104741:	89 c2                	mov    %eax,%edx
  104743:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104748:	c1 e0 0c             	shl    $0xc,%eax
  10474b:	39 c2                	cmp    %eax,%edx
  10474d:	72 19                	jb     104768 <basic_check+0x1c5>
  10474f:	68 1a 69 10 00       	push   $0x10691a
  104754:	68 de 67 10 00       	push   $0x1067de
  104759:	68 c8 00 00 00       	push   $0xc8
  10475e:	68 f3 67 10 00       	push   $0x1067f3
  104763:	e8 65 bc ff ff       	call   1003cd <__panic>

    list_entry_t free_list_store = free_list;
  104768:	a1 5c 89 11 00       	mov    0x11895c,%eax
  10476d:	8b 15 60 89 11 00    	mov    0x118960,%edx
  104773:	89 45 d0             	mov    %eax,-0x30(%ebp)
  104776:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  104779:	c7 45 e4 5c 89 11 00 	movl   $0x11895c,-0x1c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  104780:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104783:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104786:	89 50 04             	mov    %edx,0x4(%eax)
  104789:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10478c:	8b 50 04             	mov    0x4(%eax),%edx
  10478f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104792:	89 10                	mov    %edx,(%eax)
  104794:	c7 45 d8 5c 89 11 00 	movl   $0x11895c,-0x28(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  10479b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10479e:	8b 40 04             	mov    0x4(%eax),%eax
  1047a1:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  1047a4:	0f 94 c0             	sete   %al
  1047a7:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  1047aa:	85 c0                	test   %eax,%eax
  1047ac:	75 19                	jne    1047c7 <basic_check+0x224>
  1047ae:	68 37 69 10 00       	push   $0x106937
  1047b3:	68 de 67 10 00       	push   $0x1067de
  1047b8:	68 cc 00 00 00       	push   $0xcc
  1047bd:	68 f3 67 10 00       	push   $0x1067f3
  1047c2:	e8 06 bc ff ff       	call   1003cd <__panic>

    unsigned int nr_free_store = nr_free;
  1047c7:	a1 64 89 11 00       	mov    0x118964,%eax
  1047cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
  1047cf:	c7 05 64 89 11 00 00 	movl   $0x0,0x118964
  1047d6:	00 00 00 

    assert(alloc_page() == NULL);
  1047d9:	83 ec 0c             	sub    $0xc,%esp
  1047dc:	6a 01                	push   $0x1
  1047de:	e8 c3 e3 ff ff       	call   102ba6 <alloc_pages>
  1047e3:	83 c4 10             	add    $0x10,%esp
  1047e6:	85 c0                	test   %eax,%eax
  1047e8:	74 19                	je     104803 <basic_check+0x260>
  1047ea:	68 4e 69 10 00       	push   $0x10694e
  1047ef:	68 de 67 10 00       	push   $0x1067de
  1047f4:	68 d1 00 00 00       	push   $0xd1
  1047f9:	68 f3 67 10 00       	push   $0x1067f3
  1047fe:	e8 ca bb ff ff       	call   1003cd <__panic>

    free_page(p0);
  104803:	83 ec 08             	sub    $0x8,%esp
  104806:	6a 01                	push   $0x1
  104808:	ff 75 ec             	pushl  -0x14(%ebp)
  10480b:	e8 d4 e3 ff ff       	call   102be4 <free_pages>
  104810:	83 c4 10             	add    $0x10,%esp
    free_page(p1);
  104813:	83 ec 08             	sub    $0x8,%esp
  104816:	6a 01                	push   $0x1
  104818:	ff 75 f0             	pushl  -0x10(%ebp)
  10481b:	e8 c4 e3 ff ff       	call   102be4 <free_pages>
  104820:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
  104823:	83 ec 08             	sub    $0x8,%esp
  104826:	6a 01                	push   $0x1
  104828:	ff 75 f4             	pushl  -0xc(%ebp)
  10482b:	e8 b4 e3 ff ff       	call   102be4 <free_pages>
  104830:	83 c4 10             	add    $0x10,%esp
    assert(nr_free == 3);
  104833:	a1 64 89 11 00       	mov    0x118964,%eax
  104838:	83 f8 03             	cmp    $0x3,%eax
  10483b:	74 19                	je     104856 <basic_check+0x2b3>
  10483d:	68 63 69 10 00       	push   $0x106963
  104842:	68 de 67 10 00       	push   $0x1067de
  104847:	68 d6 00 00 00       	push   $0xd6
  10484c:	68 f3 67 10 00       	push   $0x1067f3
  104851:	e8 77 bb ff ff       	call   1003cd <__panic>

    assert((p0 = alloc_page()) != NULL);
  104856:	83 ec 0c             	sub    $0xc,%esp
  104859:	6a 01                	push   $0x1
  10485b:	e8 46 e3 ff ff       	call   102ba6 <alloc_pages>
  104860:	83 c4 10             	add    $0x10,%esp
  104863:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104866:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  10486a:	75 19                	jne    104885 <basic_check+0x2e2>
  10486c:	68 2c 68 10 00       	push   $0x10682c
  104871:	68 de 67 10 00       	push   $0x1067de
  104876:	68 d8 00 00 00       	push   $0xd8
  10487b:	68 f3 67 10 00       	push   $0x1067f3
  104880:	e8 48 bb ff ff       	call   1003cd <__panic>
    assert((p1 = alloc_page()) != NULL);
  104885:	83 ec 0c             	sub    $0xc,%esp
  104888:	6a 01                	push   $0x1
  10488a:	e8 17 e3 ff ff       	call   102ba6 <alloc_pages>
  10488f:	83 c4 10             	add    $0x10,%esp
  104892:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104895:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104899:	75 19                	jne    1048b4 <basic_check+0x311>
  10489b:	68 48 68 10 00       	push   $0x106848
  1048a0:	68 de 67 10 00       	push   $0x1067de
  1048a5:	68 d9 00 00 00       	push   $0xd9
  1048aa:	68 f3 67 10 00       	push   $0x1067f3
  1048af:	e8 19 bb ff ff       	call   1003cd <__panic>
    assert((p2 = alloc_page()) != NULL);
  1048b4:	83 ec 0c             	sub    $0xc,%esp
  1048b7:	6a 01                	push   $0x1
  1048b9:	e8 e8 e2 ff ff       	call   102ba6 <alloc_pages>
  1048be:	83 c4 10             	add    $0x10,%esp
  1048c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1048c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1048c8:	75 19                	jne    1048e3 <basic_check+0x340>
  1048ca:	68 64 68 10 00       	push   $0x106864
  1048cf:	68 de 67 10 00       	push   $0x1067de
  1048d4:	68 da 00 00 00       	push   $0xda
  1048d9:	68 f3 67 10 00       	push   $0x1067f3
  1048de:	e8 ea ba ff ff       	call   1003cd <__panic>

    assert(alloc_page() == NULL);
  1048e3:	83 ec 0c             	sub    $0xc,%esp
  1048e6:	6a 01                	push   $0x1
  1048e8:	e8 b9 e2 ff ff       	call   102ba6 <alloc_pages>
  1048ed:	83 c4 10             	add    $0x10,%esp
  1048f0:	85 c0                	test   %eax,%eax
  1048f2:	74 19                	je     10490d <basic_check+0x36a>
  1048f4:	68 4e 69 10 00       	push   $0x10694e
  1048f9:	68 de 67 10 00       	push   $0x1067de
  1048fe:	68 dc 00 00 00       	push   $0xdc
  104903:	68 f3 67 10 00       	push   $0x1067f3
  104908:	e8 c0 ba ff ff       	call   1003cd <__panic>

    free_page(p0);
  10490d:	83 ec 08             	sub    $0x8,%esp
  104910:	6a 01                	push   $0x1
  104912:	ff 75 ec             	pushl  -0x14(%ebp)
  104915:	e8 ca e2 ff ff       	call   102be4 <free_pages>
  10491a:	83 c4 10             	add    $0x10,%esp
  10491d:	c7 45 e8 5c 89 11 00 	movl   $0x11895c,-0x18(%ebp)
  104924:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104927:	8b 40 04             	mov    0x4(%eax),%eax
  10492a:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  10492d:	0f 94 c0             	sete   %al
  104930:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
  104933:	85 c0                	test   %eax,%eax
  104935:	74 19                	je     104950 <basic_check+0x3ad>
  104937:	68 70 69 10 00       	push   $0x106970
  10493c:	68 de 67 10 00       	push   $0x1067de
  104941:	68 df 00 00 00       	push   $0xdf
  104946:	68 f3 67 10 00       	push   $0x1067f3
  10494b:	e8 7d ba ff ff       	call   1003cd <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
  104950:	83 ec 0c             	sub    $0xc,%esp
  104953:	6a 01                	push   $0x1
  104955:	e8 4c e2 ff ff       	call   102ba6 <alloc_pages>
  10495a:	83 c4 10             	add    $0x10,%esp
  10495d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  104960:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104963:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  104966:	74 19                	je     104981 <basic_check+0x3de>
  104968:	68 88 69 10 00       	push   $0x106988
  10496d:	68 de 67 10 00       	push   $0x1067de
  104972:	68 e2 00 00 00       	push   $0xe2
  104977:	68 f3 67 10 00       	push   $0x1067f3
  10497c:	e8 4c ba ff ff       	call   1003cd <__panic>
    assert(alloc_page() == NULL);
  104981:	83 ec 0c             	sub    $0xc,%esp
  104984:	6a 01                	push   $0x1
  104986:	e8 1b e2 ff ff       	call   102ba6 <alloc_pages>
  10498b:	83 c4 10             	add    $0x10,%esp
  10498e:	85 c0                	test   %eax,%eax
  104990:	74 19                	je     1049ab <basic_check+0x408>
  104992:	68 4e 69 10 00       	push   $0x10694e
  104997:	68 de 67 10 00       	push   $0x1067de
  10499c:	68 e3 00 00 00       	push   $0xe3
  1049a1:	68 f3 67 10 00       	push   $0x1067f3
  1049a6:	e8 22 ba ff ff       	call   1003cd <__panic>

    assert(nr_free == 0);
  1049ab:	a1 64 89 11 00       	mov    0x118964,%eax
  1049b0:	85 c0                	test   %eax,%eax
  1049b2:	74 19                	je     1049cd <basic_check+0x42a>
  1049b4:	68 a1 69 10 00       	push   $0x1069a1
  1049b9:	68 de 67 10 00       	push   $0x1067de
  1049be:	68 e5 00 00 00       	push   $0xe5
  1049c3:	68 f3 67 10 00       	push   $0x1067f3
  1049c8:	e8 00 ba ff ff       	call   1003cd <__panic>
    free_list = free_list_store;
  1049cd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1049d0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1049d3:	a3 5c 89 11 00       	mov    %eax,0x11895c
  1049d8:	89 15 60 89 11 00    	mov    %edx,0x118960
    nr_free = nr_free_store;
  1049de:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1049e1:	a3 64 89 11 00       	mov    %eax,0x118964

    free_page(p);
  1049e6:	83 ec 08             	sub    $0x8,%esp
  1049e9:	6a 01                	push   $0x1
  1049eb:	ff 75 dc             	pushl  -0x24(%ebp)
  1049ee:	e8 f1 e1 ff ff       	call   102be4 <free_pages>
  1049f3:	83 c4 10             	add    $0x10,%esp
    free_page(p1);
  1049f6:	83 ec 08             	sub    $0x8,%esp
  1049f9:	6a 01                	push   $0x1
  1049fb:	ff 75 f0             	pushl  -0x10(%ebp)
  1049fe:	e8 e1 e1 ff ff       	call   102be4 <free_pages>
  104a03:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
  104a06:	83 ec 08             	sub    $0x8,%esp
  104a09:	6a 01                	push   $0x1
  104a0b:	ff 75 f4             	pushl  -0xc(%ebp)
  104a0e:	e8 d1 e1 ff ff       	call   102be4 <free_pages>
  104a13:	83 c4 10             	add    $0x10,%esp
}
  104a16:	90                   	nop
  104a17:	c9                   	leave  
  104a18:	c3                   	ret    

00104a19 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
  104a19:	55                   	push   %ebp
  104a1a:	89 e5                	mov    %esp,%ebp
  104a1c:	81 ec 88 00 00 00    	sub    $0x88,%esp
    int count = 0, total = 0;
  104a22:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104a29:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  104a30:	c7 45 ec 5c 89 11 00 	movl   $0x11895c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  104a37:	eb 60                	jmp    104a99 <default_check+0x80>
        struct Page *p = le2page(le, page_link);
  104a39:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104a3c:	83 e8 0c             	sub    $0xc,%eax
  104a3f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        assert(PageProperty(p));
  104a42:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104a45:	83 c0 04             	add    $0x4,%eax
  104a48:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
  104a4f:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104a52:	8b 45 ac             	mov    -0x54(%ebp),%eax
  104a55:	8b 55 b0             	mov    -0x50(%ebp),%edx
  104a58:	0f a3 10             	bt     %edx,(%eax)
  104a5b:	19 c0                	sbb    %eax,%eax
  104a5d:	89 45 a8             	mov    %eax,-0x58(%ebp)
    return oldbit != 0;
  104a60:	83 7d a8 00          	cmpl   $0x0,-0x58(%ebp)
  104a64:	0f 95 c0             	setne  %al
  104a67:	0f b6 c0             	movzbl %al,%eax
  104a6a:	85 c0                	test   %eax,%eax
  104a6c:	75 19                	jne    104a87 <default_check+0x6e>
  104a6e:	68 ae 69 10 00       	push   $0x1069ae
  104a73:	68 de 67 10 00       	push   $0x1067de
  104a78:	68 f6 00 00 00       	push   $0xf6
  104a7d:	68 f3 67 10 00       	push   $0x1067f3
  104a82:	e8 46 b9 ff ff       	call   1003cd <__panic>
        count ++, total += p->property;
  104a87:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  104a8b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104a8e:	8b 50 08             	mov    0x8(%eax),%edx
  104a91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104a94:	01 d0                	add    %edx,%eax
  104a96:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104a99:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104a9c:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  104a9f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104aa2:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  104aa5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104aa8:	81 7d ec 5c 89 11 00 	cmpl   $0x11895c,-0x14(%ebp)
  104aaf:	75 88                	jne    104a39 <default_check+0x20>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
  104ab1:	e8 63 e1 ff ff       	call   102c19 <nr_free_pages>
  104ab6:	89 c2                	mov    %eax,%edx
  104ab8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104abb:	39 c2                	cmp    %eax,%edx
  104abd:	74 19                	je     104ad8 <default_check+0xbf>
  104abf:	68 be 69 10 00       	push   $0x1069be
  104ac4:	68 de 67 10 00       	push   $0x1067de
  104ac9:	68 f9 00 00 00       	push   $0xf9
  104ace:	68 f3 67 10 00       	push   $0x1067f3
  104ad3:	e8 f5 b8 ff ff       	call   1003cd <__panic>

    basic_check();
  104ad8:	e8 c6 fa ff ff       	call   1045a3 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
  104add:	83 ec 0c             	sub    $0xc,%esp
  104ae0:	6a 05                	push   $0x5
  104ae2:	e8 bf e0 ff ff       	call   102ba6 <alloc_pages>
  104ae7:	83 c4 10             	add    $0x10,%esp
  104aea:	89 45 dc             	mov    %eax,-0x24(%ebp)
    assert(p0 != NULL);
  104aed:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  104af1:	75 19                	jne    104b0c <default_check+0xf3>
  104af3:	68 d7 69 10 00       	push   $0x1069d7
  104af8:	68 de 67 10 00       	push   $0x1067de
  104afd:	68 fe 00 00 00       	push   $0xfe
  104b02:	68 f3 67 10 00       	push   $0x1067f3
  104b07:	e8 c1 b8 ff ff       	call   1003cd <__panic>
    assert(!PageProperty(p0));
  104b0c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104b0f:	83 c0 04             	add    $0x4,%eax
  104b12:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
  104b19:	89 45 a4             	mov    %eax,-0x5c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104b1c:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  104b1f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  104b22:	0f a3 10             	bt     %edx,(%eax)
  104b25:	19 c0                	sbb    %eax,%eax
  104b27:	89 45 a0             	mov    %eax,-0x60(%ebp)
    return oldbit != 0;
  104b2a:	83 7d a0 00          	cmpl   $0x0,-0x60(%ebp)
  104b2e:	0f 95 c0             	setne  %al
  104b31:	0f b6 c0             	movzbl %al,%eax
  104b34:	85 c0                	test   %eax,%eax
  104b36:	74 19                	je     104b51 <default_check+0x138>
  104b38:	68 e2 69 10 00       	push   $0x1069e2
  104b3d:	68 de 67 10 00       	push   $0x1067de
  104b42:	68 ff 00 00 00       	push   $0xff
  104b47:	68 f3 67 10 00       	push   $0x1067f3
  104b4c:	e8 7c b8 ff ff       	call   1003cd <__panic>

    list_entry_t free_list_store = free_list;
  104b51:	a1 5c 89 11 00       	mov    0x11895c,%eax
  104b56:	8b 15 60 89 11 00    	mov    0x118960,%edx
  104b5c:	89 45 80             	mov    %eax,-0x80(%ebp)
  104b5f:	89 55 84             	mov    %edx,-0x7c(%ebp)
  104b62:	c7 45 d0 5c 89 11 00 	movl   $0x11895c,-0x30(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  104b69:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104b6c:	8b 55 d0             	mov    -0x30(%ebp),%edx
  104b6f:	89 50 04             	mov    %edx,0x4(%eax)
  104b72:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104b75:	8b 50 04             	mov    0x4(%eax),%edx
  104b78:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104b7b:	89 10                	mov    %edx,(%eax)
  104b7d:	c7 45 d8 5c 89 11 00 	movl   $0x11895c,-0x28(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  104b84:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104b87:	8b 40 04             	mov    0x4(%eax),%eax
  104b8a:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  104b8d:	0f 94 c0             	sete   %al
  104b90:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  104b93:	85 c0                	test   %eax,%eax
  104b95:	75 19                	jne    104bb0 <default_check+0x197>
  104b97:	68 37 69 10 00       	push   $0x106937
  104b9c:	68 de 67 10 00       	push   $0x1067de
  104ba1:	68 03 01 00 00       	push   $0x103
  104ba6:	68 f3 67 10 00       	push   $0x1067f3
  104bab:	e8 1d b8 ff ff       	call   1003cd <__panic>
    assert(alloc_page() == NULL);
  104bb0:	83 ec 0c             	sub    $0xc,%esp
  104bb3:	6a 01                	push   $0x1
  104bb5:	e8 ec df ff ff       	call   102ba6 <alloc_pages>
  104bba:	83 c4 10             	add    $0x10,%esp
  104bbd:	85 c0                	test   %eax,%eax
  104bbf:	74 19                	je     104bda <default_check+0x1c1>
  104bc1:	68 4e 69 10 00       	push   $0x10694e
  104bc6:	68 de 67 10 00       	push   $0x1067de
  104bcb:	68 04 01 00 00       	push   $0x104
  104bd0:	68 f3 67 10 00       	push   $0x1067f3
  104bd5:	e8 f3 b7 ff ff       	call   1003cd <__panic>

    unsigned int nr_free_store = nr_free;
  104bda:	a1 64 89 11 00       	mov    0x118964,%eax
  104bdf:	89 45 cc             	mov    %eax,-0x34(%ebp)
    nr_free = 0;
  104be2:	c7 05 64 89 11 00 00 	movl   $0x0,0x118964
  104be9:	00 00 00 

    free_pages(p0 + 2, 3);
  104bec:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104bef:	83 c0 28             	add    $0x28,%eax
  104bf2:	83 ec 08             	sub    $0x8,%esp
  104bf5:	6a 03                	push   $0x3
  104bf7:	50                   	push   %eax
  104bf8:	e8 e7 df ff ff       	call   102be4 <free_pages>
  104bfd:	83 c4 10             	add    $0x10,%esp
    assert(alloc_pages(4) == NULL);
  104c00:	83 ec 0c             	sub    $0xc,%esp
  104c03:	6a 04                	push   $0x4
  104c05:	e8 9c df ff ff       	call   102ba6 <alloc_pages>
  104c0a:	83 c4 10             	add    $0x10,%esp
  104c0d:	85 c0                	test   %eax,%eax
  104c0f:	74 19                	je     104c2a <default_check+0x211>
  104c11:	68 f4 69 10 00       	push   $0x1069f4
  104c16:	68 de 67 10 00       	push   $0x1067de
  104c1b:	68 0a 01 00 00       	push   $0x10a
  104c20:	68 f3 67 10 00       	push   $0x1067f3
  104c25:	e8 a3 b7 ff ff       	call   1003cd <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  104c2a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104c2d:	83 c0 28             	add    $0x28,%eax
  104c30:	83 c0 04             	add    $0x4,%eax
  104c33:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  104c3a:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104c3d:	8b 45 9c             	mov    -0x64(%ebp),%eax
  104c40:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104c43:	0f a3 10             	bt     %edx,(%eax)
  104c46:	19 c0                	sbb    %eax,%eax
  104c48:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
  104c4b:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  104c4f:	0f 95 c0             	setne  %al
  104c52:	0f b6 c0             	movzbl %al,%eax
  104c55:	85 c0                	test   %eax,%eax
  104c57:	74 0e                	je     104c67 <default_check+0x24e>
  104c59:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104c5c:	83 c0 28             	add    $0x28,%eax
  104c5f:	8b 40 08             	mov    0x8(%eax),%eax
  104c62:	83 f8 03             	cmp    $0x3,%eax
  104c65:	74 19                	je     104c80 <default_check+0x267>
  104c67:	68 0c 6a 10 00       	push   $0x106a0c
  104c6c:	68 de 67 10 00       	push   $0x1067de
  104c71:	68 0b 01 00 00       	push   $0x10b
  104c76:	68 f3 67 10 00       	push   $0x1067f3
  104c7b:	e8 4d b7 ff ff       	call   1003cd <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  104c80:	83 ec 0c             	sub    $0xc,%esp
  104c83:	6a 03                	push   $0x3
  104c85:	e8 1c df ff ff       	call   102ba6 <alloc_pages>
  104c8a:	83 c4 10             	add    $0x10,%esp
  104c8d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  104c90:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  104c94:	75 19                	jne    104caf <default_check+0x296>
  104c96:	68 38 6a 10 00       	push   $0x106a38
  104c9b:	68 de 67 10 00       	push   $0x1067de
  104ca0:	68 0c 01 00 00       	push   $0x10c
  104ca5:	68 f3 67 10 00       	push   $0x1067f3
  104caa:	e8 1e b7 ff ff       	call   1003cd <__panic>
    assert(alloc_page() == NULL);
  104caf:	83 ec 0c             	sub    $0xc,%esp
  104cb2:	6a 01                	push   $0x1
  104cb4:	e8 ed de ff ff       	call   102ba6 <alloc_pages>
  104cb9:	83 c4 10             	add    $0x10,%esp
  104cbc:	85 c0                	test   %eax,%eax
  104cbe:	74 19                	je     104cd9 <default_check+0x2c0>
  104cc0:	68 4e 69 10 00       	push   $0x10694e
  104cc5:	68 de 67 10 00       	push   $0x1067de
  104cca:	68 0d 01 00 00       	push   $0x10d
  104ccf:	68 f3 67 10 00       	push   $0x1067f3
  104cd4:	e8 f4 b6 ff ff       	call   1003cd <__panic>
    assert(p0 + 2 == p1);
  104cd9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104cdc:	83 c0 28             	add    $0x28,%eax
  104cdf:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  104ce2:	74 19                	je     104cfd <default_check+0x2e4>
  104ce4:	68 56 6a 10 00       	push   $0x106a56
  104ce9:	68 de 67 10 00       	push   $0x1067de
  104cee:	68 0e 01 00 00       	push   $0x10e
  104cf3:	68 f3 67 10 00       	push   $0x1067f3
  104cf8:	e8 d0 b6 ff ff       	call   1003cd <__panic>

    p2 = p0 + 1;
  104cfd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104d00:	83 c0 14             	add    $0x14,%eax
  104d03:	89 45 c0             	mov    %eax,-0x40(%ebp)
    free_page(p0);
  104d06:	83 ec 08             	sub    $0x8,%esp
  104d09:	6a 01                	push   $0x1
  104d0b:	ff 75 dc             	pushl  -0x24(%ebp)
  104d0e:	e8 d1 de ff ff       	call   102be4 <free_pages>
  104d13:	83 c4 10             	add    $0x10,%esp
    free_pages(p1, 3);
  104d16:	83 ec 08             	sub    $0x8,%esp
  104d19:	6a 03                	push   $0x3
  104d1b:	ff 75 c4             	pushl  -0x3c(%ebp)
  104d1e:	e8 c1 de ff ff       	call   102be4 <free_pages>
  104d23:	83 c4 10             	add    $0x10,%esp
    assert(PageProperty(p0) && p0->property == 1);
  104d26:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104d29:	83 c0 04             	add    $0x4,%eax
  104d2c:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  104d33:	89 45 94             	mov    %eax,-0x6c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104d36:	8b 45 94             	mov    -0x6c(%ebp),%eax
  104d39:	8b 55 c8             	mov    -0x38(%ebp),%edx
  104d3c:	0f a3 10             	bt     %edx,(%eax)
  104d3f:	19 c0                	sbb    %eax,%eax
  104d41:	89 45 90             	mov    %eax,-0x70(%ebp)
    return oldbit != 0;
  104d44:	83 7d 90 00          	cmpl   $0x0,-0x70(%ebp)
  104d48:	0f 95 c0             	setne  %al
  104d4b:	0f b6 c0             	movzbl %al,%eax
  104d4e:	85 c0                	test   %eax,%eax
  104d50:	74 0b                	je     104d5d <default_check+0x344>
  104d52:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104d55:	8b 40 08             	mov    0x8(%eax),%eax
  104d58:	83 f8 01             	cmp    $0x1,%eax
  104d5b:	74 19                	je     104d76 <default_check+0x35d>
  104d5d:	68 64 6a 10 00       	push   $0x106a64
  104d62:	68 de 67 10 00       	push   $0x1067de
  104d67:	68 13 01 00 00       	push   $0x113
  104d6c:	68 f3 67 10 00       	push   $0x1067f3
  104d71:	e8 57 b6 ff ff       	call   1003cd <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  104d76:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104d79:	83 c0 04             	add    $0x4,%eax
  104d7c:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
  104d83:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104d86:	8b 45 8c             	mov    -0x74(%ebp),%eax
  104d89:	8b 55 bc             	mov    -0x44(%ebp),%edx
  104d8c:	0f a3 10             	bt     %edx,(%eax)
  104d8f:	19 c0                	sbb    %eax,%eax
  104d91:	89 45 88             	mov    %eax,-0x78(%ebp)
    return oldbit != 0;
  104d94:	83 7d 88 00          	cmpl   $0x0,-0x78(%ebp)
  104d98:	0f 95 c0             	setne  %al
  104d9b:	0f b6 c0             	movzbl %al,%eax
  104d9e:	85 c0                	test   %eax,%eax
  104da0:	74 0b                	je     104dad <default_check+0x394>
  104da2:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104da5:	8b 40 08             	mov    0x8(%eax),%eax
  104da8:	83 f8 03             	cmp    $0x3,%eax
  104dab:	74 19                	je     104dc6 <default_check+0x3ad>
  104dad:	68 8c 6a 10 00       	push   $0x106a8c
  104db2:	68 de 67 10 00       	push   $0x1067de
  104db7:	68 14 01 00 00       	push   $0x114
  104dbc:	68 f3 67 10 00       	push   $0x1067f3
  104dc1:	e8 07 b6 ff ff       	call   1003cd <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
  104dc6:	83 ec 0c             	sub    $0xc,%esp
  104dc9:	6a 01                	push   $0x1
  104dcb:	e8 d6 dd ff ff       	call   102ba6 <alloc_pages>
  104dd0:	83 c4 10             	add    $0x10,%esp
  104dd3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  104dd6:	8b 45 c0             	mov    -0x40(%ebp),%eax
  104dd9:	83 e8 14             	sub    $0x14,%eax
  104ddc:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  104ddf:	74 19                	je     104dfa <default_check+0x3e1>
  104de1:	68 b2 6a 10 00       	push   $0x106ab2
  104de6:	68 de 67 10 00       	push   $0x1067de
  104deb:	68 16 01 00 00       	push   $0x116
  104df0:	68 f3 67 10 00       	push   $0x1067f3
  104df5:	e8 d3 b5 ff ff       	call   1003cd <__panic>
    free_page(p0);
  104dfa:	83 ec 08             	sub    $0x8,%esp
  104dfd:	6a 01                	push   $0x1
  104dff:	ff 75 dc             	pushl  -0x24(%ebp)
  104e02:	e8 dd dd ff ff       	call   102be4 <free_pages>
  104e07:	83 c4 10             	add    $0x10,%esp
    assert((p0 = alloc_pages(2)) == p2 + 1);
  104e0a:	83 ec 0c             	sub    $0xc,%esp
  104e0d:	6a 02                	push   $0x2
  104e0f:	e8 92 dd ff ff       	call   102ba6 <alloc_pages>
  104e14:	83 c4 10             	add    $0x10,%esp
  104e17:	89 45 dc             	mov    %eax,-0x24(%ebp)
  104e1a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  104e1d:	83 c0 14             	add    $0x14,%eax
  104e20:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  104e23:	74 19                	je     104e3e <default_check+0x425>
  104e25:	68 d0 6a 10 00       	push   $0x106ad0
  104e2a:	68 de 67 10 00       	push   $0x1067de
  104e2f:	68 18 01 00 00       	push   $0x118
  104e34:	68 f3 67 10 00       	push   $0x1067f3
  104e39:	e8 8f b5 ff ff       	call   1003cd <__panic>

    free_pages(p0, 2);
  104e3e:	83 ec 08             	sub    $0x8,%esp
  104e41:	6a 02                	push   $0x2
  104e43:	ff 75 dc             	pushl  -0x24(%ebp)
  104e46:	e8 99 dd ff ff       	call   102be4 <free_pages>
  104e4b:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
  104e4e:	83 ec 08             	sub    $0x8,%esp
  104e51:	6a 01                	push   $0x1
  104e53:	ff 75 c0             	pushl  -0x40(%ebp)
  104e56:	e8 89 dd ff ff       	call   102be4 <free_pages>
  104e5b:	83 c4 10             	add    $0x10,%esp

    assert((p0 = alloc_pages(5)) != NULL);
  104e5e:	83 ec 0c             	sub    $0xc,%esp
  104e61:	6a 05                	push   $0x5
  104e63:	e8 3e dd ff ff       	call   102ba6 <alloc_pages>
  104e68:	83 c4 10             	add    $0x10,%esp
  104e6b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  104e6e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  104e72:	75 19                	jne    104e8d <default_check+0x474>
  104e74:	68 f0 6a 10 00       	push   $0x106af0
  104e79:	68 de 67 10 00       	push   $0x1067de
  104e7e:	68 1d 01 00 00       	push   $0x11d
  104e83:	68 f3 67 10 00       	push   $0x1067f3
  104e88:	e8 40 b5 ff ff       	call   1003cd <__panic>
    assert(alloc_page() == NULL);
  104e8d:	83 ec 0c             	sub    $0xc,%esp
  104e90:	6a 01                	push   $0x1
  104e92:	e8 0f dd ff ff       	call   102ba6 <alloc_pages>
  104e97:	83 c4 10             	add    $0x10,%esp
  104e9a:	85 c0                	test   %eax,%eax
  104e9c:	74 19                	je     104eb7 <default_check+0x49e>
  104e9e:	68 4e 69 10 00       	push   $0x10694e
  104ea3:	68 de 67 10 00       	push   $0x1067de
  104ea8:	68 1e 01 00 00       	push   $0x11e
  104ead:	68 f3 67 10 00       	push   $0x1067f3
  104eb2:	e8 16 b5 ff ff       	call   1003cd <__panic>

    assert(nr_free == 0);
  104eb7:	a1 64 89 11 00       	mov    0x118964,%eax
  104ebc:	85 c0                	test   %eax,%eax
  104ebe:	74 19                	je     104ed9 <default_check+0x4c0>
  104ec0:	68 a1 69 10 00       	push   $0x1069a1
  104ec5:	68 de 67 10 00       	push   $0x1067de
  104eca:	68 20 01 00 00       	push   $0x120
  104ecf:	68 f3 67 10 00       	push   $0x1067f3
  104ed4:	e8 f4 b4 ff ff       	call   1003cd <__panic>
    nr_free = nr_free_store;
  104ed9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  104edc:	a3 64 89 11 00       	mov    %eax,0x118964

    free_list = free_list_store;
  104ee1:	8b 45 80             	mov    -0x80(%ebp),%eax
  104ee4:	8b 55 84             	mov    -0x7c(%ebp),%edx
  104ee7:	a3 5c 89 11 00       	mov    %eax,0x11895c
  104eec:	89 15 60 89 11 00    	mov    %edx,0x118960
    free_pages(p0, 5);
  104ef2:	83 ec 08             	sub    $0x8,%esp
  104ef5:	6a 05                	push   $0x5
  104ef7:	ff 75 dc             	pushl  -0x24(%ebp)
  104efa:	e8 e5 dc ff ff       	call   102be4 <free_pages>
  104eff:	83 c4 10             	add    $0x10,%esp

    le = &free_list;
  104f02:	c7 45 ec 5c 89 11 00 	movl   $0x11895c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  104f09:	eb 1d                	jmp    104f28 <default_check+0x50f>
        struct Page *p = le2page(le, page_link);
  104f0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104f0e:	83 e8 0c             	sub    $0xc,%eax
  104f11:	89 45 b4             	mov    %eax,-0x4c(%ebp)
        count --, total -= p->property;
  104f14:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  104f18:	8b 55 f0             	mov    -0x10(%ebp),%edx
  104f1b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  104f1e:	8b 40 08             	mov    0x8(%eax),%eax
  104f21:	29 c2                	sub    %eax,%edx
  104f23:	89 d0                	mov    %edx,%eax
  104f25:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104f28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104f2b:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  104f2e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  104f31:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  104f34:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104f37:	81 7d ec 5c 89 11 00 	cmpl   $0x11895c,-0x14(%ebp)
  104f3e:	75 cb                	jne    104f0b <default_check+0x4f2>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
  104f40:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104f44:	74 19                	je     104f5f <default_check+0x546>
  104f46:	68 0e 6b 10 00       	push   $0x106b0e
  104f4b:	68 de 67 10 00       	push   $0x1067de
  104f50:	68 2b 01 00 00       	push   $0x12b
  104f55:	68 f3 67 10 00       	push   $0x1067f3
  104f5a:	e8 6e b4 ff ff       	call   1003cd <__panic>
    assert(total == 0);
  104f5f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104f63:	74 19                	je     104f7e <default_check+0x565>
  104f65:	68 19 6b 10 00       	push   $0x106b19
  104f6a:	68 de 67 10 00       	push   $0x1067de
  104f6f:	68 2c 01 00 00       	push   $0x12c
  104f74:	68 f3 67 10 00       	push   $0x1067f3
  104f79:	e8 4f b4 ff ff       	call   1003cd <__panic>
}
  104f7e:	90                   	nop
  104f7f:	c9                   	leave  
  104f80:	c3                   	ret    

00104f81 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  104f81:	55                   	push   %ebp
  104f82:	89 e5                	mov    %esp,%ebp
  104f84:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  104f87:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  104f8e:	eb 04                	jmp    104f94 <strlen+0x13>
        cnt ++;
  104f90:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  104f94:	8b 45 08             	mov    0x8(%ebp),%eax
  104f97:	8d 50 01             	lea    0x1(%eax),%edx
  104f9a:	89 55 08             	mov    %edx,0x8(%ebp)
  104f9d:	0f b6 00             	movzbl (%eax),%eax
  104fa0:	84 c0                	test   %al,%al
  104fa2:	75 ec                	jne    104f90 <strlen+0xf>
        cnt ++;
    }
    return cnt;
  104fa4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  104fa7:	c9                   	leave  
  104fa8:	c3                   	ret    

00104fa9 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  104fa9:	55                   	push   %ebp
  104faa:	89 e5                	mov    %esp,%ebp
  104fac:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  104faf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  104fb6:	eb 04                	jmp    104fbc <strnlen+0x13>
        cnt ++;
  104fb8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  104fbc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104fbf:	3b 45 0c             	cmp    0xc(%ebp),%eax
  104fc2:	73 10                	jae    104fd4 <strnlen+0x2b>
  104fc4:	8b 45 08             	mov    0x8(%ebp),%eax
  104fc7:	8d 50 01             	lea    0x1(%eax),%edx
  104fca:	89 55 08             	mov    %edx,0x8(%ebp)
  104fcd:	0f b6 00             	movzbl (%eax),%eax
  104fd0:	84 c0                	test   %al,%al
  104fd2:	75 e4                	jne    104fb8 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  104fd4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  104fd7:	c9                   	leave  
  104fd8:	c3                   	ret    

00104fd9 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  104fd9:	55                   	push   %ebp
  104fda:	89 e5                	mov    %esp,%ebp
  104fdc:	57                   	push   %edi
  104fdd:	56                   	push   %esi
  104fde:	83 ec 20             	sub    $0x20,%esp
  104fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  104fe4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104fe7:	8b 45 0c             	mov    0xc(%ebp),%eax
  104fea:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  104fed:	8b 55 f0             	mov    -0x10(%ebp),%edx
  104ff0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104ff3:	89 d1                	mov    %edx,%ecx
  104ff5:	89 c2                	mov    %eax,%edx
  104ff7:	89 ce                	mov    %ecx,%esi
  104ff9:	89 d7                	mov    %edx,%edi
  104ffb:	ac                   	lods   %ds:(%esi),%al
  104ffc:	aa                   	stos   %al,%es:(%edi)
  104ffd:	84 c0                	test   %al,%al
  104fff:	75 fa                	jne    104ffb <strcpy+0x22>
  105001:	89 fa                	mov    %edi,%edx
  105003:	89 f1                	mov    %esi,%ecx
  105005:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105008:	89 55 e8             	mov    %edx,-0x18(%ebp)
  10500b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  10500e:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
  105011:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  105012:	83 c4 20             	add    $0x20,%esp
  105015:	5e                   	pop    %esi
  105016:	5f                   	pop    %edi
  105017:	5d                   	pop    %ebp
  105018:	c3                   	ret    

00105019 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  105019:	55                   	push   %ebp
  10501a:	89 e5                	mov    %esp,%ebp
  10501c:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  10501f:	8b 45 08             	mov    0x8(%ebp),%eax
  105022:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  105025:	eb 21                	jmp    105048 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  105027:	8b 45 0c             	mov    0xc(%ebp),%eax
  10502a:	0f b6 10             	movzbl (%eax),%edx
  10502d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105030:	88 10                	mov    %dl,(%eax)
  105032:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105035:	0f b6 00             	movzbl (%eax),%eax
  105038:	84 c0                	test   %al,%al
  10503a:	74 04                	je     105040 <strncpy+0x27>
            src ++;
  10503c:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  105040:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  105044:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  105048:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10504c:	75 d9                	jne    105027 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  10504e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105051:	c9                   	leave  
  105052:	c3                   	ret    

00105053 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  105053:	55                   	push   %ebp
  105054:	89 e5                	mov    %esp,%ebp
  105056:	57                   	push   %edi
  105057:	56                   	push   %esi
  105058:	83 ec 20             	sub    $0x20,%esp
  10505b:	8b 45 08             	mov    0x8(%ebp),%eax
  10505e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105061:	8b 45 0c             	mov    0xc(%ebp),%eax
  105064:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  105067:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10506a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10506d:	89 d1                	mov    %edx,%ecx
  10506f:	89 c2                	mov    %eax,%edx
  105071:	89 ce                	mov    %ecx,%esi
  105073:	89 d7                	mov    %edx,%edi
  105075:	ac                   	lods   %ds:(%esi),%al
  105076:	ae                   	scas   %es:(%edi),%al
  105077:	75 08                	jne    105081 <strcmp+0x2e>
  105079:	84 c0                	test   %al,%al
  10507b:	75 f8                	jne    105075 <strcmp+0x22>
  10507d:	31 c0                	xor    %eax,%eax
  10507f:	eb 04                	jmp    105085 <strcmp+0x32>
  105081:	19 c0                	sbb    %eax,%eax
  105083:	0c 01                	or     $0x1,%al
  105085:	89 fa                	mov    %edi,%edx
  105087:	89 f1                	mov    %esi,%ecx
  105089:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10508c:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  10508f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
  105092:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
  105095:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  105096:	83 c4 20             	add    $0x20,%esp
  105099:	5e                   	pop    %esi
  10509a:	5f                   	pop    %edi
  10509b:	5d                   	pop    %ebp
  10509c:	c3                   	ret    

0010509d <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  10509d:	55                   	push   %ebp
  10509e:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  1050a0:	eb 0c                	jmp    1050ae <strncmp+0x11>
        n --, s1 ++, s2 ++;
  1050a2:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1050a6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1050aa:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  1050ae:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1050b2:	74 1a                	je     1050ce <strncmp+0x31>
  1050b4:	8b 45 08             	mov    0x8(%ebp),%eax
  1050b7:	0f b6 00             	movzbl (%eax),%eax
  1050ba:	84 c0                	test   %al,%al
  1050bc:	74 10                	je     1050ce <strncmp+0x31>
  1050be:	8b 45 08             	mov    0x8(%ebp),%eax
  1050c1:	0f b6 10             	movzbl (%eax),%edx
  1050c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1050c7:	0f b6 00             	movzbl (%eax),%eax
  1050ca:	38 c2                	cmp    %al,%dl
  1050cc:	74 d4                	je     1050a2 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  1050ce:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1050d2:	74 18                	je     1050ec <strncmp+0x4f>
  1050d4:	8b 45 08             	mov    0x8(%ebp),%eax
  1050d7:	0f b6 00             	movzbl (%eax),%eax
  1050da:	0f b6 d0             	movzbl %al,%edx
  1050dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1050e0:	0f b6 00             	movzbl (%eax),%eax
  1050e3:	0f b6 c0             	movzbl %al,%eax
  1050e6:	29 c2                	sub    %eax,%edx
  1050e8:	89 d0                	mov    %edx,%eax
  1050ea:	eb 05                	jmp    1050f1 <strncmp+0x54>
  1050ec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1050f1:	5d                   	pop    %ebp
  1050f2:	c3                   	ret    

001050f3 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  1050f3:	55                   	push   %ebp
  1050f4:	89 e5                	mov    %esp,%ebp
  1050f6:	83 ec 04             	sub    $0x4,%esp
  1050f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1050fc:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  1050ff:	eb 14                	jmp    105115 <strchr+0x22>
        if (*s == c) {
  105101:	8b 45 08             	mov    0x8(%ebp),%eax
  105104:	0f b6 00             	movzbl (%eax),%eax
  105107:	3a 45 fc             	cmp    -0x4(%ebp),%al
  10510a:	75 05                	jne    105111 <strchr+0x1e>
            return (char *)s;
  10510c:	8b 45 08             	mov    0x8(%ebp),%eax
  10510f:	eb 13                	jmp    105124 <strchr+0x31>
        }
        s ++;
  105111:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  105115:	8b 45 08             	mov    0x8(%ebp),%eax
  105118:	0f b6 00             	movzbl (%eax),%eax
  10511b:	84 c0                	test   %al,%al
  10511d:	75 e2                	jne    105101 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  10511f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105124:	c9                   	leave  
  105125:	c3                   	ret    

00105126 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  105126:	55                   	push   %ebp
  105127:	89 e5                	mov    %esp,%ebp
  105129:	83 ec 04             	sub    $0x4,%esp
  10512c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10512f:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105132:	eb 0f                	jmp    105143 <strfind+0x1d>
        if (*s == c) {
  105134:	8b 45 08             	mov    0x8(%ebp),%eax
  105137:	0f b6 00             	movzbl (%eax),%eax
  10513a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  10513d:	74 10                	je     10514f <strfind+0x29>
            break;
        }
        s ++;
  10513f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  105143:	8b 45 08             	mov    0x8(%ebp),%eax
  105146:	0f b6 00             	movzbl (%eax),%eax
  105149:	84 c0                	test   %al,%al
  10514b:	75 e7                	jne    105134 <strfind+0xe>
  10514d:	eb 01                	jmp    105150 <strfind+0x2a>
        if (*s == c) {
            break;
  10514f:	90                   	nop
        }
        s ++;
    }
    return (char *)s;
  105150:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105153:	c9                   	leave  
  105154:	c3                   	ret    

00105155 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  105155:	55                   	push   %ebp
  105156:	89 e5                	mov    %esp,%ebp
  105158:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  10515b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  105162:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105169:	eb 04                	jmp    10516f <strtol+0x1a>
        s ++;
  10516b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  10516f:	8b 45 08             	mov    0x8(%ebp),%eax
  105172:	0f b6 00             	movzbl (%eax),%eax
  105175:	3c 20                	cmp    $0x20,%al
  105177:	74 f2                	je     10516b <strtol+0x16>
  105179:	8b 45 08             	mov    0x8(%ebp),%eax
  10517c:	0f b6 00             	movzbl (%eax),%eax
  10517f:	3c 09                	cmp    $0x9,%al
  105181:	74 e8                	je     10516b <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  105183:	8b 45 08             	mov    0x8(%ebp),%eax
  105186:	0f b6 00             	movzbl (%eax),%eax
  105189:	3c 2b                	cmp    $0x2b,%al
  10518b:	75 06                	jne    105193 <strtol+0x3e>
        s ++;
  10518d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105191:	eb 15                	jmp    1051a8 <strtol+0x53>
    }
    else if (*s == '-') {
  105193:	8b 45 08             	mov    0x8(%ebp),%eax
  105196:	0f b6 00             	movzbl (%eax),%eax
  105199:	3c 2d                	cmp    $0x2d,%al
  10519b:	75 0b                	jne    1051a8 <strtol+0x53>
        s ++, neg = 1;
  10519d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1051a1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  1051a8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1051ac:	74 06                	je     1051b4 <strtol+0x5f>
  1051ae:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  1051b2:	75 24                	jne    1051d8 <strtol+0x83>
  1051b4:	8b 45 08             	mov    0x8(%ebp),%eax
  1051b7:	0f b6 00             	movzbl (%eax),%eax
  1051ba:	3c 30                	cmp    $0x30,%al
  1051bc:	75 1a                	jne    1051d8 <strtol+0x83>
  1051be:	8b 45 08             	mov    0x8(%ebp),%eax
  1051c1:	83 c0 01             	add    $0x1,%eax
  1051c4:	0f b6 00             	movzbl (%eax),%eax
  1051c7:	3c 78                	cmp    $0x78,%al
  1051c9:	75 0d                	jne    1051d8 <strtol+0x83>
        s += 2, base = 16;
  1051cb:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  1051cf:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  1051d6:	eb 2a                	jmp    105202 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  1051d8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1051dc:	75 17                	jne    1051f5 <strtol+0xa0>
  1051de:	8b 45 08             	mov    0x8(%ebp),%eax
  1051e1:	0f b6 00             	movzbl (%eax),%eax
  1051e4:	3c 30                	cmp    $0x30,%al
  1051e6:	75 0d                	jne    1051f5 <strtol+0xa0>
        s ++, base = 8;
  1051e8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1051ec:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  1051f3:	eb 0d                	jmp    105202 <strtol+0xad>
    }
    else if (base == 0) {
  1051f5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1051f9:	75 07                	jne    105202 <strtol+0xad>
        base = 10;
  1051fb:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  105202:	8b 45 08             	mov    0x8(%ebp),%eax
  105205:	0f b6 00             	movzbl (%eax),%eax
  105208:	3c 2f                	cmp    $0x2f,%al
  10520a:	7e 1b                	jle    105227 <strtol+0xd2>
  10520c:	8b 45 08             	mov    0x8(%ebp),%eax
  10520f:	0f b6 00             	movzbl (%eax),%eax
  105212:	3c 39                	cmp    $0x39,%al
  105214:	7f 11                	jg     105227 <strtol+0xd2>
            dig = *s - '0';
  105216:	8b 45 08             	mov    0x8(%ebp),%eax
  105219:	0f b6 00             	movzbl (%eax),%eax
  10521c:	0f be c0             	movsbl %al,%eax
  10521f:	83 e8 30             	sub    $0x30,%eax
  105222:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105225:	eb 48                	jmp    10526f <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  105227:	8b 45 08             	mov    0x8(%ebp),%eax
  10522a:	0f b6 00             	movzbl (%eax),%eax
  10522d:	3c 60                	cmp    $0x60,%al
  10522f:	7e 1b                	jle    10524c <strtol+0xf7>
  105231:	8b 45 08             	mov    0x8(%ebp),%eax
  105234:	0f b6 00             	movzbl (%eax),%eax
  105237:	3c 7a                	cmp    $0x7a,%al
  105239:	7f 11                	jg     10524c <strtol+0xf7>
            dig = *s - 'a' + 10;
  10523b:	8b 45 08             	mov    0x8(%ebp),%eax
  10523e:	0f b6 00             	movzbl (%eax),%eax
  105241:	0f be c0             	movsbl %al,%eax
  105244:	83 e8 57             	sub    $0x57,%eax
  105247:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10524a:	eb 23                	jmp    10526f <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  10524c:	8b 45 08             	mov    0x8(%ebp),%eax
  10524f:	0f b6 00             	movzbl (%eax),%eax
  105252:	3c 40                	cmp    $0x40,%al
  105254:	7e 3c                	jle    105292 <strtol+0x13d>
  105256:	8b 45 08             	mov    0x8(%ebp),%eax
  105259:	0f b6 00             	movzbl (%eax),%eax
  10525c:	3c 5a                	cmp    $0x5a,%al
  10525e:	7f 32                	jg     105292 <strtol+0x13d>
            dig = *s - 'A' + 10;
  105260:	8b 45 08             	mov    0x8(%ebp),%eax
  105263:	0f b6 00             	movzbl (%eax),%eax
  105266:	0f be c0             	movsbl %al,%eax
  105269:	83 e8 37             	sub    $0x37,%eax
  10526c:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  10526f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105272:	3b 45 10             	cmp    0x10(%ebp),%eax
  105275:	7d 1a                	jge    105291 <strtol+0x13c>
            break;
        }
        s ++, val = (val * base) + dig;
  105277:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  10527b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10527e:	0f af 45 10          	imul   0x10(%ebp),%eax
  105282:	89 c2                	mov    %eax,%edx
  105284:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105287:	01 d0                	add    %edx,%eax
  105289:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  10528c:	e9 71 ff ff ff       	jmp    105202 <strtol+0xad>
        }
        else {
            break;
        }
        if (dig >= base) {
            break;
  105291:	90                   	nop
        }
        s ++, val = (val * base) + dig;
        // we don't properly detect overflow!
    }

    if (endptr) {
  105292:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105296:	74 08                	je     1052a0 <strtol+0x14b>
        *endptr = (char *) s;
  105298:	8b 45 0c             	mov    0xc(%ebp),%eax
  10529b:	8b 55 08             	mov    0x8(%ebp),%edx
  10529e:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  1052a0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  1052a4:	74 07                	je     1052ad <strtol+0x158>
  1052a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1052a9:	f7 d8                	neg    %eax
  1052ab:	eb 03                	jmp    1052b0 <strtol+0x15b>
  1052ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  1052b0:	c9                   	leave  
  1052b1:	c3                   	ret    

001052b2 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  1052b2:	55                   	push   %ebp
  1052b3:	89 e5                	mov    %esp,%ebp
  1052b5:	57                   	push   %edi
  1052b6:	83 ec 24             	sub    $0x24,%esp
  1052b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1052bc:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  1052bf:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  1052c3:	8b 55 08             	mov    0x8(%ebp),%edx
  1052c6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  1052c9:	88 45 f7             	mov    %al,-0x9(%ebp)
  1052cc:	8b 45 10             	mov    0x10(%ebp),%eax
  1052cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  1052d2:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  1052d5:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  1052d9:	8b 55 f8             	mov    -0x8(%ebp),%edx
  1052dc:	89 d7                	mov    %edx,%edi
  1052de:	f3 aa                	rep stos %al,%es:(%edi)
  1052e0:	89 fa                	mov    %edi,%edx
  1052e2:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  1052e5:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  1052e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1052eb:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  1052ec:	83 c4 24             	add    $0x24,%esp
  1052ef:	5f                   	pop    %edi
  1052f0:	5d                   	pop    %ebp
  1052f1:	c3                   	ret    

001052f2 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  1052f2:	55                   	push   %ebp
  1052f3:	89 e5                	mov    %esp,%ebp
  1052f5:	57                   	push   %edi
  1052f6:	56                   	push   %esi
  1052f7:	53                   	push   %ebx
  1052f8:	83 ec 30             	sub    $0x30,%esp
  1052fb:	8b 45 08             	mov    0x8(%ebp),%eax
  1052fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105301:	8b 45 0c             	mov    0xc(%ebp),%eax
  105304:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105307:	8b 45 10             	mov    0x10(%ebp),%eax
  10530a:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  10530d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105310:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  105313:	73 42                	jae    105357 <memmove+0x65>
  105315:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105318:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10531b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10531e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105321:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105324:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105327:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10532a:	c1 e8 02             	shr    $0x2,%eax
  10532d:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  10532f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105332:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105335:	89 d7                	mov    %edx,%edi
  105337:	89 c6                	mov    %eax,%esi
  105339:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  10533b:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  10533e:	83 e1 03             	and    $0x3,%ecx
  105341:	74 02                	je     105345 <memmove+0x53>
  105343:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105345:	89 f0                	mov    %esi,%eax
  105347:	89 fa                	mov    %edi,%edx
  105349:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  10534c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  10534f:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  105352:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
  105355:	eb 36                	jmp    10538d <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  105357:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10535a:	8d 50 ff             	lea    -0x1(%eax),%edx
  10535d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105360:	01 c2                	add    %eax,%edx
  105362:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105365:	8d 48 ff             	lea    -0x1(%eax),%ecx
  105368:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10536b:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  10536e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105371:	89 c1                	mov    %eax,%ecx
  105373:	89 d8                	mov    %ebx,%eax
  105375:	89 d6                	mov    %edx,%esi
  105377:	89 c7                	mov    %eax,%edi
  105379:	fd                   	std    
  10537a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  10537c:	fc                   	cld    
  10537d:	89 f8                	mov    %edi,%eax
  10537f:	89 f2                	mov    %esi,%edx
  105381:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  105384:	89 55 c8             	mov    %edx,-0x38(%ebp)
  105387:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
  10538a:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  10538d:	83 c4 30             	add    $0x30,%esp
  105390:	5b                   	pop    %ebx
  105391:	5e                   	pop    %esi
  105392:	5f                   	pop    %edi
  105393:	5d                   	pop    %ebp
  105394:	c3                   	ret    

00105395 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  105395:	55                   	push   %ebp
  105396:	89 e5                	mov    %esp,%ebp
  105398:	57                   	push   %edi
  105399:	56                   	push   %esi
  10539a:	83 ec 20             	sub    $0x20,%esp
  10539d:	8b 45 08             	mov    0x8(%ebp),%eax
  1053a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1053a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1053a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1053a9:	8b 45 10             	mov    0x10(%ebp),%eax
  1053ac:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  1053af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1053b2:	c1 e8 02             	shr    $0x2,%eax
  1053b5:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  1053b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1053ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1053bd:	89 d7                	mov    %edx,%edi
  1053bf:	89 c6                	mov    %eax,%esi
  1053c1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  1053c3:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  1053c6:	83 e1 03             	and    $0x3,%ecx
  1053c9:	74 02                	je     1053cd <memcpy+0x38>
  1053cb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1053cd:	89 f0                	mov    %esi,%eax
  1053cf:	89 fa                	mov    %edi,%edx
  1053d1:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  1053d4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  1053d7:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  1053da:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
  1053dd:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  1053de:	83 c4 20             	add    $0x20,%esp
  1053e1:	5e                   	pop    %esi
  1053e2:	5f                   	pop    %edi
  1053e3:	5d                   	pop    %ebp
  1053e4:	c3                   	ret    

001053e5 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  1053e5:	55                   	push   %ebp
  1053e6:	89 e5                	mov    %esp,%ebp
  1053e8:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  1053eb:	8b 45 08             	mov    0x8(%ebp),%eax
  1053ee:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  1053f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1053f4:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  1053f7:	eb 30                	jmp    105429 <memcmp+0x44>
        if (*s1 != *s2) {
  1053f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1053fc:	0f b6 10             	movzbl (%eax),%edx
  1053ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105402:	0f b6 00             	movzbl (%eax),%eax
  105405:	38 c2                	cmp    %al,%dl
  105407:	74 18                	je     105421 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  105409:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10540c:	0f b6 00             	movzbl (%eax),%eax
  10540f:	0f b6 d0             	movzbl %al,%edx
  105412:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105415:	0f b6 00             	movzbl (%eax),%eax
  105418:	0f b6 c0             	movzbl %al,%eax
  10541b:	29 c2                	sub    %eax,%edx
  10541d:	89 d0                	mov    %edx,%eax
  10541f:	eb 1a                	jmp    10543b <memcmp+0x56>
        }
        s1 ++, s2 ++;
  105421:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  105425:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  105429:	8b 45 10             	mov    0x10(%ebp),%eax
  10542c:	8d 50 ff             	lea    -0x1(%eax),%edx
  10542f:	89 55 10             	mov    %edx,0x10(%ebp)
  105432:	85 c0                	test   %eax,%eax
  105434:	75 c3                	jne    1053f9 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  105436:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10543b:	c9                   	leave  
  10543c:	c3                   	ret    

0010543d <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  10543d:	55                   	push   %ebp
  10543e:	89 e5                	mov    %esp,%ebp
  105440:	83 ec 38             	sub    $0x38,%esp
  105443:	8b 45 10             	mov    0x10(%ebp),%eax
  105446:	89 45 d0             	mov    %eax,-0x30(%ebp)
  105449:	8b 45 14             	mov    0x14(%ebp),%eax
  10544c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  10544f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  105452:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  105455:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105458:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  10545b:	8b 45 18             	mov    0x18(%ebp),%eax
  10545e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105461:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105464:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105467:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10546a:	89 55 f0             	mov    %edx,-0x10(%ebp)
  10546d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105470:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105473:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  105477:	74 1c                	je     105495 <printnum+0x58>
  105479:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10547c:	ba 00 00 00 00       	mov    $0x0,%edx
  105481:	f7 75 e4             	divl   -0x1c(%ebp)
  105484:	89 55 f4             	mov    %edx,-0xc(%ebp)
  105487:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10548a:	ba 00 00 00 00       	mov    $0x0,%edx
  10548f:	f7 75 e4             	divl   -0x1c(%ebp)
  105492:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105495:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105498:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10549b:	f7 75 e4             	divl   -0x1c(%ebp)
  10549e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1054a1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  1054a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1054a7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1054aa:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1054ad:	89 55 ec             	mov    %edx,-0x14(%ebp)
  1054b0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1054b3:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  1054b6:	8b 45 18             	mov    0x18(%ebp),%eax
  1054b9:	ba 00 00 00 00       	mov    $0x0,%edx
  1054be:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1054c1:	77 41                	ja     105504 <printnum+0xc7>
  1054c3:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1054c6:	72 05                	jb     1054cd <printnum+0x90>
  1054c8:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  1054cb:	77 37                	ja     105504 <printnum+0xc7>
        printnum(putch, putdat, result, base, width - 1, padc);
  1054cd:	8b 45 1c             	mov    0x1c(%ebp),%eax
  1054d0:	83 e8 01             	sub    $0x1,%eax
  1054d3:	83 ec 04             	sub    $0x4,%esp
  1054d6:	ff 75 20             	pushl  0x20(%ebp)
  1054d9:	50                   	push   %eax
  1054da:	ff 75 18             	pushl  0x18(%ebp)
  1054dd:	ff 75 ec             	pushl  -0x14(%ebp)
  1054e0:	ff 75 e8             	pushl  -0x18(%ebp)
  1054e3:	ff 75 0c             	pushl  0xc(%ebp)
  1054e6:	ff 75 08             	pushl  0x8(%ebp)
  1054e9:	e8 4f ff ff ff       	call   10543d <printnum>
  1054ee:	83 c4 20             	add    $0x20,%esp
  1054f1:	eb 1b                	jmp    10550e <printnum+0xd1>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  1054f3:	83 ec 08             	sub    $0x8,%esp
  1054f6:	ff 75 0c             	pushl  0xc(%ebp)
  1054f9:	ff 75 20             	pushl  0x20(%ebp)
  1054fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1054ff:	ff d0                	call   *%eax
  105501:	83 c4 10             	add    $0x10,%esp
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  105504:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  105508:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  10550c:	7f e5                	jg     1054f3 <printnum+0xb6>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  10550e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  105511:	05 d4 6b 10 00       	add    $0x106bd4,%eax
  105516:	0f b6 00             	movzbl (%eax),%eax
  105519:	0f be c0             	movsbl %al,%eax
  10551c:	83 ec 08             	sub    $0x8,%esp
  10551f:	ff 75 0c             	pushl  0xc(%ebp)
  105522:	50                   	push   %eax
  105523:	8b 45 08             	mov    0x8(%ebp),%eax
  105526:	ff d0                	call   *%eax
  105528:	83 c4 10             	add    $0x10,%esp
}
  10552b:	90                   	nop
  10552c:	c9                   	leave  
  10552d:	c3                   	ret    

0010552e <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  10552e:	55                   	push   %ebp
  10552f:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  105531:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  105535:	7e 14                	jle    10554b <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  105537:	8b 45 08             	mov    0x8(%ebp),%eax
  10553a:	8b 00                	mov    (%eax),%eax
  10553c:	8d 48 08             	lea    0x8(%eax),%ecx
  10553f:	8b 55 08             	mov    0x8(%ebp),%edx
  105542:	89 0a                	mov    %ecx,(%edx)
  105544:	8b 50 04             	mov    0x4(%eax),%edx
  105547:	8b 00                	mov    (%eax),%eax
  105549:	eb 30                	jmp    10557b <getuint+0x4d>
    }
    else if (lflag) {
  10554b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10554f:	74 16                	je     105567 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  105551:	8b 45 08             	mov    0x8(%ebp),%eax
  105554:	8b 00                	mov    (%eax),%eax
  105556:	8d 48 04             	lea    0x4(%eax),%ecx
  105559:	8b 55 08             	mov    0x8(%ebp),%edx
  10555c:	89 0a                	mov    %ecx,(%edx)
  10555e:	8b 00                	mov    (%eax),%eax
  105560:	ba 00 00 00 00       	mov    $0x0,%edx
  105565:	eb 14                	jmp    10557b <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  105567:	8b 45 08             	mov    0x8(%ebp),%eax
  10556a:	8b 00                	mov    (%eax),%eax
  10556c:	8d 48 04             	lea    0x4(%eax),%ecx
  10556f:	8b 55 08             	mov    0x8(%ebp),%edx
  105572:	89 0a                	mov    %ecx,(%edx)
  105574:	8b 00                	mov    (%eax),%eax
  105576:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  10557b:	5d                   	pop    %ebp
  10557c:	c3                   	ret    

0010557d <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  10557d:	55                   	push   %ebp
  10557e:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  105580:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  105584:	7e 14                	jle    10559a <getint+0x1d>
        return va_arg(*ap, long long);
  105586:	8b 45 08             	mov    0x8(%ebp),%eax
  105589:	8b 00                	mov    (%eax),%eax
  10558b:	8d 48 08             	lea    0x8(%eax),%ecx
  10558e:	8b 55 08             	mov    0x8(%ebp),%edx
  105591:	89 0a                	mov    %ecx,(%edx)
  105593:	8b 50 04             	mov    0x4(%eax),%edx
  105596:	8b 00                	mov    (%eax),%eax
  105598:	eb 28                	jmp    1055c2 <getint+0x45>
    }
    else if (lflag) {
  10559a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10559e:	74 12                	je     1055b2 <getint+0x35>
        return va_arg(*ap, long);
  1055a0:	8b 45 08             	mov    0x8(%ebp),%eax
  1055a3:	8b 00                	mov    (%eax),%eax
  1055a5:	8d 48 04             	lea    0x4(%eax),%ecx
  1055a8:	8b 55 08             	mov    0x8(%ebp),%edx
  1055ab:	89 0a                	mov    %ecx,(%edx)
  1055ad:	8b 00                	mov    (%eax),%eax
  1055af:	99                   	cltd   
  1055b0:	eb 10                	jmp    1055c2 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  1055b2:	8b 45 08             	mov    0x8(%ebp),%eax
  1055b5:	8b 00                	mov    (%eax),%eax
  1055b7:	8d 48 04             	lea    0x4(%eax),%ecx
  1055ba:	8b 55 08             	mov    0x8(%ebp),%edx
  1055bd:	89 0a                	mov    %ecx,(%edx)
  1055bf:	8b 00                	mov    (%eax),%eax
  1055c1:	99                   	cltd   
    }
}
  1055c2:	5d                   	pop    %ebp
  1055c3:	c3                   	ret    

001055c4 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  1055c4:	55                   	push   %ebp
  1055c5:	89 e5                	mov    %esp,%ebp
  1055c7:	83 ec 18             	sub    $0x18,%esp
    va_list ap;

    va_start(ap, fmt);
  1055ca:	8d 45 14             	lea    0x14(%ebp),%eax
  1055cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  1055d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1055d3:	50                   	push   %eax
  1055d4:	ff 75 10             	pushl  0x10(%ebp)
  1055d7:	ff 75 0c             	pushl  0xc(%ebp)
  1055da:	ff 75 08             	pushl  0x8(%ebp)
  1055dd:	e8 06 00 00 00       	call   1055e8 <vprintfmt>
  1055e2:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
  1055e5:	90                   	nop
  1055e6:	c9                   	leave  
  1055e7:	c3                   	ret    

001055e8 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  1055e8:	55                   	push   %ebp
  1055e9:	89 e5                	mov    %esp,%ebp
  1055eb:	56                   	push   %esi
  1055ec:	53                   	push   %ebx
  1055ed:	83 ec 20             	sub    $0x20,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1055f0:	eb 17                	jmp    105609 <vprintfmt+0x21>
            if (ch == '\0') {
  1055f2:	85 db                	test   %ebx,%ebx
  1055f4:	0f 84 8e 03 00 00    	je     105988 <vprintfmt+0x3a0>
                return;
            }
            putch(ch, putdat);
  1055fa:	83 ec 08             	sub    $0x8,%esp
  1055fd:	ff 75 0c             	pushl  0xc(%ebp)
  105600:	53                   	push   %ebx
  105601:	8b 45 08             	mov    0x8(%ebp),%eax
  105604:	ff d0                	call   *%eax
  105606:	83 c4 10             	add    $0x10,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105609:	8b 45 10             	mov    0x10(%ebp),%eax
  10560c:	8d 50 01             	lea    0x1(%eax),%edx
  10560f:	89 55 10             	mov    %edx,0x10(%ebp)
  105612:	0f b6 00             	movzbl (%eax),%eax
  105615:	0f b6 d8             	movzbl %al,%ebx
  105618:	83 fb 25             	cmp    $0x25,%ebx
  10561b:	75 d5                	jne    1055f2 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  10561d:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  105621:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  105628:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10562b:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  10562e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  105635:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105638:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  10563b:	8b 45 10             	mov    0x10(%ebp),%eax
  10563e:	8d 50 01             	lea    0x1(%eax),%edx
  105641:	89 55 10             	mov    %edx,0x10(%ebp)
  105644:	0f b6 00             	movzbl (%eax),%eax
  105647:	0f b6 d8             	movzbl %al,%ebx
  10564a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  10564d:	83 f8 55             	cmp    $0x55,%eax
  105650:	0f 87 05 03 00 00    	ja     10595b <vprintfmt+0x373>
  105656:	8b 04 85 f8 6b 10 00 	mov    0x106bf8(,%eax,4),%eax
  10565d:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  10565f:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  105663:	eb d6                	jmp    10563b <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  105665:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  105669:	eb d0                	jmp    10563b <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  10566b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  105672:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105675:	89 d0                	mov    %edx,%eax
  105677:	c1 e0 02             	shl    $0x2,%eax
  10567a:	01 d0                	add    %edx,%eax
  10567c:	01 c0                	add    %eax,%eax
  10567e:	01 d8                	add    %ebx,%eax
  105680:	83 e8 30             	sub    $0x30,%eax
  105683:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  105686:	8b 45 10             	mov    0x10(%ebp),%eax
  105689:	0f b6 00             	movzbl (%eax),%eax
  10568c:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  10568f:	83 fb 2f             	cmp    $0x2f,%ebx
  105692:	7e 39                	jle    1056cd <vprintfmt+0xe5>
  105694:	83 fb 39             	cmp    $0x39,%ebx
  105697:	7f 34                	jg     1056cd <vprintfmt+0xe5>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  105699:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  10569d:	eb d3                	jmp    105672 <vprintfmt+0x8a>
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  10569f:	8b 45 14             	mov    0x14(%ebp),%eax
  1056a2:	8d 50 04             	lea    0x4(%eax),%edx
  1056a5:	89 55 14             	mov    %edx,0x14(%ebp)
  1056a8:	8b 00                	mov    (%eax),%eax
  1056aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  1056ad:	eb 1f                	jmp    1056ce <vprintfmt+0xe6>

        case '.':
            if (width < 0)
  1056af:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1056b3:	79 86                	jns    10563b <vprintfmt+0x53>
                width = 0;
  1056b5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  1056bc:	e9 7a ff ff ff       	jmp    10563b <vprintfmt+0x53>

        case '#':
            altflag = 1;
  1056c1:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  1056c8:	e9 6e ff ff ff       	jmp    10563b <vprintfmt+0x53>
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
            goto process_precision;
  1056cd:	90                   	nop
        case '#':
            altflag = 1;
            goto reswitch;

        process_precision:
            if (width < 0)
  1056ce:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1056d2:	0f 89 63 ff ff ff    	jns    10563b <vprintfmt+0x53>
                width = precision, precision = -1;
  1056d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1056db:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1056de:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  1056e5:	e9 51 ff ff ff       	jmp    10563b <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  1056ea:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  1056ee:	e9 48 ff ff ff       	jmp    10563b <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  1056f3:	8b 45 14             	mov    0x14(%ebp),%eax
  1056f6:	8d 50 04             	lea    0x4(%eax),%edx
  1056f9:	89 55 14             	mov    %edx,0x14(%ebp)
  1056fc:	8b 00                	mov    (%eax),%eax
  1056fe:	83 ec 08             	sub    $0x8,%esp
  105701:	ff 75 0c             	pushl  0xc(%ebp)
  105704:	50                   	push   %eax
  105705:	8b 45 08             	mov    0x8(%ebp),%eax
  105708:	ff d0                	call   *%eax
  10570a:	83 c4 10             	add    $0x10,%esp
            break;
  10570d:	e9 71 02 00 00       	jmp    105983 <vprintfmt+0x39b>

        // error message
        case 'e':
            err = va_arg(ap, int);
  105712:	8b 45 14             	mov    0x14(%ebp),%eax
  105715:	8d 50 04             	lea    0x4(%eax),%edx
  105718:	89 55 14             	mov    %edx,0x14(%ebp)
  10571b:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  10571d:	85 db                	test   %ebx,%ebx
  10571f:	79 02                	jns    105723 <vprintfmt+0x13b>
                err = -err;
  105721:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  105723:	83 fb 06             	cmp    $0x6,%ebx
  105726:	7f 0b                	jg     105733 <vprintfmt+0x14b>
  105728:	8b 34 9d b8 6b 10 00 	mov    0x106bb8(,%ebx,4),%esi
  10572f:	85 f6                	test   %esi,%esi
  105731:	75 19                	jne    10574c <vprintfmt+0x164>
                printfmt(putch, putdat, "error %d", err);
  105733:	53                   	push   %ebx
  105734:	68 e5 6b 10 00       	push   $0x106be5
  105739:	ff 75 0c             	pushl  0xc(%ebp)
  10573c:	ff 75 08             	pushl  0x8(%ebp)
  10573f:	e8 80 fe ff ff       	call   1055c4 <printfmt>
  105744:	83 c4 10             	add    $0x10,%esp
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  105747:	e9 37 02 00 00       	jmp    105983 <vprintfmt+0x39b>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  10574c:	56                   	push   %esi
  10574d:	68 ee 6b 10 00       	push   $0x106bee
  105752:	ff 75 0c             	pushl  0xc(%ebp)
  105755:	ff 75 08             	pushl  0x8(%ebp)
  105758:	e8 67 fe ff ff       	call   1055c4 <printfmt>
  10575d:	83 c4 10             	add    $0x10,%esp
            }
            break;
  105760:	e9 1e 02 00 00       	jmp    105983 <vprintfmt+0x39b>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  105765:	8b 45 14             	mov    0x14(%ebp),%eax
  105768:	8d 50 04             	lea    0x4(%eax),%edx
  10576b:	89 55 14             	mov    %edx,0x14(%ebp)
  10576e:	8b 30                	mov    (%eax),%esi
  105770:	85 f6                	test   %esi,%esi
  105772:	75 05                	jne    105779 <vprintfmt+0x191>
                p = "(null)";
  105774:	be f1 6b 10 00       	mov    $0x106bf1,%esi
            }
            if (width > 0 && padc != '-') {
  105779:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10577d:	7e 76                	jle    1057f5 <vprintfmt+0x20d>
  10577f:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  105783:	74 70                	je     1057f5 <vprintfmt+0x20d>
                for (width -= strnlen(p, precision); width > 0; width --) {
  105785:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105788:	83 ec 08             	sub    $0x8,%esp
  10578b:	50                   	push   %eax
  10578c:	56                   	push   %esi
  10578d:	e8 17 f8 ff ff       	call   104fa9 <strnlen>
  105792:	83 c4 10             	add    $0x10,%esp
  105795:	89 c2                	mov    %eax,%edx
  105797:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10579a:	29 d0                	sub    %edx,%eax
  10579c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10579f:	eb 17                	jmp    1057b8 <vprintfmt+0x1d0>
                    putch(padc, putdat);
  1057a1:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  1057a5:	83 ec 08             	sub    $0x8,%esp
  1057a8:	ff 75 0c             	pushl  0xc(%ebp)
  1057ab:	50                   	push   %eax
  1057ac:	8b 45 08             	mov    0x8(%ebp),%eax
  1057af:	ff d0                	call   *%eax
  1057b1:	83 c4 10             	add    $0x10,%esp
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  1057b4:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  1057b8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1057bc:	7f e3                	jg     1057a1 <vprintfmt+0x1b9>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  1057be:	eb 35                	jmp    1057f5 <vprintfmt+0x20d>
                if (altflag && (ch < ' ' || ch > '~')) {
  1057c0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  1057c4:	74 1c                	je     1057e2 <vprintfmt+0x1fa>
  1057c6:	83 fb 1f             	cmp    $0x1f,%ebx
  1057c9:	7e 05                	jle    1057d0 <vprintfmt+0x1e8>
  1057cb:	83 fb 7e             	cmp    $0x7e,%ebx
  1057ce:	7e 12                	jle    1057e2 <vprintfmt+0x1fa>
                    putch('?', putdat);
  1057d0:	83 ec 08             	sub    $0x8,%esp
  1057d3:	ff 75 0c             	pushl  0xc(%ebp)
  1057d6:	6a 3f                	push   $0x3f
  1057d8:	8b 45 08             	mov    0x8(%ebp),%eax
  1057db:	ff d0                	call   *%eax
  1057dd:	83 c4 10             	add    $0x10,%esp
  1057e0:	eb 0f                	jmp    1057f1 <vprintfmt+0x209>
                }
                else {
                    putch(ch, putdat);
  1057e2:	83 ec 08             	sub    $0x8,%esp
  1057e5:	ff 75 0c             	pushl  0xc(%ebp)
  1057e8:	53                   	push   %ebx
  1057e9:	8b 45 08             	mov    0x8(%ebp),%eax
  1057ec:	ff d0                	call   *%eax
  1057ee:	83 c4 10             	add    $0x10,%esp
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  1057f1:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  1057f5:	89 f0                	mov    %esi,%eax
  1057f7:	8d 70 01             	lea    0x1(%eax),%esi
  1057fa:	0f b6 00             	movzbl (%eax),%eax
  1057fd:	0f be d8             	movsbl %al,%ebx
  105800:	85 db                	test   %ebx,%ebx
  105802:	74 26                	je     10582a <vprintfmt+0x242>
  105804:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105808:	78 b6                	js     1057c0 <vprintfmt+0x1d8>
  10580a:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  10580e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105812:	79 ac                	jns    1057c0 <vprintfmt+0x1d8>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  105814:	eb 14                	jmp    10582a <vprintfmt+0x242>
                putch(' ', putdat);
  105816:	83 ec 08             	sub    $0x8,%esp
  105819:	ff 75 0c             	pushl  0xc(%ebp)
  10581c:	6a 20                	push   $0x20
  10581e:	8b 45 08             	mov    0x8(%ebp),%eax
  105821:	ff d0                	call   *%eax
  105823:	83 c4 10             	add    $0x10,%esp
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  105826:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  10582a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10582e:	7f e6                	jg     105816 <vprintfmt+0x22e>
                putch(' ', putdat);
            }
            break;
  105830:	e9 4e 01 00 00       	jmp    105983 <vprintfmt+0x39b>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  105835:	83 ec 08             	sub    $0x8,%esp
  105838:	ff 75 e0             	pushl  -0x20(%ebp)
  10583b:	8d 45 14             	lea    0x14(%ebp),%eax
  10583e:	50                   	push   %eax
  10583f:	e8 39 fd ff ff       	call   10557d <getint>
  105844:	83 c4 10             	add    $0x10,%esp
  105847:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10584a:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  10584d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105850:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105853:	85 d2                	test   %edx,%edx
  105855:	79 23                	jns    10587a <vprintfmt+0x292>
                putch('-', putdat);
  105857:	83 ec 08             	sub    $0x8,%esp
  10585a:	ff 75 0c             	pushl  0xc(%ebp)
  10585d:	6a 2d                	push   $0x2d
  10585f:	8b 45 08             	mov    0x8(%ebp),%eax
  105862:	ff d0                	call   *%eax
  105864:	83 c4 10             	add    $0x10,%esp
                num = -(long long)num;
  105867:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10586a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10586d:	f7 d8                	neg    %eax
  10586f:	83 d2 00             	adc    $0x0,%edx
  105872:	f7 da                	neg    %edx
  105874:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105877:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  10587a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  105881:	e9 9f 00 00 00       	jmp    105925 <vprintfmt+0x33d>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  105886:	83 ec 08             	sub    $0x8,%esp
  105889:	ff 75 e0             	pushl  -0x20(%ebp)
  10588c:	8d 45 14             	lea    0x14(%ebp),%eax
  10588f:	50                   	push   %eax
  105890:	e8 99 fc ff ff       	call   10552e <getuint>
  105895:	83 c4 10             	add    $0x10,%esp
  105898:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10589b:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  10589e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1058a5:	eb 7e                	jmp    105925 <vprintfmt+0x33d>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  1058a7:	83 ec 08             	sub    $0x8,%esp
  1058aa:	ff 75 e0             	pushl  -0x20(%ebp)
  1058ad:	8d 45 14             	lea    0x14(%ebp),%eax
  1058b0:	50                   	push   %eax
  1058b1:	e8 78 fc ff ff       	call   10552e <getuint>
  1058b6:	83 c4 10             	add    $0x10,%esp
  1058b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1058bc:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  1058bf:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  1058c6:	eb 5d                	jmp    105925 <vprintfmt+0x33d>

        // pointer
        case 'p':
            putch('0', putdat);
  1058c8:	83 ec 08             	sub    $0x8,%esp
  1058cb:	ff 75 0c             	pushl  0xc(%ebp)
  1058ce:	6a 30                	push   $0x30
  1058d0:	8b 45 08             	mov    0x8(%ebp),%eax
  1058d3:	ff d0                	call   *%eax
  1058d5:	83 c4 10             	add    $0x10,%esp
            putch('x', putdat);
  1058d8:	83 ec 08             	sub    $0x8,%esp
  1058db:	ff 75 0c             	pushl  0xc(%ebp)
  1058de:	6a 78                	push   $0x78
  1058e0:	8b 45 08             	mov    0x8(%ebp),%eax
  1058e3:	ff d0                	call   *%eax
  1058e5:	83 c4 10             	add    $0x10,%esp
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  1058e8:	8b 45 14             	mov    0x14(%ebp),%eax
  1058eb:	8d 50 04             	lea    0x4(%eax),%edx
  1058ee:	89 55 14             	mov    %edx,0x14(%ebp)
  1058f1:	8b 00                	mov    (%eax),%eax
  1058f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1058f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  1058fd:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  105904:	eb 1f                	jmp    105925 <vprintfmt+0x33d>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  105906:	83 ec 08             	sub    $0x8,%esp
  105909:	ff 75 e0             	pushl  -0x20(%ebp)
  10590c:	8d 45 14             	lea    0x14(%ebp),%eax
  10590f:	50                   	push   %eax
  105910:	e8 19 fc ff ff       	call   10552e <getuint>
  105915:	83 c4 10             	add    $0x10,%esp
  105918:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10591b:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  10591e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  105925:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  105929:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10592c:	83 ec 04             	sub    $0x4,%esp
  10592f:	52                   	push   %edx
  105930:	ff 75 e8             	pushl  -0x18(%ebp)
  105933:	50                   	push   %eax
  105934:	ff 75 f4             	pushl  -0xc(%ebp)
  105937:	ff 75 f0             	pushl  -0x10(%ebp)
  10593a:	ff 75 0c             	pushl  0xc(%ebp)
  10593d:	ff 75 08             	pushl  0x8(%ebp)
  105940:	e8 f8 fa ff ff       	call   10543d <printnum>
  105945:	83 c4 20             	add    $0x20,%esp
            break;
  105948:	eb 39                	jmp    105983 <vprintfmt+0x39b>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  10594a:	83 ec 08             	sub    $0x8,%esp
  10594d:	ff 75 0c             	pushl  0xc(%ebp)
  105950:	53                   	push   %ebx
  105951:	8b 45 08             	mov    0x8(%ebp),%eax
  105954:	ff d0                	call   *%eax
  105956:	83 c4 10             	add    $0x10,%esp
            break;
  105959:	eb 28                	jmp    105983 <vprintfmt+0x39b>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  10595b:	83 ec 08             	sub    $0x8,%esp
  10595e:	ff 75 0c             	pushl  0xc(%ebp)
  105961:	6a 25                	push   $0x25
  105963:	8b 45 08             	mov    0x8(%ebp),%eax
  105966:	ff d0                	call   *%eax
  105968:	83 c4 10             	add    $0x10,%esp
            for (fmt --; fmt[-1] != '%'; fmt --)
  10596b:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  10596f:	eb 04                	jmp    105975 <vprintfmt+0x38d>
  105971:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105975:	8b 45 10             	mov    0x10(%ebp),%eax
  105978:	83 e8 01             	sub    $0x1,%eax
  10597b:	0f b6 00             	movzbl (%eax),%eax
  10597e:	3c 25                	cmp    $0x25,%al
  105980:	75 ef                	jne    105971 <vprintfmt+0x389>
                /* do nothing */;
            break;
  105982:	90                   	nop
        }
    }
  105983:	e9 68 fc ff ff       	jmp    1055f0 <vprintfmt+0x8>
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
            if (ch == '\0') {
                return;
  105988:	90                   	nop
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  105989:	8d 65 f8             	lea    -0x8(%ebp),%esp
  10598c:	5b                   	pop    %ebx
  10598d:	5e                   	pop    %esi
  10598e:	5d                   	pop    %ebp
  10598f:	c3                   	ret    

00105990 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  105990:	55                   	push   %ebp
  105991:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  105993:	8b 45 0c             	mov    0xc(%ebp),%eax
  105996:	8b 40 08             	mov    0x8(%eax),%eax
  105999:	8d 50 01             	lea    0x1(%eax),%edx
  10599c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10599f:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  1059a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059a5:	8b 10                	mov    (%eax),%edx
  1059a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059aa:	8b 40 04             	mov    0x4(%eax),%eax
  1059ad:	39 c2                	cmp    %eax,%edx
  1059af:	73 12                	jae    1059c3 <sprintputch+0x33>
        *b->buf ++ = ch;
  1059b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059b4:	8b 00                	mov    (%eax),%eax
  1059b6:	8d 48 01             	lea    0x1(%eax),%ecx
  1059b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  1059bc:	89 0a                	mov    %ecx,(%edx)
  1059be:	8b 55 08             	mov    0x8(%ebp),%edx
  1059c1:	88 10                	mov    %dl,(%eax)
    }
}
  1059c3:	90                   	nop
  1059c4:	5d                   	pop    %ebp
  1059c5:	c3                   	ret    

001059c6 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  1059c6:	55                   	push   %ebp
  1059c7:	89 e5                	mov    %esp,%ebp
  1059c9:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  1059cc:	8d 45 14             	lea    0x14(%ebp),%eax
  1059cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  1059d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1059d5:	50                   	push   %eax
  1059d6:	ff 75 10             	pushl  0x10(%ebp)
  1059d9:	ff 75 0c             	pushl  0xc(%ebp)
  1059dc:	ff 75 08             	pushl  0x8(%ebp)
  1059df:	e8 0b 00 00 00       	call   1059ef <vsnprintf>
  1059e4:	83 c4 10             	add    $0x10,%esp
  1059e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  1059ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1059ed:	c9                   	leave  
  1059ee:	c3                   	ret    

001059ef <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  1059ef:	55                   	push   %ebp
  1059f0:	89 e5                	mov    %esp,%ebp
  1059f2:	83 ec 18             	sub    $0x18,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  1059f5:	8b 45 08             	mov    0x8(%ebp),%eax
  1059f8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1059fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059fe:	8d 50 ff             	lea    -0x1(%eax),%edx
  105a01:	8b 45 08             	mov    0x8(%ebp),%eax
  105a04:	01 d0                	add    %edx,%eax
  105a06:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105a09:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  105a10:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  105a14:	74 0a                	je     105a20 <vsnprintf+0x31>
  105a16:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105a19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105a1c:	39 c2                	cmp    %eax,%edx
  105a1e:	76 07                	jbe    105a27 <vsnprintf+0x38>
        return -E_INVAL;
  105a20:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  105a25:	eb 20                	jmp    105a47 <vsnprintf+0x58>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  105a27:	ff 75 14             	pushl  0x14(%ebp)
  105a2a:	ff 75 10             	pushl  0x10(%ebp)
  105a2d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  105a30:	50                   	push   %eax
  105a31:	68 90 59 10 00       	push   $0x105990
  105a36:	e8 ad fb ff ff       	call   1055e8 <vprintfmt>
  105a3b:	83 c4 10             	add    $0x10,%esp
    // null terminate the buffer
    *b.buf = '\0';
  105a3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105a41:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  105a44:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105a47:	c9                   	leave  
  105a48:	c3                   	ret    
