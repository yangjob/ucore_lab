
bin/kernel：     文件格式 elf32-i386


Disassembly of section .text:

00100000 <kern_init>:
void kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

void
kern_init(void){
  100000:	55                   	push   %ebp
  100001:	89 e5                	mov    %esp,%ebp
  100003:	83 ec 18             	sub    $0x18,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100006:	ba 80 fd 10 00       	mov    $0x10fd80,%edx
  10000b:	b8 16 ea 10 00       	mov    $0x10ea16,%eax
  100010:	29 c2                	sub    %eax,%edx
  100012:	89 d0                	mov    %edx,%eax
  100014:	83 ec 04             	sub    $0x4,%esp
  100017:	50                   	push   %eax
  100018:	6a 00                	push   $0x0
  10001a:	68 16 ea 10 00       	push   $0x10ea16
  10001f:	e8 80 2d 00 00       	call   102da4 <memset>
  100024:	83 c4 10             	add    $0x10,%esp

    cons_init();                // init the console
  100027:	e8 2d 15 00 00       	call   101559 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  10002c:	c7 45 f4 40 35 10 00 	movl   $0x103540,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100033:	83 ec 08             	sub    $0x8,%esp
  100036:	ff 75 f4             	pushl  -0xc(%ebp)
  100039:	68 5c 35 10 00       	push   $0x10355c
  10003e:	e8 0a 02 00 00       	call   10024d <cprintf>
  100043:	83 c4 10             	add    $0x10,%esp

    print_kerninfo();
  100046:	e8 8c 08 00 00       	call   1008d7 <print_kerninfo>

    grade_backtrace();
  10004b:	e8 79 00 00 00       	call   1000c9 <grade_backtrace>

    pmm_init();                 // init physical memory management
  100050:	e8 13 2a 00 00       	call   102a68 <pmm_init>

    pic_init();                 // init interrupt controller
  100055:	e8 42 16 00 00       	call   10169c <pic_init>
    idt_init();                 // init interrupt descriptor table
  10005a:	e8 a3 17 00 00       	call   101802 <idt_init>

    clock_init();               // init clock interrupt
  10005f:	e8 da 0c 00 00       	call   100d3e <clock_init>
    intr_enable();              // enable irq interrupt
  100064:	e8 70 17 00 00       	call   1017d9 <intr_enable>

    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    lab1_switch_test();
  100069:	e8 50 01 00 00       	call   1001be <lab1_switch_test>

    /* do nothing */
    while (1);
  10006e:	eb fe                	jmp    10006e <kern_init+0x6e>

00100070 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  100070:	55                   	push   %ebp
  100071:	89 e5                	mov    %esp,%ebp
  100073:	83 ec 08             	sub    $0x8,%esp
    mon_backtrace(0, NULL, NULL);
  100076:	83 ec 04             	sub    $0x4,%esp
  100079:	6a 00                	push   $0x0
  10007b:	6a 00                	push   $0x0
  10007d:	6a 00                	push   $0x0
  10007f:	e8 a8 0c 00 00       	call   100d2c <mon_backtrace>
  100084:	83 c4 10             	add    $0x10,%esp
}
  100087:	90                   	nop
  100088:	c9                   	leave  
  100089:	c3                   	ret    

0010008a <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  10008a:	55                   	push   %ebp
  10008b:	89 e5                	mov    %esp,%ebp
  10008d:	53                   	push   %ebx
  10008e:	83 ec 04             	sub    $0x4,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  100091:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  100094:	8b 55 0c             	mov    0xc(%ebp),%edx
  100097:	8d 5d 08             	lea    0x8(%ebp),%ebx
  10009a:	8b 45 08             	mov    0x8(%ebp),%eax
  10009d:	51                   	push   %ecx
  10009e:	52                   	push   %edx
  10009f:	53                   	push   %ebx
  1000a0:	50                   	push   %eax
  1000a1:	e8 ca ff ff ff       	call   100070 <grade_backtrace2>
  1000a6:	83 c4 10             	add    $0x10,%esp
}
  1000a9:	90                   	nop
  1000aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1000ad:	c9                   	leave  
  1000ae:	c3                   	ret    

001000af <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000af:	55                   	push   %ebp
  1000b0:	89 e5                	mov    %esp,%ebp
  1000b2:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace1(arg0, arg2);
  1000b5:	83 ec 08             	sub    $0x8,%esp
  1000b8:	ff 75 10             	pushl  0x10(%ebp)
  1000bb:	ff 75 08             	pushl  0x8(%ebp)
  1000be:	e8 c7 ff ff ff       	call   10008a <grade_backtrace1>
  1000c3:	83 c4 10             	add    $0x10,%esp
}
  1000c6:	90                   	nop
  1000c7:	c9                   	leave  
  1000c8:	c3                   	ret    

001000c9 <grade_backtrace>:

void
grade_backtrace(void) {
  1000c9:	55                   	push   %ebp
  1000ca:	89 e5                	mov    %esp,%ebp
  1000cc:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  1000cf:	b8 00 00 10 00       	mov    $0x100000,%eax
  1000d4:	83 ec 04             	sub    $0x4,%esp
  1000d7:	68 00 00 ff ff       	push   $0xffff0000
  1000dc:	50                   	push   %eax
  1000dd:	6a 00                	push   $0x0
  1000df:	e8 cb ff ff ff       	call   1000af <grade_backtrace0>
  1000e4:	83 c4 10             	add    $0x10,%esp
}
  1000e7:	90                   	nop
  1000e8:	c9                   	leave  
  1000e9:	c3                   	ret    

001000ea <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  1000ea:	55                   	push   %ebp
  1000eb:	89 e5                	mov    %esp,%ebp
  1000ed:	83 ec 18             	sub    $0x18,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  1000f0:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  1000f3:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  1000f6:	8c 45 f2             	mov    %es,-0xe(%ebp)
  1000f9:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  1000fc:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100100:	0f b7 c0             	movzwl %ax,%eax
  100103:	83 e0 03             	and    $0x3,%eax
  100106:	89 c2                	mov    %eax,%edx
  100108:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  10010d:	83 ec 04             	sub    $0x4,%esp
  100110:	52                   	push   %edx
  100111:	50                   	push   %eax
  100112:	68 61 35 10 00       	push   $0x103561
  100117:	e8 31 01 00 00       	call   10024d <cprintf>
  10011c:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  cs = %x\n", round, reg1);
  10011f:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100123:	0f b7 d0             	movzwl %ax,%edx
  100126:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  10012b:	83 ec 04             	sub    $0x4,%esp
  10012e:	52                   	push   %edx
  10012f:	50                   	push   %eax
  100130:	68 6f 35 10 00       	push   $0x10356f
  100135:	e8 13 01 00 00       	call   10024d <cprintf>
  10013a:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ds = %x\n", round, reg2);
  10013d:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100141:	0f b7 d0             	movzwl %ax,%edx
  100144:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100149:	83 ec 04             	sub    $0x4,%esp
  10014c:	52                   	push   %edx
  10014d:	50                   	push   %eax
  10014e:	68 7d 35 10 00       	push   $0x10357d
  100153:	e8 f5 00 00 00       	call   10024d <cprintf>
  100158:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  es = %x\n", round, reg3);
  10015b:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  10015f:	0f b7 d0             	movzwl %ax,%edx
  100162:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100167:	83 ec 04             	sub    $0x4,%esp
  10016a:	52                   	push   %edx
  10016b:	50                   	push   %eax
  10016c:	68 8b 35 10 00       	push   $0x10358b
  100171:	e8 d7 00 00 00       	call   10024d <cprintf>
  100176:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ss = %x\n", round, reg4);
  100179:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  10017d:	0f b7 d0             	movzwl %ax,%edx
  100180:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100185:	83 ec 04             	sub    $0x4,%esp
  100188:	52                   	push   %edx
  100189:	50                   	push   %eax
  10018a:	68 99 35 10 00       	push   $0x103599
  10018f:	e8 b9 00 00 00       	call   10024d <cprintf>
  100194:	83 c4 10             	add    $0x10,%esp
    round ++;
  100197:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  10019c:	83 c0 01             	add    $0x1,%eax
  10019f:	a3 20 ea 10 00       	mov    %eax,0x10ea20
}
  1001a4:	90                   	nop
  1001a5:	c9                   	leave  
  1001a6:	c3                   	ret    

001001a7 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001a7:	55                   	push   %ebp
  1001a8:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
	asm volatile (
  1001aa:	83 ec 08             	sub    $0x8,%esp
  1001ad:	cd 78                	int    $0x78
  1001af:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp"
	    : 
	    : "i"(T_SWITCH_TOU)
	);
}
  1001b1:	90                   	nop
  1001b2:	5d                   	pop    %ebp
  1001b3:	c3                   	ret    

001001b4 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001b4:	55                   	push   %ebp
  1001b5:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
	asm volatile (
  1001b7:	cd 79                	int    $0x79
  1001b9:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp \n"
	    : 
	    : "i"(T_SWITCH_TOK)
	);
}
  1001bb:	90                   	nop
  1001bc:	5d                   	pop    %ebp
  1001bd:	c3                   	ret    

001001be <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001be:	55                   	push   %ebp
  1001bf:	89 e5                	mov    %esp,%ebp
  1001c1:	83 ec 08             	sub    $0x8,%esp
    lab1_print_cur_status();
  1001c4:	e8 21 ff ff ff       	call   1000ea <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  1001c9:	83 ec 0c             	sub    $0xc,%esp
  1001cc:	68 a8 35 10 00       	push   $0x1035a8
  1001d1:	e8 77 00 00 00       	call   10024d <cprintf>
  1001d6:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_user();
  1001d9:	e8 c9 ff ff ff       	call   1001a7 <lab1_switch_to_user>
    lab1_print_cur_status();
  1001de:	e8 07 ff ff ff       	call   1000ea <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  1001e3:	83 ec 0c             	sub    $0xc,%esp
  1001e6:	68 c8 35 10 00       	push   $0x1035c8
  1001eb:	e8 5d 00 00 00       	call   10024d <cprintf>
  1001f0:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_kernel();
  1001f3:	e8 bc ff ff ff       	call   1001b4 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  1001f8:	e8 ed fe ff ff       	call   1000ea <lab1_print_cur_status>
}
  1001fd:	90                   	nop
  1001fe:	c9                   	leave  
  1001ff:	c3                   	ret    

00100200 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  100200:	55                   	push   %ebp
  100201:	89 e5                	mov    %esp,%ebp
  100203:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
  100206:	83 ec 0c             	sub    $0xc,%esp
  100209:	ff 75 08             	pushl  0x8(%ebp)
  10020c:	e8 79 13 00 00       	call   10158a <cons_putc>
  100211:	83 c4 10             	add    $0x10,%esp
    (*cnt) ++;
  100214:	8b 45 0c             	mov    0xc(%ebp),%eax
  100217:	8b 00                	mov    (%eax),%eax
  100219:	8d 50 01             	lea    0x1(%eax),%edx
  10021c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10021f:	89 10                	mov    %edx,(%eax)
}
  100221:	90                   	nop
  100222:	c9                   	leave  
  100223:	c3                   	ret    

00100224 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  100224:	55                   	push   %ebp
  100225:	89 e5                	mov    %esp,%ebp
  100227:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
  10022a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  100231:	ff 75 0c             	pushl  0xc(%ebp)
  100234:	ff 75 08             	pushl  0x8(%ebp)
  100237:	8d 45 f4             	lea    -0xc(%ebp),%eax
  10023a:	50                   	push   %eax
  10023b:	68 00 02 10 00       	push   $0x100200
  100240:	e8 95 2e 00 00       	call   1030da <vprintfmt>
  100245:	83 c4 10             	add    $0x10,%esp
    return cnt;
  100248:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10024b:	c9                   	leave  
  10024c:	c3                   	ret    

0010024d <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  10024d:	55                   	push   %ebp
  10024e:	89 e5                	mov    %esp,%ebp
  100250:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100253:	8d 45 0c             	lea    0xc(%ebp),%eax
  100256:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100259:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10025c:	83 ec 08             	sub    $0x8,%esp
  10025f:	50                   	push   %eax
  100260:	ff 75 08             	pushl  0x8(%ebp)
  100263:	e8 bc ff ff ff       	call   100224 <vcprintf>
  100268:	83 c4 10             	add    $0x10,%esp
  10026b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10026e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100271:	c9                   	leave  
  100272:	c3                   	ret    

00100273 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100273:	55                   	push   %ebp
  100274:	89 e5                	mov    %esp,%ebp
  100276:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
  100279:	83 ec 0c             	sub    $0xc,%esp
  10027c:	ff 75 08             	pushl  0x8(%ebp)
  10027f:	e8 06 13 00 00       	call   10158a <cons_putc>
  100284:	83 c4 10             	add    $0x10,%esp
}
  100287:	90                   	nop
  100288:	c9                   	leave  
  100289:	c3                   	ret    

0010028a <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  10028a:	55                   	push   %ebp
  10028b:	89 e5                	mov    %esp,%ebp
  10028d:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
  100290:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  100297:	eb 14                	jmp    1002ad <cputs+0x23>
        cputch(c, &cnt);
  100299:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  10029d:	83 ec 08             	sub    $0x8,%esp
  1002a0:	8d 55 f0             	lea    -0x10(%ebp),%edx
  1002a3:	52                   	push   %edx
  1002a4:	50                   	push   %eax
  1002a5:	e8 56 ff ff ff       	call   100200 <cputch>
  1002aa:	83 c4 10             	add    $0x10,%esp
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  1002ad:	8b 45 08             	mov    0x8(%ebp),%eax
  1002b0:	8d 50 01             	lea    0x1(%eax),%edx
  1002b3:	89 55 08             	mov    %edx,0x8(%ebp)
  1002b6:	0f b6 00             	movzbl (%eax),%eax
  1002b9:	88 45 f7             	mov    %al,-0x9(%ebp)
  1002bc:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1002c0:	75 d7                	jne    100299 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  1002c2:	83 ec 08             	sub    $0x8,%esp
  1002c5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1002c8:	50                   	push   %eax
  1002c9:	6a 0a                	push   $0xa
  1002cb:	e8 30 ff ff ff       	call   100200 <cputch>
  1002d0:	83 c4 10             	add    $0x10,%esp
    return cnt;
  1002d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1002d6:	c9                   	leave  
  1002d7:	c3                   	ret    

001002d8 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1002d8:	55                   	push   %ebp
  1002d9:	89 e5                	mov    %esp,%ebp
  1002db:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1002de:	e8 d7 12 00 00       	call   1015ba <cons_getc>
  1002e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1002e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1002ea:	74 f2                	je     1002de <getchar+0x6>
        /* do nothing */;
    return c;
  1002ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1002ef:	c9                   	leave  
  1002f0:	c3                   	ret    

001002f1 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  1002f1:	55                   	push   %ebp
  1002f2:	89 e5                	mov    %esp,%ebp
  1002f4:	83 ec 18             	sub    $0x18,%esp
    if (prompt != NULL) {
  1002f7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1002fb:	74 13                	je     100310 <readline+0x1f>
        cprintf("%s", prompt);
  1002fd:	83 ec 08             	sub    $0x8,%esp
  100300:	ff 75 08             	pushl  0x8(%ebp)
  100303:	68 e7 35 10 00       	push   $0x1035e7
  100308:	e8 40 ff ff ff       	call   10024d <cprintf>
  10030d:	83 c4 10             	add    $0x10,%esp
    }
    int i = 0, c;
  100310:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100317:	e8 bc ff ff ff       	call   1002d8 <getchar>
  10031c:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  10031f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100323:	79 0a                	jns    10032f <readline+0x3e>
            return NULL;
  100325:	b8 00 00 00 00       	mov    $0x0,%eax
  10032a:	e9 82 00 00 00       	jmp    1003b1 <readline+0xc0>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  10032f:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100333:	7e 2b                	jle    100360 <readline+0x6f>
  100335:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  10033c:	7f 22                	jg     100360 <readline+0x6f>
            cputchar(c);
  10033e:	83 ec 0c             	sub    $0xc,%esp
  100341:	ff 75 f0             	pushl  -0x10(%ebp)
  100344:	e8 2a ff ff ff       	call   100273 <cputchar>
  100349:	83 c4 10             	add    $0x10,%esp
            buf[i ++] = c;
  10034c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10034f:	8d 50 01             	lea    0x1(%eax),%edx
  100352:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100355:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100358:	88 90 40 ea 10 00    	mov    %dl,0x10ea40(%eax)
  10035e:	eb 4c                	jmp    1003ac <readline+0xbb>
        }
        else if (c == '\b' && i > 0) {
  100360:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  100364:	75 1a                	jne    100380 <readline+0x8f>
  100366:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10036a:	7e 14                	jle    100380 <readline+0x8f>
            cputchar(c);
  10036c:	83 ec 0c             	sub    $0xc,%esp
  10036f:	ff 75 f0             	pushl  -0x10(%ebp)
  100372:	e8 fc fe ff ff       	call   100273 <cputchar>
  100377:	83 c4 10             	add    $0x10,%esp
            i --;
  10037a:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  10037e:	eb 2c                	jmp    1003ac <readline+0xbb>
        }
        else if (c == '\n' || c == '\r') {
  100380:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  100384:	74 06                	je     10038c <readline+0x9b>
  100386:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  10038a:	75 8b                	jne    100317 <readline+0x26>
            cputchar(c);
  10038c:	83 ec 0c             	sub    $0xc,%esp
  10038f:	ff 75 f0             	pushl  -0x10(%ebp)
  100392:	e8 dc fe ff ff       	call   100273 <cputchar>
  100397:	83 c4 10             	add    $0x10,%esp
            buf[i] = '\0';
  10039a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10039d:	05 40 ea 10 00       	add    $0x10ea40,%eax
  1003a2:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1003a5:	b8 40 ea 10 00       	mov    $0x10ea40,%eax
  1003aa:	eb 05                	jmp    1003b1 <readline+0xc0>
        }
    }
  1003ac:	e9 66 ff ff ff       	jmp    100317 <readline+0x26>
}
  1003b1:	c9                   	leave  
  1003b2:	c3                   	ret    

001003b3 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  1003b3:	55                   	push   %ebp
  1003b4:	89 e5                	mov    %esp,%ebp
  1003b6:	83 ec 18             	sub    $0x18,%esp
    if (is_panic) {
  1003b9:	a1 40 ee 10 00       	mov    0x10ee40,%eax
  1003be:	85 c0                	test   %eax,%eax
  1003c0:	75 4a                	jne    10040c <__panic+0x59>
        goto panic_dead;
    }
    is_panic = 1;
  1003c2:	c7 05 40 ee 10 00 01 	movl   $0x1,0x10ee40
  1003c9:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  1003cc:	8d 45 14             	lea    0x14(%ebp),%eax
  1003cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  1003d2:	83 ec 04             	sub    $0x4,%esp
  1003d5:	ff 75 0c             	pushl  0xc(%ebp)
  1003d8:	ff 75 08             	pushl  0x8(%ebp)
  1003db:	68 ea 35 10 00       	push   $0x1035ea
  1003e0:	e8 68 fe ff ff       	call   10024d <cprintf>
  1003e5:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
  1003e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003eb:	83 ec 08             	sub    $0x8,%esp
  1003ee:	50                   	push   %eax
  1003ef:	ff 75 10             	pushl  0x10(%ebp)
  1003f2:	e8 2d fe ff ff       	call   100224 <vcprintf>
  1003f7:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
  1003fa:	83 ec 0c             	sub    $0xc,%esp
  1003fd:	68 06 36 10 00       	push   $0x103606
  100402:	e8 46 fe ff ff       	call   10024d <cprintf>
  100407:	83 c4 10             	add    $0x10,%esp
  10040a:	eb 01                	jmp    10040d <__panic+0x5a>
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
        goto panic_dead;
  10040c:	90                   	nop
    vcprintf(fmt, ap);
    cprintf("\n");
    va_end(ap);

panic_dead:
    intr_disable();
  10040d:	e8 ce 13 00 00       	call   1017e0 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100412:	83 ec 0c             	sub    $0xc,%esp
  100415:	6a 00                	push   $0x0
  100417:	e8 36 08 00 00       	call   100c52 <kmonitor>
  10041c:	83 c4 10             	add    $0x10,%esp
    }
  10041f:	eb f1                	jmp    100412 <__panic+0x5f>

00100421 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100421:	55                   	push   %ebp
  100422:	89 e5                	mov    %esp,%ebp
  100424:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    va_start(ap, fmt);
  100427:	8d 45 14             	lea    0x14(%ebp),%eax
  10042a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  10042d:	83 ec 04             	sub    $0x4,%esp
  100430:	ff 75 0c             	pushl  0xc(%ebp)
  100433:	ff 75 08             	pushl  0x8(%ebp)
  100436:	68 08 36 10 00       	push   $0x103608
  10043b:	e8 0d fe ff ff       	call   10024d <cprintf>
  100440:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
  100443:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100446:	83 ec 08             	sub    $0x8,%esp
  100449:	50                   	push   %eax
  10044a:	ff 75 10             	pushl  0x10(%ebp)
  10044d:	e8 d2 fd ff ff       	call   100224 <vcprintf>
  100452:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
  100455:	83 ec 0c             	sub    $0xc,%esp
  100458:	68 06 36 10 00       	push   $0x103606
  10045d:	e8 eb fd ff ff       	call   10024d <cprintf>
  100462:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
  100465:	90                   	nop
  100466:	c9                   	leave  
  100467:	c3                   	ret    

00100468 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100468:	55                   	push   %ebp
  100469:	89 e5                	mov    %esp,%ebp
    return is_panic;
  10046b:	a1 40 ee 10 00       	mov    0x10ee40,%eax
}
  100470:	5d                   	pop    %ebp
  100471:	c3                   	ret    

00100472 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  100472:	55                   	push   %ebp
  100473:	89 e5                	mov    %esp,%ebp
  100475:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  100478:	8b 45 0c             	mov    0xc(%ebp),%eax
  10047b:	8b 00                	mov    (%eax),%eax
  10047d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100480:	8b 45 10             	mov    0x10(%ebp),%eax
  100483:	8b 00                	mov    (%eax),%eax
  100485:	89 45 f8             	mov    %eax,-0x8(%ebp)
  100488:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  10048f:	e9 d2 00 00 00       	jmp    100566 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  100494:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100497:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10049a:	01 d0                	add    %edx,%eax
  10049c:	89 c2                	mov    %eax,%edx
  10049e:	c1 ea 1f             	shr    $0x1f,%edx
  1004a1:	01 d0                	add    %edx,%eax
  1004a3:	d1 f8                	sar    %eax
  1004a5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1004a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1004ab:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1004ae:	eb 04                	jmp    1004b4 <stab_binsearch+0x42>
            m --;
  1004b0:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1004b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004b7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004ba:	7c 1f                	jl     1004db <stab_binsearch+0x69>
  1004bc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004bf:	89 d0                	mov    %edx,%eax
  1004c1:	01 c0                	add    %eax,%eax
  1004c3:	01 d0                	add    %edx,%eax
  1004c5:	c1 e0 02             	shl    $0x2,%eax
  1004c8:	89 c2                	mov    %eax,%edx
  1004ca:	8b 45 08             	mov    0x8(%ebp),%eax
  1004cd:	01 d0                	add    %edx,%eax
  1004cf:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1004d3:	0f b6 c0             	movzbl %al,%eax
  1004d6:	3b 45 14             	cmp    0x14(%ebp),%eax
  1004d9:	75 d5                	jne    1004b0 <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
  1004db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004de:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004e1:	7d 0b                	jge    1004ee <stab_binsearch+0x7c>
            l = true_m + 1;
  1004e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1004e6:	83 c0 01             	add    $0x1,%eax
  1004e9:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  1004ec:	eb 78                	jmp    100566 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  1004ee:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  1004f5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004f8:	89 d0                	mov    %edx,%eax
  1004fa:	01 c0                	add    %eax,%eax
  1004fc:	01 d0                	add    %edx,%eax
  1004fe:	c1 e0 02             	shl    $0x2,%eax
  100501:	89 c2                	mov    %eax,%edx
  100503:	8b 45 08             	mov    0x8(%ebp),%eax
  100506:	01 d0                	add    %edx,%eax
  100508:	8b 40 08             	mov    0x8(%eax),%eax
  10050b:	3b 45 18             	cmp    0x18(%ebp),%eax
  10050e:	73 13                	jae    100523 <stab_binsearch+0xb1>
            *region_left = m;
  100510:	8b 45 0c             	mov    0xc(%ebp),%eax
  100513:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100516:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100518:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10051b:	83 c0 01             	add    $0x1,%eax
  10051e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100521:	eb 43                	jmp    100566 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  100523:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100526:	89 d0                	mov    %edx,%eax
  100528:	01 c0                	add    %eax,%eax
  10052a:	01 d0                	add    %edx,%eax
  10052c:	c1 e0 02             	shl    $0x2,%eax
  10052f:	89 c2                	mov    %eax,%edx
  100531:	8b 45 08             	mov    0x8(%ebp),%eax
  100534:	01 d0                	add    %edx,%eax
  100536:	8b 40 08             	mov    0x8(%eax),%eax
  100539:	3b 45 18             	cmp    0x18(%ebp),%eax
  10053c:	76 16                	jbe    100554 <stab_binsearch+0xe2>
            *region_right = m - 1;
  10053e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100541:	8d 50 ff             	lea    -0x1(%eax),%edx
  100544:	8b 45 10             	mov    0x10(%ebp),%eax
  100547:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  100549:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10054c:	83 e8 01             	sub    $0x1,%eax
  10054f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  100552:	eb 12                	jmp    100566 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  100554:	8b 45 0c             	mov    0xc(%ebp),%eax
  100557:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10055a:	89 10                	mov    %edx,(%eax)
            l = m;
  10055c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10055f:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  100562:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
  100566:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100569:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  10056c:	0f 8e 22 ff ff ff    	jle    100494 <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
  100572:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100576:	75 0f                	jne    100587 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  100578:	8b 45 0c             	mov    0xc(%ebp),%eax
  10057b:	8b 00                	mov    (%eax),%eax
  10057d:	8d 50 ff             	lea    -0x1(%eax),%edx
  100580:	8b 45 10             	mov    0x10(%ebp),%eax
  100583:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
  100585:	eb 3f                	jmp    1005c6 <stab_binsearch+0x154>
    if (!any_matches) {
        *region_right = *region_left - 1;
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  100587:	8b 45 10             	mov    0x10(%ebp),%eax
  10058a:	8b 00                	mov    (%eax),%eax
  10058c:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  10058f:	eb 04                	jmp    100595 <stab_binsearch+0x123>
  100591:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  100595:	8b 45 0c             	mov    0xc(%ebp),%eax
  100598:	8b 00                	mov    (%eax),%eax
  10059a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10059d:	7d 1f                	jge    1005be <stab_binsearch+0x14c>
  10059f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005a2:	89 d0                	mov    %edx,%eax
  1005a4:	01 c0                	add    %eax,%eax
  1005a6:	01 d0                	add    %edx,%eax
  1005a8:	c1 e0 02             	shl    $0x2,%eax
  1005ab:	89 c2                	mov    %eax,%edx
  1005ad:	8b 45 08             	mov    0x8(%ebp),%eax
  1005b0:	01 d0                	add    %edx,%eax
  1005b2:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1005b6:	0f b6 c0             	movzbl %al,%eax
  1005b9:	3b 45 14             	cmp    0x14(%ebp),%eax
  1005bc:	75 d3                	jne    100591 <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  1005be:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005c1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005c4:	89 10                	mov    %edx,(%eax)
    }
}
  1005c6:	90                   	nop
  1005c7:	c9                   	leave  
  1005c8:	c3                   	ret    

001005c9 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  1005c9:	55                   	push   %ebp
  1005ca:	89 e5                	mov    %esp,%ebp
  1005cc:	83 ec 38             	sub    $0x38,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  1005cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005d2:	c7 00 28 36 10 00    	movl   $0x103628,(%eax)
    info->eip_line = 0;
  1005d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005db:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  1005e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005e5:	c7 40 08 28 36 10 00 	movl   $0x103628,0x8(%eax)
    info->eip_fn_namelen = 9;
  1005ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005ef:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  1005f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005f9:	8b 55 08             	mov    0x8(%ebp),%edx
  1005fc:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  1005ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  100602:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100609:	c7 45 f4 4c 3e 10 00 	movl   $0x103e4c,-0xc(%ebp)
    stab_end = __STAB_END__;
  100610:	c7 45 f0 8c b8 10 00 	movl   $0x10b88c,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100617:	c7 45 ec 8d b8 10 00 	movl   $0x10b88d,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  10061e:	c7 45 e8 e5 d8 10 00 	movl   $0x10d8e5,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  100625:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100628:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  10062b:	76 0d                	jbe    10063a <debuginfo_eip+0x71>
  10062d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100630:	83 e8 01             	sub    $0x1,%eax
  100633:	0f b6 00             	movzbl (%eax),%eax
  100636:	84 c0                	test   %al,%al
  100638:	74 0a                	je     100644 <debuginfo_eip+0x7b>
        return -1;
  10063a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10063f:	e9 91 02 00 00       	jmp    1008d5 <debuginfo_eip+0x30c>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  100644:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  10064b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10064e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100651:	29 c2                	sub    %eax,%edx
  100653:	89 d0                	mov    %edx,%eax
  100655:	c1 f8 02             	sar    $0x2,%eax
  100658:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  10065e:	83 e8 01             	sub    $0x1,%eax
  100661:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  100664:	ff 75 08             	pushl  0x8(%ebp)
  100667:	6a 64                	push   $0x64
  100669:	8d 45 e0             	lea    -0x20(%ebp),%eax
  10066c:	50                   	push   %eax
  10066d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  100670:	50                   	push   %eax
  100671:	ff 75 f4             	pushl  -0xc(%ebp)
  100674:	e8 f9 fd ff ff       	call   100472 <stab_binsearch>
  100679:	83 c4 14             	add    $0x14,%esp
    if (lfile == 0)
  10067c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10067f:	85 c0                	test   %eax,%eax
  100681:	75 0a                	jne    10068d <debuginfo_eip+0xc4>
        return -1;
  100683:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100688:	e9 48 02 00 00       	jmp    1008d5 <debuginfo_eip+0x30c>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  10068d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100690:	89 45 dc             	mov    %eax,-0x24(%ebp)
  100693:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100696:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  100699:	ff 75 08             	pushl  0x8(%ebp)
  10069c:	6a 24                	push   $0x24
  10069e:	8d 45 d8             	lea    -0x28(%ebp),%eax
  1006a1:	50                   	push   %eax
  1006a2:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1006a5:	50                   	push   %eax
  1006a6:	ff 75 f4             	pushl  -0xc(%ebp)
  1006a9:	e8 c4 fd ff ff       	call   100472 <stab_binsearch>
  1006ae:	83 c4 14             	add    $0x14,%esp

    if (lfun <= rfun) {
  1006b1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1006b4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006b7:	39 c2                	cmp    %eax,%edx
  1006b9:	7f 7c                	jg     100737 <debuginfo_eip+0x16e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  1006bb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006be:	89 c2                	mov    %eax,%edx
  1006c0:	89 d0                	mov    %edx,%eax
  1006c2:	01 c0                	add    %eax,%eax
  1006c4:	01 d0                	add    %edx,%eax
  1006c6:	c1 e0 02             	shl    $0x2,%eax
  1006c9:	89 c2                	mov    %eax,%edx
  1006cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006ce:	01 d0                	add    %edx,%eax
  1006d0:	8b 00                	mov    (%eax),%eax
  1006d2:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1006d5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1006d8:	29 d1                	sub    %edx,%ecx
  1006da:	89 ca                	mov    %ecx,%edx
  1006dc:	39 d0                	cmp    %edx,%eax
  1006de:	73 22                	jae    100702 <debuginfo_eip+0x139>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  1006e0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006e3:	89 c2                	mov    %eax,%edx
  1006e5:	89 d0                	mov    %edx,%eax
  1006e7:	01 c0                	add    %eax,%eax
  1006e9:	01 d0                	add    %edx,%eax
  1006eb:	c1 e0 02             	shl    $0x2,%eax
  1006ee:	89 c2                	mov    %eax,%edx
  1006f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006f3:	01 d0                	add    %edx,%eax
  1006f5:	8b 10                	mov    (%eax),%edx
  1006f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1006fa:	01 c2                	add    %eax,%edx
  1006fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006ff:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  100702:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100705:	89 c2                	mov    %eax,%edx
  100707:	89 d0                	mov    %edx,%eax
  100709:	01 c0                	add    %eax,%eax
  10070b:	01 d0                	add    %edx,%eax
  10070d:	c1 e0 02             	shl    $0x2,%eax
  100710:	89 c2                	mov    %eax,%edx
  100712:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100715:	01 d0                	add    %edx,%eax
  100717:	8b 50 08             	mov    0x8(%eax),%edx
  10071a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10071d:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  100720:	8b 45 0c             	mov    0xc(%ebp),%eax
  100723:	8b 40 10             	mov    0x10(%eax),%eax
  100726:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  100729:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10072c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  10072f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100732:	89 45 d0             	mov    %eax,-0x30(%ebp)
  100735:	eb 15                	jmp    10074c <debuginfo_eip+0x183>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  100737:	8b 45 0c             	mov    0xc(%ebp),%eax
  10073a:	8b 55 08             	mov    0x8(%ebp),%edx
  10073d:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  100740:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100743:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  100746:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100749:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  10074c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10074f:	8b 40 08             	mov    0x8(%eax),%eax
  100752:	83 ec 08             	sub    $0x8,%esp
  100755:	6a 3a                	push   $0x3a
  100757:	50                   	push   %eax
  100758:	e8 bb 24 00 00       	call   102c18 <strfind>
  10075d:	83 c4 10             	add    $0x10,%esp
  100760:	89 c2                	mov    %eax,%edx
  100762:	8b 45 0c             	mov    0xc(%ebp),%eax
  100765:	8b 40 08             	mov    0x8(%eax),%eax
  100768:	29 c2                	sub    %eax,%edx
  10076a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10076d:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  100770:	83 ec 0c             	sub    $0xc,%esp
  100773:	ff 75 08             	pushl  0x8(%ebp)
  100776:	6a 44                	push   $0x44
  100778:	8d 45 d0             	lea    -0x30(%ebp),%eax
  10077b:	50                   	push   %eax
  10077c:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  10077f:	50                   	push   %eax
  100780:	ff 75 f4             	pushl  -0xc(%ebp)
  100783:	e8 ea fc ff ff       	call   100472 <stab_binsearch>
  100788:	83 c4 20             	add    $0x20,%esp
    if (lline <= rline) {
  10078b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10078e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100791:	39 c2                	cmp    %eax,%edx
  100793:	7f 24                	jg     1007b9 <debuginfo_eip+0x1f0>
        info->eip_line = stabs[rline].n_desc;
  100795:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100798:	89 c2                	mov    %eax,%edx
  10079a:	89 d0                	mov    %edx,%eax
  10079c:	01 c0                	add    %eax,%eax
  10079e:	01 d0                	add    %edx,%eax
  1007a0:	c1 e0 02             	shl    $0x2,%eax
  1007a3:	89 c2                	mov    %eax,%edx
  1007a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007a8:	01 d0                	add    %edx,%eax
  1007aa:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  1007ae:	0f b7 d0             	movzwl %ax,%edx
  1007b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007b4:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  1007b7:	eb 13                	jmp    1007cc <debuginfo_eip+0x203>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
  1007b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1007be:	e9 12 01 00 00       	jmp    1008d5 <debuginfo_eip+0x30c>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  1007c3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007c6:	83 e8 01             	sub    $0x1,%eax
  1007c9:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  1007cc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007d2:	39 c2                	cmp    %eax,%edx
  1007d4:	7c 56                	jl     10082c <debuginfo_eip+0x263>
           && stabs[lline].n_type != N_SOL
  1007d6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007d9:	89 c2                	mov    %eax,%edx
  1007db:	89 d0                	mov    %edx,%eax
  1007dd:	01 c0                	add    %eax,%eax
  1007df:	01 d0                	add    %edx,%eax
  1007e1:	c1 e0 02             	shl    $0x2,%eax
  1007e4:	89 c2                	mov    %eax,%edx
  1007e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007e9:	01 d0                	add    %edx,%eax
  1007eb:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1007ef:	3c 84                	cmp    $0x84,%al
  1007f1:	74 39                	je     10082c <debuginfo_eip+0x263>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  1007f3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007f6:	89 c2                	mov    %eax,%edx
  1007f8:	89 d0                	mov    %edx,%eax
  1007fa:	01 c0                	add    %eax,%eax
  1007fc:	01 d0                	add    %edx,%eax
  1007fe:	c1 e0 02             	shl    $0x2,%eax
  100801:	89 c2                	mov    %eax,%edx
  100803:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100806:	01 d0                	add    %edx,%eax
  100808:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10080c:	3c 64                	cmp    $0x64,%al
  10080e:	75 b3                	jne    1007c3 <debuginfo_eip+0x1fa>
  100810:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100813:	89 c2                	mov    %eax,%edx
  100815:	89 d0                	mov    %edx,%eax
  100817:	01 c0                	add    %eax,%eax
  100819:	01 d0                	add    %edx,%eax
  10081b:	c1 e0 02             	shl    $0x2,%eax
  10081e:	89 c2                	mov    %eax,%edx
  100820:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100823:	01 d0                	add    %edx,%eax
  100825:	8b 40 08             	mov    0x8(%eax),%eax
  100828:	85 c0                	test   %eax,%eax
  10082a:	74 97                	je     1007c3 <debuginfo_eip+0x1fa>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  10082c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10082f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100832:	39 c2                	cmp    %eax,%edx
  100834:	7c 46                	jl     10087c <debuginfo_eip+0x2b3>
  100836:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100839:	89 c2                	mov    %eax,%edx
  10083b:	89 d0                	mov    %edx,%eax
  10083d:	01 c0                	add    %eax,%eax
  10083f:	01 d0                	add    %edx,%eax
  100841:	c1 e0 02             	shl    $0x2,%eax
  100844:	89 c2                	mov    %eax,%edx
  100846:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100849:	01 d0                	add    %edx,%eax
  10084b:	8b 00                	mov    (%eax),%eax
  10084d:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  100850:	8b 55 ec             	mov    -0x14(%ebp),%edx
  100853:	29 d1                	sub    %edx,%ecx
  100855:	89 ca                	mov    %ecx,%edx
  100857:	39 d0                	cmp    %edx,%eax
  100859:	73 21                	jae    10087c <debuginfo_eip+0x2b3>
        info->eip_file = stabstr + stabs[lline].n_strx;
  10085b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10085e:	89 c2                	mov    %eax,%edx
  100860:	89 d0                	mov    %edx,%eax
  100862:	01 c0                	add    %eax,%eax
  100864:	01 d0                	add    %edx,%eax
  100866:	c1 e0 02             	shl    $0x2,%eax
  100869:	89 c2                	mov    %eax,%edx
  10086b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10086e:	01 d0                	add    %edx,%eax
  100870:	8b 10                	mov    (%eax),%edx
  100872:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100875:	01 c2                	add    %eax,%edx
  100877:	8b 45 0c             	mov    0xc(%ebp),%eax
  10087a:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  10087c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10087f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100882:	39 c2                	cmp    %eax,%edx
  100884:	7d 4a                	jge    1008d0 <debuginfo_eip+0x307>
        for (lline = lfun + 1;
  100886:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100889:	83 c0 01             	add    $0x1,%eax
  10088c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  10088f:	eb 18                	jmp    1008a9 <debuginfo_eip+0x2e0>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  100891:	8b 45 0c             	mov    0xc(%ebp),%eax
  100894:	8b 40 14             	mov    0x14(%eax),%eax
  100897:	8d 50 01             	lea    0x1(%eax),%edx
  10089a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10089d:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
  1008a0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008a3:	83 c0 01             	add    $0x1,%eax
  1008a6:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
  1008a9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1008ac:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
  1008af:	39 c2                	cmp    %eax,%edx
  1008b1:	7d 1d                	jge    1008d0 <debuginfo_eip+0x307>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  1008b3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008b6:	89 c2                	mov    %eax,%edx
  1008b8:	89 d0                	mov    %edx,%eax
  1008ba:	01 c0                	add    %eax,%eax
  1008bc:	01 d0                	add    %edx,%eax
  1008be:	c1 e0 02             	shl    $0x2,%eax
  1008c1:	89 c2                	mov    %eax,%edx
  1008c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008c6:	01 d0                	add    %edx,%eax
  1008c8:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1008cc:	3c a0                	cmp    $0xa0,%al
  1008ce:	74 c1                	je     100891 <debuginfo_eip+0x2c8>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
  1008d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1008d5:	c9                   	leave  
  1008d6:	c3                   	ret    

001008d7 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  1008d7:	55                   	push   %ebp
  1008d8:	89 e5                	mov    %esp,%ebp
  1008da:	83 ec 08             	sub    $0x8,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  1008dd:	83 ec 0c             	sub    $0xc,%esp
  1008e0:	68 32 36 10 00       	push   $0x103632
  1008e5:	e8 63 f9 ff ff       	call   10024d <cprintf>
  1008ea:	83 c4 10             	add    $0x10,%esp
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  1008ed:	83 ec 08             	sub    $0x8,%esp
  1008f0:	68 00 00 10 00       	push   $0x100000
  1008f5:	68 4b 36 10 00       	push   $0x10364b
  1008fa:	e8 4e f9 ff ff       	call   10024d <cprintf>
  1008ff:	83 c4 10             	add    $0x10,%esp
    cprintf("  etext  0x%08x (phys)\n", etext);
  100902:	83 ec 08             	sub    $0x8,%esp
  100905:	68 3b 35 10 00       	push   $0x10353b
  10090a:	68 63 36 10 00       	push   $0x103663
  10090f:	e8 39 f9 ff ff       	call   10024d <cprintf>
  100914:	83 c4 10             	add    $0x10,%esp
    cprintf("  edata  0x%08x (phys)\n", edata);
  100917:	83 ec 08             	sub    $0x8,%esp
  10091a:	68 16 ea 10 00       	push   $0x10ea16
  10091f:	68 7b 36 10 00       	push   $0x10367b
  100924:	e8 24 f9 ff ff       	call   10024d <cprintf>
  100929:	83 c4 10             	add    $0x10,%esp
    cprintf("  end    0x%08x (phys)\n", end);
  10092c:	83 ec 08             	sub    $0x8,%esp
  10092f:	68 80 fd 10 00       	push   $0x10fd80
  100934:	68 93 36 10 00       	push   $0x103693
  100939:	e8 0f f9 ff ff       	call   10024d <cprintf>
  10093e:	83 c4 10             	add    $0x10,%esp
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  100941:	b8 80 fd 10 00       	mov    $0x10fd80,%eax
  100946:	05 ff 03 00 00       	add    $0x3ff,%eax
  10094b:	ba 00 00 10 00       	mov    $0x100000,%edx
  100950:	29 d0                	sub    %edx,%eax
  100952:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  100958:	85 c0                	test   %eax,%eax
  10095a:	0f 48 c2             	cmovs  %edx,%eax
  10095d:	c1 f8 0a             	sar    $0xa,%eax
  100960:	83 ec 08             	sub    $0x8,%esp
  100963:	50                   	push   %eax
  100964:	68 ac 36 10 00       	push   $0x1036ac
  100969:	e8 df f8 ff ff       	call   10024d <cprintf>
  10096e:	83 c4 10             	add    $0x10,%esp
}
  100971:	90                   	nop
  100972:	c9                   	leave  
  100973:	c3                   	ret    

00100974 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  100974:	55                   	push   %ebp
  100975:	89 e5                	mov    %esp,%ebp
  100977:	81 ec 28 01 00 00    	sub    $0x128,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  10097d:	83 ec 08             	sub    $0x8,%esp
  100980:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100983:	50                   	push   %eax
  100984:	ff 75 08             	pushl  0x8(%ebp)
  100987:	e8 3d fc ff ff       	call   1005c9 <debuginfo_eip>
  10098c:	83 c4 10             	add    $0x10,%esp
  10098f:	85 c0                	test   %eax,%eax
  100991:	74 15                	je     1009a8 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  100993:	83 ec 08             	sub    $0x8,%esp
  100996:	ff 75 08             	pushl  0x8(%ebp)
  100999:	68 d6 36 10 00       	push   $0x1036d6
  10099e:	e8 aa f8 ff ff       	call   10024d <cprintf>
  1009a3:	83 c4 10             	add    $0x10,%esp
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
  1009a6:	eb 65                	jmp    100a0d <print_debuginfo+0x99>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  1009a8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1009af:	eb 1c                	jmp    1009cd <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  1009b1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1009b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009b7:	01 d0                	add    %edx,%eax
  1009b9:	0f b6 00             	movzbl (%eax),%eax
  1009bc:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  1009c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1009c5:	01 ca                	add    %ecx,%edx
  1009c7:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  1009c9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1009cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1009d0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1009d3:	7f dc                	jg     1009b1 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
  1009d5:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  1009db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009de:	01 d0                	add    %edx,%eax
  1009e0:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  1009e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  1009e6:	8b 55 08             	mov    0x8(%ebp),%edx
  1009e9:	89 d1                	mov    %edx,%ecx
  1009eb:	29 c1                	sub    %eax,%ecx
  1009ed:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1009f0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1009f3:	83 ec 0c             	sub    $0xc,%esp
  1009f6:	51                   	push   %ecx
  1009f7:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  1009fd:	51                   	push   %ecx
  1009fe:	52                   	push   %edx
  1009ff:	50                   	push   %eax
  100a00:	68 f2 36 10 00       	push   $0x1036f2
  100a05:	e8 43 f8 ff ff       	call   10024d <cprintf>
  100a0a:	83 c4 20             	add    $0x20,%esp
                fnname, eip - info.eip_fn_addr);
    }
}
  100a0d:	90                   	nop
  100a0e:	c9                   	leave  
  100a0f:	c3                   	ret    

00100a10 <read_eip>:

static __noinline uint32_t
read_eip(void) {
  100a10:	55                   	push   %ebp
  100a11:	89 e5                	mov    %esp,%ebp
  100a13:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100a16:	8b 45 04             	mov    0x4(%ebp),%eax
  100a19:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100a1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100a1f:	c9                   	leave  
  100a20:	c3                   	ret    

00100a21 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100a21:	55                   	push   %ebp
  100a22:	89 e5                	mov    %esp,%ebp
  100a24:	83 ec 28             	sub    $0x28,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100a27:	89 e8                	mov    %ebp,%eax
  100a29:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
  100a2c:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp(), eip = read_eip();
  100a2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100a32:	e8 d9 ff ff ff       	call   100a10 <read_eip>
  100a37:	89 45 f0             	mov    %eax,-0x10(%ebp)

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
  100a3a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  100a41:	e9 8d 00 00 00       	jmp    100ad3 <print_stackframe+0xb2>
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
  100a46:	83 ec 04             	sub    $0x4,%esp
  100a49:	ff 75 f0             	pushl  -0x10(%ebp)
  100a4c:	ff 75 f4             	pushl  -0xc(%ebp)
  100a4f:	68 04 37 10 00       	push   $0x103704
  100a54:	e8 f4 f7 ff ff       	call   10024d <cprintf>
  100a59:	83 c4 10             	add    $0x10,%esp
        uint32_t *args = (uint32_t *)ebp + 2;
  100a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a5f:	83 c0 08             	add    $0x8,%eax
  100a62:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for (j = 0; j < 4; j ++) {
  100a65:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  100a6c:	eb 26                	jmp    100a94 <print_stackframe+0x73>
            cprintf("0x%08x ", args[j]);
  100a6e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a71:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100a78:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100a7b:	01 d0                	add    %edx,%eax
  100a7d:	8b 00                	mov    (%eax),%eax
  100a7f:	83 ec 08             	sub    $0x8,%esp
  100a82:	50                   	push   %eax
  100a83:	68 20 37 10 00       	push   $0x103720
  100a88:	e8 c0 f7 ff ff       	call   10024d <cprintf>
  100a8d:	83 c4 10             	add    $0x10,%esp

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
        uint32_t *args = (uint32_t *)ebp + 2;
        for (j = 0; j < 4; j ++) {
  100a90:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  100a94:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100a98:	7e d4                	jle    100a6e <print_stackframe+0x4d>
            cprintf("0x%08x ", args[j]);
        }
        cprintf("\n");
  100a9a:	83 ec 0c             	sub    $0xc,%esp
  100a9d:	68 28 37 10 00       	push   $0x103728
  100aa2:	e8 a6 f7 ff ff       	call   10024d <cprintf>
  100aa7:	83 c4 10             	add    $0x10,%esp
        print_debuginfo(eip - 1);
  100aaa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100aad:	83 e8 01             	sub    $0x1,%eax
  100ab0:	83 ec 0c             	sub    $0xc,%esp
  100ab3:	50                   	push   %eax
  100ab4:	e8 bb fe ff ff       	call   100974 <print_debuginfo>
  100ab9:	83 c4 10             	add    $0x10,%esp
        eip = ((uint32_t *)ebp)[1];
  100abc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100abf:	83 c0 04             	add    $0x4,%eax
  100ac2:	8b 00                	mov    (%eax),%eax
  100ac4:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];
  100ac7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100aca:	8b 00                	mov    (%eax),%eax
  100acc:	89 45 f4             	mov    %eax,-0xc(%ebp)
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp(), eip = read_eip();

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
  100acf:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100ad3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100ad7:	74 0a                	je     100ae3 <print_stackframe+0xc2>
  100ad9:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100add:	0f 8e 63 ff ff ff    	jle    100a46 <print_stackframe+0x25>
        cprintf("\n");
        print_debuginfo(eip - 1);
        eip = ((uint32_t *)ebp)[1];
        ebp = ((uint32_t *)ebp)[0];
    }
}
  100ae3:	90                   	nop
  100ae4:	c9                   	leave  
  100ae5:	c3                   	ret    

00100ae6 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100ae6:	55                   	push   %ebp
  100ae7:	89 e5                	mov    %esp,%ebp
  100ae9:	83 ec 18             	sub    $0x18,%esp
    int argc = 0;
  100aec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100af3:	eb 0c                	jmp    100b01 <parse+0x1b>
            *buf ++ = '\0';
  100af5:	8b 45 08             	mov    0x8(%ebp),%eax
  100af8:	8d 50 01             	lea    0x1(%eax),%edx
  100afb:	89 55 08             	mov    %edx,0x8(%ebp)
  100afe:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b01:	8b 45 08             	mov    0x8(%ebp),%eax
  100b04:	0f b6 00             	movzbl (%eax),%eax
  100b07:	84 c0                	test   %al,%al
  100b09:	74 1e                	je     100b29 <parse+0x43>
  100b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  100b0e:	0f b6 00             	movzbl (%eax),%eax
  100b11:	0f be c0             	movsbl %al,%eax
  100b14:	83 ec 08             	sub    $0x8,%esp
  100b17:	50                   	push   %eax
  100b18:	68 ac 37 10 00       	push   $0x1037ac
  100b1d:	e8 c3 20 00 00       	call   102be5 <strchr>
  100b22:	83 c4 10             	add    $0x10,%esp
  100b25:	85 c0                	test   %eax,%eax
  100b27:	75 cc                	jne    100af5 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100b29:	8b 45 08             	mov    0x8(%ebp),%eax
  100b2c:	0f b6 00             	movzbl (%eax),%eax
  100b2f:	84 c0                	test   %al,%al
  100b31:	74 69                	je     100b9c <parse+0xb6>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100b33:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100b37:	75 12                	jne    100b4b <parse+0x65>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100b39:	83 ec 08             	sub    $0x8,%esp
  100b3c:	6a 10                	push   $0x10
  100b3e:	68 b1 37 10 00       	push   $0x1037b1
  100b43:	e8 05 f7 ff ff       	call   10024d <cprintf>
  100b48:	83 c4 10             	add    $0x10,%esp
        }
        argv[argc ++] = buf;
  100b4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b4e:	8d 50 01             	lea    0x1(%eax),%edx
  100b51:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100b54:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100b5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  100b5e:	01 c2                	add    %eax,%edx
  100b60:	8b 45 08             	mov    0x8(%ebp),%eax
  100b63:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b65:	eb 04                	jmp    100b6b <parse+0x85>
            buf ++;
  100b67:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  100b6e:	0f b6 00             	movzbl (%eax),%eax
  100b71:	84 c0                	test   %al,%al
  100b73:	0f 84 7a ff ff ff    	je     100af3 <parse+0xd>
  100b79:	8b 45 08             	mov    0x8(%ebp),%eax
  100b7c:	0f b6 00             	movzbl (%eax),%eax
  100b7f:	0f be c0             	movsbl %al,%eax
  100b82:	83 ec 08             	sub    $0x8,%esp
  100b85:	50                   	push   %eax
  100b86:	68 ac 37 10 00       	push   $0x1037ac
  100b8b:	e8 55 20 00 00       	call   102be5 <strchr>
  100b90:	83 c4 10             	add    $0x10,%esp
  100b93:	85 c0                	test   %eax,%eax
  100b95:	74 d0                	je     100b67 <parse+0x81>
            buf ++;
        }
    }
  100b97:	e9 57 ff ff ff       	jmp    100af3 <parse+0xd>
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
            break;
  100b9c:	90                   	nop
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100b9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100ba0:	c9                   	leave  
  100ba1:	c3                   	ret    

00100ba2 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100ba2:	55                   	push   %ebp
  100ba3:	89 e5                	mov    %esp,%ebp
  100ba5:	83 ec 58             	sub    $0x58,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100ba8:	83 ec 08             	sub    $0x8,%esp
  100bab:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100bae:	50                   	push   %eax
  100baf:	ff 75 08             	pushl  0x8(%ebp)
  100bb2:	e8 2f ff ff ff       	call   100ae6 <parse>
  100bb7:	83 c4 10             	add    $0x10,%esp
  100bba:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100bbd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100bc1:	75 0a                	jne    100bcd <runcmd+0x2b>
        return 0;
  100bc3:	b8 00 00 00 00       	mov    $0x0,%eax
  100bc8:	e9 83 00 00 00       	jmp    100c50 <runcmd+0xae>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100bcd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100bd4:	eb 59                	jmp    100c2f <runcmd+0x8d>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100bd6:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100bd9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100bdc:	89 d0                	mov    %edx,%eax
  100bde:	01 c0                	add    %eax,%eax
  100be0:	01 d0                	add    %edx,%eax
  100be2:	c1 e0 02             	shl    $0x2,%eax
  100be5:	05 00 e0 10 00       	add    $0x10e000,%eax
  100bea:	8b 00                	mov    (%eax),%eax
  100bec:	83 ec 08             	sub    $0x8,%esp
  100bef:	51                   	push   %ecx
  100bf0:	50                   	push   %eax
  100bf1:	e8 4f 1f 00 00       	call   102b45 <strcmp>
  100bf6:	83 c4 10             	add    $0x10,%esp
  100bf9:	85 c0                	test   %eax,%eax
  100bfb:	75 2e                	jne    100c2b <runcmd+0x89>
            return commands[i].func(argc - 1, argv + 1, tf);
  100bfd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c00:	89 d0                	mov    %edx,%eax
  100c02:	01 c0                	add    %eax,%eax
  100c04:	01 d0                	add    %edx,%eax
  100c06:	c1 e0 02             	shl    $0x2,%eax
  100c09:	05 08 e0 10 00       	add    $0x10e008,%eax
  100c0e:	8b 10                	mov    (%eax),%edx
  100c10:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100c13:	83 c0 04             	add    $0x4,%eax
  100c16:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100c19:	83 e9 01             	sub    $0x1,%ecx
  100c1c:	83 ec 04             	sub    $0x4,%esp
  100c1f:	ff 75 0c             	pushl  0xc(%ebp)
  100c22:	50                   	push   %eax
  100c23:	51                   	push   %ecx
  100c24:	ff d2                	call   *%edx
  100c26:	83 c4 10             	add    $0x10,%esp
  100c29:	eb 25                	jmp    100c50 <runcmd+0xae>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c2b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c32:	83 f8 02             	cmp    $0x2,%eax
  100c35:	76 9f                	jbe    100bd6 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100c37:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100c3a:	83 ec 08             	sub    $0x8,%esp
  100c3d:	50                   	push   %eax
  100c3e:	68 cf 37 10 00       	push   $0x1037cf
  100c43:	e8 05 f6 ff ff       	call   10024d <cprintf>
  100c48:	83 c4 10             	add    $0x10,%esp
    return 0;
  100c4b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c50:	c9                   	leave  
  100c51:	c3                   	ret    

00100c52 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100c52:	55                   	push   %ebp
  100c53:	89 e5                	mov    %esp,%ebp
  100c55:	83 ec 18             	sub    $0x18,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100c58:	83 ec 0c             	sub    $0xc,%esp
  100c5b:	68 e8 37 10 00       	push   $0x1037e8
  100c60:	e8 e8 f5 ff ff       	call   10024d <cprintf>
  100c65:	83 c4 10             	add    $0x10,%esp
    cprintf("Type 'help' for a list of commands.\n");
  100c68:	83 ec 0c             	sub    $0xc,%esp
  100c6b:	68 10 38 10 00       	push   $0x103810
  100c70:	e8 d8 f5 ff ff       	call   10024d <cprintf>
  100c75:	83 c4 10             	add    $0x10,%esp

    if (tf != NULL) {
  100c78:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100c7c:	74 0e                	je     100c8c <kmonitor+0x3a>
        print_trapframe(tf);
  100c7e:	83 ec 0c             	sub    $0xc,%esp
  100c81:	ff 75 08             	pushl  0x8(%ebp)
  100c84:	e8 32 0d 00 00       	call   1019bb <print_trapframe>
  100c89:	83 c4 10             	add    $0x10,%esp
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100c8c:	83 ec 0c             	sub    $0xc,%esp
  100c8f:	68 35 38 10 00       	push   $0x103835
  100c94:	e8 58 f6 ff ff       	call   1002f1 <readline>
  100c99:	83 c4 10             	add    $0x10,%esp
  100c9c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100c9f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100ca3:	74 e7                	je     100c8c <kmonitor+0x3a>
            if (runcmd(buf, tf) < 0) {
  100ca5:	83 ec 08             	sub    $0x8,%esp
  100ca8:	ff 75 08             	pushl  0x8(%ebp)
  100cab:	ff 75 f4             	pushl  -0xc(%ebp)
  100cae:	e8 ef fe ff ff       	call   100ba2 <runcmd>
  100cb3:	83 c4 10             	add    $0x10,%esp
  100cb6:	85 c0                	test   %eax,%eax
  100cb8:	78 02                	js     100cbc <kmonitor+0x6a>
                break;
            }
        }
    }
  100cba:	eb d0                	jmp    100c8c <kmonitor+0x3a>

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
            if (runcmd(buf, tf) < 0) {
                break;
  100cbc:	90                   	nop
            }
        }
    }
}
  100cbd:	90                   	nop
  100cbe:	c9                   	leave  
  100cbf:	c3                   	ret    

00100cc0 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100cc0:	55                   	push   %ebp
  100cc1:	89 e5                	mov    %esp,%ebp
  100cc3:	83 ec 18             	sub    $0x18,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100cc6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100ccd:	eb 3c                	jmp    100d0b <mon_help+0x4b>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100ccf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100cd2:	89 d0                	mov    %edx,%eax
  100cd4:	01 c0                	add    %eax,%eax
  100cd6:	01 d0                	add    %edx,%eax
  100cd8:	c1 e0 02             	shl    $0x2,%eax
  100cdb:	05 04 e0 10 00       	add    $0x10e004,%eax
  100ce0:	8b 08                	mov    (%eax),%ecx
  100ce2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100ce5:	89 d0                	mov    %edx,%eax
  100ce7:	01 c0                	add    %eax,%eax
  100ce9:	01 d0                	add    %edx,%eax
  100ceb:	c1 e0 02             	shl    $0x2,%eax
  100cee:	05 00 e0 10 00       	add    $0x10e000,%eax
  100cf3:	8b 00                	mov    (%eax),%eax
  100cf5:	83 ec 04             	sub    $0x4,%esp
  100cf8:	51                   	push   %ecx
  100cf9:	50                   	push   %eax
  100cfa:	68 39 38 10 00       	push   $0x103839
  100cff:	e8 49 f5 ff ff       	call   10024d <cprintf>
  100d04:	83 c4 10             	add    $0x10,%esp

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100d07:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100d0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d0e:	83 f8 02             	cmp    $0x2,%eax
  100d11:	76 bc                	jbe    100ccf <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100d13:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d18:	c9                   	leave  
  100d19:	c3                   	ret    

00100d1a <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100d1a:	55                   	push   %ebp
  100d1b:	89 e5                	mov    %esp,%ebp
  100d1d:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100d20:	e8 b2 fb ff ff       	call   1008d7 <print_kerninfo>
    return 0;
  100d25:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d2a:	c9                   	leave  
  100d2b:	c3                   	ret    

00100d2c <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100d2c:	55                   	push   %ebp
  100d2d:	89 e5                	mov    %esp,%ebp
  100d2f:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100d32:	e8 ea fc ff ff       	call   100a21 <print_stackframe>
    return 0;
  100d37:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d3c:	c9                   	leave  
  100d3d:	c3                   	ret    

00100d3e <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d3e:	55                   	push   %ebp
  100d3f:	89 e5                	mov    %esp,%ebp
  100d41:	83 ec 18             	sub    $0x18,%esp
  100d44:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100d4a:	c6 45 ef 34          	movb   $0x34,-0x11(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100d4e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
  100d52:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100d56:	ee                   	out    %al,(%dx)
  100d57:	66 c7 45 f4 40 00    	movw   $0x40,-0xc(%ebp)
  100d5d:	c6 45 f0 9c          	movb   $0x9c,-0x10(%ebp)
  100d61:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
  100d65:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
  100d69:	ee                   	out    %al,(%dx)
  100d6a:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100d70:	c6 45 f1 2e          	movb   $0x2e,-0xf(%ebp)
  100d74:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100d78:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100d7c:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100d7d:	c7 05 08 f9 10 00 00 	movl   $0x0,0x10f908
  100d84:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100d87:	83 ec 0c             	sub    $0xc,%esp
  100d8a:	68 42 38 10 00       	push   $0x103842
  100d8f:	e8 b9 f4 ff ff       	call   10024d <cprintf>
  100d94:	83 c4 10             	add    $0x10,%esp
    pic_enable(IRQ_TIMER);
  100d97:	83 ec 0c             	sub    $0xc,%esp
  100d9a:	6a 00                	push   $0x0
  100d9c:	e8 ce 08 00 00       	call   10166f <pic_enable>
  100da1:	83 c4 10             	add    $0x10,%esp
}
  100da4:	90                   	nop
  100da5:	c9                   	leave  
  100da6:	c3                   	ret    

00100da7 <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100da7:	55                   	push   %ebp
  100da8:	89 e5                	mov    %esp,%ebp
  100daa:	83 ec 10             	sub    $0x10,%esp
  100dad:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100db3:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100db7:	89 c2                	mov    %eax,%edx
  100db9:	ec                   	in     (%dx),%al
  100dba:	88 45 f4             	mov    %al,-0xc(%ebp)
  100dbd:	66 c7 45 fc 84 00    	movw   $0x84,-0x4(%ebp)
  100dc3:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
  100dc7:	89 c2                	mov    %eax,%edx
  100dc9:	ec                   	in     (%dx),%al
  100dca:	88 45 f5             	mov    %al,-0xb(%ebp)
  100dcd:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100dd3:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100dd7:	89 c2                	mov    %eax,%edx
  100dd9:	ec                   	in     (%dx),%al
  100dda:	88 45 f6             	mov    %al,-0xa(%ebp)
  100ddd:	66 c7 45 f8 84 00    	movw   $0x84,-0x8(%ebp)
  100de3:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
  100de7:	89 c2                	mov    %eax,%edx
  100de9:	ec                   	in     (%dx),%al
  100dea:	88 45 f7             	mov    %al,-0x9(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100ded:	90                   	nop
  100dee:	c9                   	leave  
  100def:	c3                   	ret    

00100df0 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100df0:	55                   	push   %ebp
  100df1:	89 e5                	mov    %esp,%ebp
  100df3:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;
  100df6:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;
  100dfd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e00:	0f b7 00             	movzwl (%eax),%eax
  100e03:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100e07:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e0a:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100e0f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e12:	0f b7 00             	movzwl (%eax),%eax
  100e15:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100e19:	74 12                	je     100e2d <cga_init+0x3d>
        cp = (uint16_t*)MONO_BUF;
  100e1b:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100e22:	66 c7 05 66 ee 10 00 	movw   $0x3b4,0x10ee66
  100e29:	b4 03 
  100e2b:	eb 13                	jmp    100e40 <cga_init+0x50>
    } else {
        *cp = was;
  100e2d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e30:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100e34:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100e37:	66 c7 05 66 ee 10 00 	movw   $0x3d4,0x10ee66
  100e3e:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100e40:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e47:	0f b7 c0             	movzwl %ax,%eax
  100e4a:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
  100e4e:	c6 45 ea 0e          	movb   $0xe,-0x16(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e52:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
  100e56:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  100e5a:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  100e5b:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e62:	83 c0 01             	add    $0x1,%eax
  100e65:	0f b7 c0             	movzwl %ax,%eax
  100e68:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100e6c:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e70:	89 c2                	mov    %eax,%edx
  100e72:	ec                   	in     (%dx),%al
  100e73:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  100e76:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
  100e7a:	0f b6 c0             	movzbl %al,%eax
  100e7d:	c1 e0 08             	shl    $0x8,%eax
  100e80:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100e83:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e8a:	0f b7 c0             	movzwl %ax,%eax
  100e8d:	66 89 45 f0          	mov    %ax,-0x10(%ebp)
  100e91:	c6 45 ec 0f          	movb   $0xf,-0x14(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e95:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
  100e99:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  100e9d:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  100e9e:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100ea5:	83 c0 01             	add    $0x1,%eax
  100ea8:	0f b7 c0             	movzwl %ax,%eax
  100eab:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100eaf:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100eb3:	89 c2                	mov    %eax,%edx
  100eb5:	ec                   	in     (%dx),%al
  100eb6:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100eb9:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100ebd:	0f b6 c0             	movzbl %al,%eax
  100ec0:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100ec3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ec6:	a3 60 ee 10 00       	mov    %eax,0x10ee60
    crt_pos = pos;
  100ecb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ece:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
}
  100ed4:	90                   	nop
  100ed5:	c9                   	leave  
  100ed6:	c3                   	ret    

00100ed7 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100ed7:	55                   	push   %ebp
  100ed8:	89 e5                	mov    %esp,%ebp
  100eda:	83 ec 28             	sub    $0x28,%esp
  100edd:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100ee3:	c6 45 da 00          	movb   $0x0,-0x26(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100ee7:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
  100eeb:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100eef:	ee                   	out    %al,(%dx)
  100ef0:	66 c7 45 f4 fb 03    	movw   $0x3fb,-0xc(%ebp)
  100ef6:	c6 45 db 80          	movb   $0x80,-0x25(%ebp)
  100efa:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
  100efe:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
  100f02:	ee                   	out    %al,(%dx)
  100f03:	66 c7 45 f2 f8 03    	movw   $0x3f8,-0xe(%ebp)
  100f09:	c6 45 dc 0c          	movb   $0xc,-0x24(%ebp)
  100f0d:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
  100f11:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100f15:	ee                   	out    %al,(%dx)
  100f16:	66 c7 45 f0 f9 03    	movw   $0x3f9,-0x10(%ebp)
  100f1c:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
  100f20:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100f24:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  100f28:	ee                   	out    %al,(%dx)
  100f29:	66 c7 45 ee fb 03    	movw   $0x3fb,-0x12(%ebp)
  100f2f:	c6 45 de 03          	movb   $0x3,-0x22(%ebp)
  100f33:	0f b6 45 de          	movzbl -0x22(%ebp),%eax
  100f37:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f3b:	ee                   	out    %al,(%dx)
  100f3c:	66 c7 45 ec fc 03    	movw   $0x3fc,-0x14(%ebp)
  100f42:	c6 45 df 00          	movb   $0x0,-0x21(%ebp)
  100f46:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
  100f4a:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
  100f4e:	ee                   	out    %al,(%dx)
  100f4f:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100f55:	c6 45 e0 01          	movb   $0x1,-0x20(%ebp)
  100f59:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
  100f5d:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f61:	ee                   	out    %al,(%dx)
  100f62:	66 c7 45 e8 fd 03    	movw   $0x3fd,-0x18(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f68:	0f b7 45 e8          	movzwl -0x18(%ebp),%eax
  100f6c:	89 c2                	mov    %eax,%edx
  100f6e:	ec                   	in     (%dx),%al
  100f6f:	88 45 e1             	mov    %al,-0x1f(%ebp)
    return data;
  100f72:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100f76:	3c ff                	cmp    $0xff,%al
  100f78:	0f 95 c0             	setne  %al
  100f7b:	0f b6 c0             	movzbl %al,%eax
  100f7e:	a3 68 ee 10 00       	mov    %eax,0x10ee68
  100f83:	66 c7 45 e6 fa 03    	movw   $0x3fa,-0x1a(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f89:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100f8d:	89 c2                	mov    %eax,%edx
  100f8f:	ec                   	in     (%dx),%al
  100f90:	88 45 e2             	mov    %al,-0x1e(%ebp)
  100f93:	66 c7 45 e4 f8 03    	movw   $0x3f8,-0x1c(%ebp)
  100f99:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
  100f9d:	89 c2                	mov    %eax,%edx
  100f9f:	ec                   	in     (%dx),%al
  100fa0:	88 45 e3             	mov    %al,-0x1d(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  100fa3:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  100fa8:	85 c0                	test   %eax,%eax
  100faa:	74 0d                	je     100fb9 <serial_init+0xe2>
        pic_enable(IRQ_COM1);
  100fac:	83 ec 0c             	sub    $0xc,%esp
  100faf:	6a 04                	push   $0x4
  100fb1:	e8 b9 06 00 00       	call   10166f <pic_enable>
  100fb6:	83 c4 10             	add    $0x10,%esp
    }
}
  100fb9:	90                   	nop
  100fba:	c9                   	leave  
  100fbb:	c3                   	ret    

00100fbc <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  100fbc:	55                   	push   %ebp
  100fbd:	89 e5                	mov    %esp,%ebp
  100fbf:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100fc2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100fc9:	eb 09                	jmp    100fd4 <lpt_putc_sub+0x18>
        delay();
  100fcb:	e8 d7 fd ff ff       	call   100da7 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100fd0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  100fd4:	66 c7 45 f4 79 03    	movw   $0x379,-0xc(%ebp)
  100fda:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100fde:	89 c2                	mov    %eax,%edx
  100fe0:	ec                   	in     (%dx),%al
  100fe1:	88 45 f3             	mov    %al,-0xd(%ebp)
    return data;
  100fe4:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  100fe8:	84 c0                	test   %al,%al
  100fea:	78 09                	js     100ff5 <lpt_putc_sub+0x39>
  100fec:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  100ff3:	7e d6                	jle    100fcb <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  100ff5:	8b 45 08             	mov    0x8(%ebp),%eax
  100ff8:	0f b6 c0             	movzbl %al,%eax
  100ffb:	66 c7 45 f8 78 03    	movw   $0x378,-0x8(%ebp)
  101001:	88 45 f0             	mov    %al,-0x10(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101004:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
  101008:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  10100c:	ee                   	out    %al,(%dx)
  10100d:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  101013:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  101017:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10101b:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10101f:	ee                   	out    %al,(%dx)
  101020:	66 c7 45 fa 7a 03    	movw   $0x37a,-0x6(%ebp)
  101026:	c6 45 f2 08          	movb   $0x8,-0xe(%ebp)
  10102a:	0f b6 45 f2          	movzbl -0xe(%ebp),%eax
  10102e:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101032:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  101033:	90                   	nop
  101034:	c9                   	leave  
  101035:	c3                   	ret    

00101036 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  101036:	55                   	push   %ebp
  101037:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
  101039:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  10103d:	74 0d                	je     10104c <lpt_putc+0x16>
        lpt_putc_sub(c);
  10103f:	ff 75 08             	pushl  0x8(%ebp)
  101042:	e8 75 ff ff ff       	call   100fbc <lpt_putc_sub>
  101047:	83 c4 04             	add    $0x4,%esp
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  10104a:	eb 1e                	jmp    10106a <lpt_putc+0x34>
lpt_putc(int c) {
    if (c != '\b') {
        lpt_putc_sub(c);
    }
    else {
        lpt_putc_sub('\b');
  10104c:	6a 08                	push   $0x8
  10104e:	e8 69 ff ff ff       	call   100fbc <lpt_putc_sub>
  101053:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub(' ');
  101056:	6a 20                	push   $0x20
  101058:	e8 5f ff ff ff       	call   100fbc <lpt_putc_sub>
  10105d:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub('\b');
  101060:	6a 08                	push   $0x8
  101062:	e8 55 ff ff ff       	call   100fbc <lpt_putc_sub>
  101067:	83 c4 04             	add    $0x4,%esp
    }
}
  10106a:	90                   	nop
  10106b:	c9                   	leave  
  10106c:	c3                   	ret    

0010106d <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  10106d:	55                   	push   %ebp
  10106e:	89 e5                	mov    %esp,%ebp
  101070:	53                   	push   %ebx
  101071:	83 ec 14             	sub    $0x14,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  101074:	8b 45 08             	mov    0x8(%ebp),%eax
  101077:	b0 00                	mov    $0x0,%al
  101079:	85 c0                	test   %eax,%eax
  10107b:	75 07                	jne    101084 <cga_putc+0x17>
        c |= 0x0700;
  10107d:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  101084:	8b 45 08             	mov    0x8(%ebp),%eax
  101087:	0f b6 c0             	movzbl %al,%eax
  10108a:	83 f8 0a             	cmp    $0xa,%eax
  10108d:	74 4e                	je     1010dd <cga_putc+0x70>
  10108f:	83 f8 0d             	cmp    $0xd,%eax
  101092:	74 59                	je     1010ed <cga_putc+0x80>
  101094:	83 f8 08             	cmp    $0x8,%eax
  101097:	0f 85 8a 00 00 00    	jne    101127 <cga_putc+0xba>
    case '\b':
        if (crt_pos > 0) {
  10109d:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010a4:	66 85 c0             	test   %ax,%ax
  1010a7:	0f 84 a0 00 00 00    	je     10114d <cga_putc+0xe0>
            crt_pos --;
  1010ad:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010b4:	83 e8 01             	sub    $0x1,%eax
  1010b7:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  1010bd:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1010c2:	0f b7 15 64 ee 10 00 	movzwl 0x10ee64,%edx
  1010c9:	0f b7 d2             	movzwl %dx,%edx
  1010cc:	01 d2                	add    %edx,%edx
  1010ce:	01 d0                	add    %edx,%eax
  1010d0:	8b 55 08             	mov    0x8(%ebp),%edx
  1010d3:	b2 00                	mov    $0x0,%dl
  1010d5:	83 ca 20             	or     $0x20,%edx
  1010d8:	66 89 10             	mov    %dx,(%eax)
        }
        break;
  1010db:	eb 70                	jmp    10114d <cga_putc+0xe0>
    case '\n':
        crt_pos += CRT_COLS;
  1010dd:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010e4:	83 c0 50             	add    $0x50,%eax
  1010e7:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  1010ed:	0f b7 1d 64 ee 10 00 	movzwl 0x10ee64,%ebx
  1010f4:	0f b7 0d 64 ee 10 00 	movzwl 0x10ee64,%ecx
  1010fb:	0f b7 c1             	movzwl %cx,%eax
  1010fe:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  101104:	c1 e8 10             	shr    $0x10,%eax
  101107:	89 c2                	mov    %eax,%edx
  101109:	66 c1 ea 06          	shr    $0x6,%dx
  10110d:	89 d0                	mov    %edx,%eax
  10110f:	c1 e0 02             	shl    $0x2,%eax
  101112:	01 d0                	add    %edx,%eax
  101114:	c1 e0 04             	shl    $0x4,%eax
  101117:	29 c1                	sub    %eax,%ecx
  101119:	89 ca                	mov    %ecx,%edx
  10111b:	89 d8                	mov    %ebx,%eax
  10111d:	29 d0                	sub    %edx,%eax
  10111f:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
        break;
  101125:	eb 27                	jmp    10114e <cga_putc+0xe1>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  101127:	8b 0d 60 ee 10 00    	mov    0x10ee60,%ecx
  10112d:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101134:	8d 50 01             	lea    0x1(%eax),%edx
  101137:	66 89 15 64 ee 10 00 	mov    %dx,0x10ee64
  10113e:	0f b7 c0             	movzwl %ax,%eax
  101141:	01 c0                	add    %eax,%eax
  101143:	01 c8                	add    %ecx,%eax
  101145:	8b 55 08             	mov    0x8(%ebp),%edx
  101148:	66 89 10             	mov    %dx,(%eax)
        break;
  10114b:	eb 01                	jmp    10114e <cga_putc+0xe1>
    case '\b':
        if (crt_pos > 0) {
            crt_pos --;
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
        }
        break;
  10114d:	90                   	nop
        crt_buf[crt_pos ++] = c;     // write the character
        break;
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  10114e:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101155:	66 3d cf 07          	cmp    $0x7cf,%ax
  101159:	76 59                	jbe    1011b4 <cga_putc+0x147>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  10115b:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  101160:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  101166:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  10116b:	83 ec 04             	sub    $0x4,%esp
  10116e:	68 00 0f 00 00       	push   $0xf00
  101173:	52                   	push   %edx
  101174:	50                   	push   %eax
  101175:	e8 6a 1c 00 00       	call   102de4 <memmove>
  10117a:	83 c4 10             	add    $0x10,%esp
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  10117d:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  101184:	eb 15                	jmp    10119b <cga_putc+0x12e>
            crt_buf[i] = 0x0700 | ' ';
  101186:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  10118b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10118e:	01 d2                	add    %edx,%edx
  101190:	01 d0                	add    %edx,%eax
  101192:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101197:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  10119b:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  1011a2:	7e e2                	jle    101186 <cga_putc+0x119>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  1011a4:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011ab:	83 e8 50             	sub    $0x50,%eax
  1011ae:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  1011b4:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  1011bb:	0f b7 c0             	movzwl %ax,%eax
  1011be:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  1011c2:	c6 45 e8 0e          	movb   $0xe,-0x18(%ebp)
  1011c6:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
  1011ca:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1011ce:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  1011cf:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011d6:	66 c1 e8 08          	shr    $0x8,%ax
  1011da:	0f b6 c0             	movzbl %al,%eax
  1011dd:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  1011e4:	83 c2 01             	add    $0x1,%edx
  1011e7:	0f b7 d2             	movzwl %dx,%edx
  1011ea:	66 89 55 f0          	mov    %dx,-0x10(%ebp)
  1011ee:	88 45 e9             	mov    %al,-0x17(%ebp)
  1011f1:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1011f5:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  1011f9:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  1011fa:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  101201:	0f b7 c0             	movzwl %ax,%eax
  101204:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  101208:	c6 45 ea 0f          	movb   $0xf,-0x16(%ebp)
  10120c:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
  101210:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101214:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  101215:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10121c:	0f b6 c0             	movzbl %al,%eax
  10121f:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  101226:	83 c2 01             	add    $0x1,%edx
  101229:	0f b7 d2             	movzwl %dx,%edx
  10122c:	66 89 55 ec          	mov    %dx,-0x14(%ebp)
  101230:	88 45 eb             	mov    %al,-0x15(%ebp)
  101233:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
  101237:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
  10123b:	ee                   	out    %al,(%dx)
}
  10123c:	90                   	nop
  10123d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  101240:	c9                   	leave  
  101241:	c3                   	ret    

00101242 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  101242:	55                   	push   %ebp
  101243:	89 e5                	mov    %esp,%ebp
  101245:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101248:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10124f:	eb 09                	jmp    10125a <serial_putc_sub+0x18>
        delay();
  101251:	e8 51 fb ff ff       	call   100da7 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101256:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10125a:	66 c7 45 f8 fd 03    	movw   $0x3fd,-0x8(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101260:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
  101264:	89 c2                	mov    %eax,%edx
  101266:	ec                   	in     (%dx),%al
  101267:	88 45 f7             	mov    %al,-0x9(%ebp)
    return data;
  10126a:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  10126e:	0f b6 c0             	movzbl %al,%eax
  101271:	83 e0 20             	and    $0x20,%eax
  101274:	85 c0                	test   %eax,%eax
  101276:	75 09                	jne    101281 <serial_putc_sub+0x3f>
  101278:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  10127f:	7e d0                	jle    101251 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  101281:	8b 45 08             	mov    0x8(%ebp),%eax
  101284:	0f b6 c0             	movzbl %al,%eax
  101287:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
  10128d:	88 45 f6             	mov    %al,-0xa(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101290:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
  101294:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101298:	ee                   	out    %al,(%dx)
}
  101299:	90                   	nop
  10129a:	c9                   	leave  
  10129b:	c3                   	ret    

0010129c <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  10129c:	55                   	push   %ebp
  10129d:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
  10129f:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1012a3:	74 0d                	je     1012b2 <serial_putc+0x16>
        serial_putc_sub(c);
  1012a5:	ff 75 08             	pushl  0x8(%ebp)
  1012a8:	e8 95 ff ff ff       	call   101242 <serial_putc_sub>
  1012ad:	83 c4 04             	add    $0x4,%esp
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  1012b0:	eb 1e                	jmp    1012d0 <serial_putc+0x34>
serial_putc(int c) {
    if (c != '\b') {
        serial_putc_sub(c);
    }
    else {
        serial_putc_sub('\b');
  1012b2:	6a 08                	push   $0x8
  1012b4:	e8 89 ff ff ff       	call   101242 <serial_putc_sub>
  1012b9:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub(' ');
  1012bc:	6a 20                	push   $0x20
  1012be:	e8 7f ff ff ff       	call   101242 <serial_putc_sub>
  1012c3:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub('\b');
  1012c6:	6a 08                	push   $0x8
  1012c8:	e8 75 ff ff ff       	call   101242 <serial_putc_sub>
  1012cd:	83 c4 04             	add    $0x4,%esp
    }
}
  1012d0:	90                   	nop
  1012d1:	c9                   	leave  
  1012d2:	c3                   	ret    

001012d3 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  1012d3:	55                   	push   %ebp
  1012d4:	89 e5                	mov    %esp,%ebp
  1012d6:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  1012d9:	eb 33                	jmp    10130e <cons_intr+0x3b>
        if (c != 0) {
  1012db:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1012df:	74 2d                	je     10130e <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  1012e1:	a1 84 f0 10 00       	mov    0x10f084,%eax
  1012e6:	8d 50 01             	lea    0x1(%eax),%edx
  1012e9:	89 15 84 f0 10 00    	mov    %edx,0x10f084
  1012ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1012f2:	88 90 80 ee 10 00    	mov    %dl,0x10ee80(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  1012f8:	a1 84 f0 10 00       	mov    0x10f084,%eax
  1012fd:	3d 00 02 00 00       	cmp    $0x200,%eax
  101302:	75 0a                	jne    10130e <cons_intr+0x3b>
                cons.wpos = 0;
  101304:	c7 05 84 f0 10 00 00 	movl   $0x0,0x10f084
  10130b:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  10130e:	8b 45 08             	mov    0x8(%ebp),%eax
  101311:	ff d0                	call   *%eax
  101313:	89 45 f4             	mov    %eax,-0xc(%ebp)
  101316:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  10131a:	75 bf                	jne    1012db <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  10131c:	90                   	nop
  10131d:	c9                   	leave  
  10131e:	c3                   	ret    

0010131f <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  10131f:	55                   	push   %ebp
  101320:	89 e5                	mov    %esp,%ebp
  101322:	83 ec 10             	sub    $0x10,%esp
  101325:	66 c7 45 f8 fd 03    	movw   $0x3fd,-0x8(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10132b:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
  10132f:	89 c2                	mov    %eax,%edx
  101331:	ec                   	in     (%dx),%al
  101332:	88 45 f7             	mov    %al,-0x9(%ebp)
    return data;
  101335:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  101339:	0f b6 c0             	movzbl %al,%eax
  10133c:	83 e0 01             	and    $0x1,%eax
  10133f:	85 c0                	test   %eax,%eax
  101341:	75 07                	jne    10134a <serial_proc_data+0x2b>
        return -1;
  101343:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101348:	eb 2a                	jmp    101374 <serial_proc_data+0x55>
  10134a:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101350:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101354:	89 c2                	mov    %eax,%edx
  101356:	ec                   	in     (%dx),%al
  101357:	88 45 f6             	mov    %al,-0xa(%ebp)
    return data;
  10135a:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  10135e:	0f b6 c0             	movzbl %al,%eax
  101361:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  101364:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  101368:	75 07                	jne    101371 <serial_proc_data+0x52>
        c = '\b';
  10136a:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  101371:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  101374:	c9                   	leave  
  101375:	c3                   	ret    

00101376 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  101376:	55                   	push   %ebp
  101377:	89 e5                	mov    %esp,%ebp
  101379:	83 ec 08             	sub    $0x8,%esp
    if (serial_exists) {
  10137c:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  101381:	85 c0                	test   %eax,%eax
  101383:	74 10                	je     101395 <serial_intr+0x1f>
        cons_intr(serial_proc_data);
  101385:	83 ec 0c             	sub    $0xc,%esp
  101388:	68 1f 13 10 00       	push   $0x10131f
  10138d:	e8 41 ff ff ff       	call   1012d3 <cons_intr>
  101392:	83 c4 10             	add    $0x10,%esp
    }
}
  101395:	90                   	nop
  101396:	c9                   	leave  
  101397:	c3                   	ret    

00101398 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  101398:	55                   	push   %ebp
  101399:	89 e5                	mov    %esp,%ebp
  10139b:	83 ec 18             	sub    $0x18,%esp
  10139e:	66 c7 45 ec 64 00    	movw   $0x64,-0x14(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013a4:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1013a8:	89 c2                	mov    %eax,%edx
  1013aa:	ec                   	in     (%dx),%al
  1013ab:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  1013ae:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  1013b2:	0f b6 c0             	movzbl %al,%eax
  1013b5:	83 e0 01             	and    $0x1,%eax
  1013b8:	85 c0                	test   %eax,%eax
  1013ba:	75 0a                	jne    1013c6 <kbd_proc_data+0x2e>
        return -1;
  1013bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013c1:	e9 5d 01 00 00       	jmp    101523 <kbd_proc_data+0x18b>
  1013c6:	66 c7 45 f0 60 00    	movw   $0x60,-0x10(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013cc:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1013d0:	89 c2                	mov    %eax,%edx
  1013d2:	ec                   	in     (%dx),%al
  1013d3:	88 45 ea             	mov    %al,-0x16(%ebp)
    return data;
  1013d6:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
    }

    data = inb(KBDATAP);
  1013da:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  1013dd:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  1013e1:	75 17                	jne    1013fa <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  1013e3:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1013e8:	83 c8 40             	or     $0x40,%eax
  1013eb:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  1013f0:	b8 00 00 00 00       	mov    $0x0,%eax
  1013f5:	e9 29 01 00 00       	jmp    101523 <kbd_proc_data+0x18b>
    } else if (data & 0x80) {
  1013fa:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1013fe:	84 c0                	test   %al,%al
  101400:	79 47                	jns    101449 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101402:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101407:	83 e0 40             	and    $0x40,%eax
  10140a:	85 c0                	test   %eax,%eax
  10140c:	75 09                	jne    101417 <kbd_proc_data+0x7f>
  10140e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101412:	83 e0 7f             	and    $0x7f,%eax
  101415:	eb 04                	jmp    10141b <kbd_proc_data+0x83>
  101417:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10141b:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  10141e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101422:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  101429:	83 c8 40             	or     $0x40,%eax
  10142c:	0f b6 c0             	movzbl %al,%eax
  10142f:	f7 d0                	not    %eax
  101431:	89 c2                	mov    %eax,%edx
  101433:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101438:	21 d0                	and    %edx,%eax
  10143a:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  10143f:	b8 00 00 00 00       	mov    $0x0,%eax
  101444:	e9 da 00 00 00       	jmp    101523 <kbd_proc_data+0x18b>
    } else if (shift & E0ESC) {
  101449:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10144e:	83 e0 40             	and    $0x40,%eax
  101451:	85 c0                	test   %eax,%eax
  101453:	74 11                	je     101466 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  101455:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  101459:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10145e:	83 e0 bf             	and    $0xffffffbf,%eax
  101461:	a3 88 f0 10 00       	mov    %eax,0x10f088
    }

    shift |= shiftcode[data];
  101466:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10146a:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  101471:	0f b6 d0             	movzbl %al,%edx
  101474:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101479:	09 d0                	or     %edx,%eax
  10147b:	a3 88 f0 10 00       	mov    %eax,0x10f088
    shift ^= togglecode[data];
  101480:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101484:	0f b6 80 40 e1 10 00 	movzbl 0x10e140(%eax),%eax
  10148b:	0f b6 d0             	movzbl %al,%edx
  10148e:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101493:	31 d0                	xor    %edx,%eax
  101495:	a3 88 f0 10 00       	mov    %eax,0x10f088

    c = charcode[shift & (CTL | SHIFT)][data];
  10149a:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10149f:	83 e0 03             	and    $0x3,%eax
  1014a2:	8b 14 85 40 e5 10 00 	mov    0x10e540(,%eax,4),%edx
  1014a9:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014ad:	01 d0                	add    %edx,%eax
  1014af:	0f b6 00             	movzbl (%eax),%eax
  1014b2:	0f b6 c0             	movzbl %al,%eax
  1014b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  1014b8:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014bd:	83 e0 08             	and    $0x8,%eax
  1014c0:	85 c0                	test   %eax,%eax
  1014c2:	74 22                	je     1014e6 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  1014c4:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  1014c8:	7e 0c                	jle    1014d6 <kbd_proc_data+0x13e>
  1014ca:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  1014ce:	7f 06                	jg     1014d6 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  1014d0:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  1014d4:	eb 10                	jmp    1014e6 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  1014d6:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  1014da:	7e 0a                	jle    1014e6 <kbd_proc_data+0x14e>
  1014dc:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  1014e0:	7f 04                	jg     1014e6 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  1014e2:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  1014e6:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014eb:	f7 d0                	not    %eax
  1014ed:	83 e0 06             	and    $0x6,%eax
  1014f0:	85 c0                	test   %eax,%eax
  1014f2:	75 2c                	jne    101520 <kbd_proc_data+0x188>
  1014f4:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  1014fb:	75 23                	jne    101520 <kbd_proc_data+0x188>
        cprintf("Rebooting!\n");
  1014fd:	83 ec 0c             	sub    $0xc,%esp
  101500:	68 5d 38 10 00       	push   $0x10385d
  101505:	e8 43 ed ff ff       	call   10024d <cprintf>
  10150a:	83 c4 10             	add    $0x10,%esp
  10150d:	66 c7 45 ee 92 00    	movw   $0x92,-0x12(%ebp)
  101513:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101517:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10151b:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10151f:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  101520:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101523:	c9                   	leave  
  101524:	c3                   	ret    

00101525 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  101525:	55                   	push   %ebp
  101526:	89 e5                	mov    %esp,%ebp
  101528:	83 ec 08             	sub    $0x8,%esp
    cons_intr(kbd_proc_data);
  10152b:	83 ec 0c             	sub    $0xc,%esp
  10152e:	68 98 13 10 00       	push   $0x101398
  101533:	e8 9b fd ff ff       	call   1012d3 <cons_intr>
  101538:	83 c4 10             	add    $0x10,%esp
}
  10153b:	90                   	nop
  10153c:	c9                   	leave  
  10153d:	c3                   	ret    

0010153e <kbd_init>:

static void
kbd_init(void) {
  10153e:	55                   	push   %ebp
  10153f:	89 e5                	mov    %esp,%ebp
  101541:	83 ec 08             	sub    $0x8,%esp
    // drain the kbd buffer
    kbd_intr();
  101544:	e8 dc ff ff ff       	call   101525 <kbd_intr>
    pic_enable(IRQ_KBD);
  101549:	83 ec 0c             	sub    $0xc,%esp
  10154c:	6a 01                	push   $0x1
  10154e:	e8 1c 01 00 00       	call   10166f <pic_enable>
  101553:	83 c4 10             	add    $0x10,%esp
}
  101556:	90                   	nop
  101557:	c9                   	leave  
  101558:	c3                   	ret    

00101559 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  101559:	55                   	push   %ebp
  10155a:	89 e5                	mov    %esp,%ebp
  10155c:	83 ec 08             	sub    $0x8,%esp
    cga_init();
  10155f:	e8 8c f8 ff ff       	call   100df0 <cga_init>
    serial_init();
  101564:	e8 6e f9 ff ff       	call   100ed7 <serial_init>
    kbd_init();
  101569:	e8 d0 ff ff ff       	call   10153e <kbd_init>
    if (!serial_exists) {
  10156e:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  101573:	85 c0                	test   %eax,%eax
  101575:	75 10                	jne    101587 <cons_init+0x2e>
        cprintf("serial port does not exist!!\n");
  101577:	83 ec 0c             	sub    $0xc,%esp
  10157a:	68 69 38 10 00       	push   $0x103869
  10157f:	e8 c9 ec ff ff       	call   10024d <cprintf>
  101584:	83 c4 10             	add    $0x10,%esp
    }
}
  101587:	90                   	nop
  101588:	c9                   	leave  
  101589:	c3                   	ret    

0010158a <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  10158a:	55                   	push   %ebp
  10158b:	89 e5                	mov    %esp,%ebp
  10158d:	83 ec 08             	sub    $0x8,%esp
    lpt_putc(c);
  101590:	ff 75 08             	pushl  0x8(%ebp)
  101593:	e8 9e fa ff ff       	call   101036 <lpt_putc>
  101598:	83 c4 04             	add    $0x4,%esp
    cga_putc(c);
  10159b:	83 ec 0c             	sub    $0xc,%esp
  10159e:	ff 75 08             	pushl  0x8(%ebp)
  1015a1:	e8 c7 fa ff ff       	call   10106d <cga_putc>
  1015a6:	83 c4 10             	add    $0x10,%esp
    serial_putc(c);
  1015a9:	83 ec 0c             	sub    $0xc,%esp
  1015ac:	ff 75 08             	pushl  0x8(%ebp)
  1015af:	e8 e8 fc ff ff       	call   10129c <serial_putc>
  1015b4:	83 c4 10             	add    $0x10,%esp
}
  1015b7:	90                   	nop
  1015b8:	c9                   	leave  
  1015b9:	c3                   	ret    

001015ba <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  1015ba:	55                   	push   %ebp
  1015bb:	89 e5                	mov    %esp,%ebp
  1015bd:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  1015c0:	e8 b1 fd ff ff       	call   101376 <serial_intr>
    kbd_intr();
  1015c5:	e8 5b ff ff ff       	call   101525 <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  1015ca:	8b 15 80 f0 10 00    	mov    0x10f080,%edx
  1015d0:	a1 84 f0 10 00       	mov    0x10f084,%eax
  1015d5:	39 c2                	cmp    %eax,%edx
  1015d7:	74 36                	je     10160f <cons_getc+0x55>
        c = cons.buf[cons.rpos ++];
  1015d9:	a1 80 f0 10 00       	mov    0x10f080,%eax
  1015de:	8d 50 01             	lea    0x1(%eax),%edx
  1015e1:	89 15 80 f0 10 00    	mov    %edx,0x10f080
  1015e7:	0f b6 80 80 ee 10 00 	movzbl 0x10ee80(%eax),%eax
  1015ee:	0f b6 c0             	movzbl %al,%eax
  1015f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  1015f4:	a1 80 f0 10 00       	mov    0x10f080,%eax
  1015f9:	3d 00 02 00 00       	cmp    $0x200,%eax
  1015fe:	75 0a                	jne    10160a <cons_getc+0x50>
            cons.rpos = 0;
  101600:	c7 05 80 f0 10 00 00 	movl   $0x0,0x10f080
  101607:	00 00 00 
        }
        return c;
  10160a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10160d:	eb 05                	jmp    101614 <cons_getc+0x5a>
    }
    return 0;
  10160f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  101614:	c9                   	leave  
  101615:	c3                   	ret    

00101616 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  101616:	55                   	push   %ebp
  101617:	89 e5                	mov    %esp,%ebp
  101619:	83 ec 14             	sub    $0x14,%esp
  10161c:	8b 45 08             	mov    0x8(%ebp),%eax
  10161f:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  101623:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101627:	66 a3 50 e5 10 00    	mov    %ax,0x10e550
    if (did_init) {
  10162d:	a1 8c f0 10 00       	mov    0x10f08c,%eax
  101632:	85 c0                	test   %eax,%eax
  101634:	74 36                	je     10166c <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  101636:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10163a:	0f b6 c0             	movzbl %al,%eax
  10163d:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  101643:	88 45 fa             	mov    %al,-0x6(%ebp)
  101646:	0f b6 45 fa          	movzbl -0x6(%ebp),%eax
  10164a:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  10164e:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  10164f:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101653:	66 c1 e8 08          	shr    $0x8,%ax
  101657:	0f b6 c0             	movzbl %al,%eax
  10165a:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
  101660:	88 45 fb             	mov    %al,-0x5(%ebp)
  101663:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
  101667:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
  10166b:	ee                   	out    %al,(%dx)
    }
}
  10166c:	90                   	nop
  10166d:	c9                   	leave  
  10166e:	c3                   	ret    

0010166f <pic_enable>:

void
pic_enable(unsigned int irq) {
  10166f:	55                   	push   %ebp
  101670:	89 e5                	mov    %esp,%ebp
    pic_setmask(irq_mask & ~(1 << irq));
  101672:	8b 45 08             	mov    0x8(%ebp),%eax
  101675:	ba 01 00 00 00       	mov    $0x1,%edx
  10167a:	89 c1                	mov    %eax,%ecx
  10167c:	d3 e2                	shl    %cl,%edx
  10167e:	89 d0                	mov    %edx,%eax
  101680:	f7 d0                	not    %eax
  101682:	89 c2                	mov    %eax,%edx
  101684:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  10168b:	21 d0                	and    %edx,%eax
  10168d:	0f b7 c0             	movzwl %ax,%eax
  101690:	50                   	push   %eax
  101691:	e8 80 ff ff ff       	call   101616 <pic_setmask>
  101696:	83 c4 04             	add    $0x4,%esp
}
  101699:	90                   	nop
  10169a:	c9                   	leave  
  10169b:	c3                   	ret    

0010169c <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  10169c:	55                   	push   %ebp
  10169d:	89 e5                	mov    %esp,%ebp
  10169f:	83 ec 30             	sub    $0x30,%esp
    did_init = 1;
  1016a2:	c7 05 8c f0 10 00 01 	movl   $0x1,0x10f08c
  1016a9:	00 00 00 
  1016ac:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1016b2:	c6 45 d6 ff          	movb   $0xff,-0x2a(%ebp)
  1016b6:	0f b6 45 d6          	movzbl -0x2a(%ebp),%eax
  1016ba:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016be:	ee                   	out    %al,(%dx)
  1016bf:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
  1016c5:	c6 45 d7 ff          	movb   $0xff,-0x29(%ebp)
  1016c9:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
  1016cd:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
  1016d1:	ee                   	out    %al,(%dx)
  1016d2:	66 c7 45 fa 20 00    	movw   $0x20,-0x6(%ebp)
  1016d8:	c6 45 d8 11          	movb   $0x11,-0x28(%ebp)
  1016dc:	0f b6 45 d8          	movzbl -0x28(%ebp),%eax
  1016e0:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1016e4:	ee                   	out    %al,(%dx)
  1016e5:	66 c7 45 f8 21 00    	movw   $0x21,-0x8(%ebp)
  1016eb:	c6 45 d9 20          	movb   $0x20,-0x27(%ebp)
  1016ef:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  1016f3:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  1016f7:	ee                   	out    %al,(%dx)
  1016f8:	66 c7 45 f6 21 00    	movw   $0x21,-0xa(%ebp)
  1016fe:	c6 45 da 04          	movb   $0x4,-0x26(%ebp)
  101702:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
  101706:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10170a:	ee                   	out    %al,(%dx)
  10170b:	66 c7 45 f4 21 00    	movw   $0x21,-0xc(%ebp)
  101711:	c6 45 db 03          	movb   $0x3,-0x25(%ebp)
  101715:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
  101719:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
  10171d:	ee                   	out    %al,(%dx)
  10171e:	66 c7 45 f2 a0 00    	movw   $0xa0,-0xe(%ebp)
  101724:	c6 45 dc 11          	movb   $0x11,-0x24(%ebp)
  101728:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
  10172c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101730:	ee                   	out    %al,(%dx)
  101731:	66 c7 45 f0 a1 00    	movw   $0xa1,-0x10(%ebp)
  101737:	c6 45 dd 28          	movb   $0x28,-0x23(%ebp)
  10173b:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  10173f:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  101743:	ee                   	out    %al,(%dx)
  101744:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  10174a:	c6 45 de 02          	movb   $0x2,-0x22(%ebp)
  10174e:	0f b6 45 de          	movzbl -0x22(%ebp),%eax
  101752:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101756:	ee                   	out    %al,(%dx)
  101757:	66 c7 45 ec a1 00    	movw   $0xa1,-0x14(%ebp)
  10175d:	c6 45 df 03          	movb   $0x3,-0x21(%ebp)
  101761:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
  101765:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
  101769:	ee                   	out    %al,(%dx)
  10176a:	66 c7 45 ea 20 00    	movw   $0x20,-0x16(%ebp)
  101770:	c6 45 e0 68          	movb   $0x68,-0x20(%ebp)
  101774:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
  101778:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10177c:	ee                   	out    %al,(%dx)
  10177d:	66 c7 45 e8 20 00    	movw   $0x20,-0x18(%ebp)
  101783:	c6 45 e1 0a          	movb   $0xa,-0x1f(%ebp)
  101787:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  10178b:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  10178f:	ee                   	out    %al,(%dx)
  101790:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  101796:	c6 45 e2 68          	movb   $0x68,-0x1e(%ebp)
  10179a:	0f b6 45 e2          	movzbl -0x1e(%ebp),%eax
  10179e:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1017a2:	ee                   	out    %al,(%dx)
  1017a3:	66 c7 45 e4 a0 00    	movw   $0xa0,-0x1c(%ebp)
  1017a9:	c6 45 e3 0a          	movb   $0xa,-0x1d(%ebp)
  1017ad:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
  1017b1:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
  1017b5:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  1017b6:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017bd:	66 83 f8 ff          	cmp    $0xffff,%ax
  1017c1:	74 13                	je     1017d6 <pic_init+0x13a>
        pic_setmask(irq_mask);
  1017c3:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017ca:	0f b7 c0             	movzwl %ax,%eax
  1017cd:	50                   	push   %eax
  1017ce:	e8 43 fe ff ff       	call   101616 <pic_setmask>
  1017d3:	83 c4 04             	add    $0x4,%esp
    }
}
  1017d6:	90                   	nop
  1017d7:	c9                   	leave  
  1017d8:	c3                   	ret    

001017d9 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  1017d9:	55                   	push   %ebp
  1017da:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  1017dc:	fb                   	sti    
    sti();
}
  1017dd:	90                   	nop
  1017de:	5d                   	pop    %ebp
  1017df:	c3                   	ret    

001017e0 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  1017e0:	55                   	push   %ebp
  1017e1:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli");
  1017e3:	fa                   	cli    
    cli();
}
  1017e4:	90                   	nop
  1017e5:	5d                   	pop    %ebp
  1017e6:	c3                   	ret    

001017e7 <print_ticks>:
#include <console.h>
#include <kdebug.h>
#include <string.h>
#define TICK_NUM 100

static void print_ticks() {
  1017e7:	55                   	push   %ebp
  1017e8:	89 e5                	mov    %esp,%ebp
  1017ea:	83 ec 08             	sub    $0x8,%esp
    cprintf("%d ticks\n",TICK_NUM);
  1017ed:	83 ec 08             	sub    $0x8,%esp
  1017f0:	6a 64                	push   $0x64
  1017f2:	68 a0 38 10 00       	push   $0x1038a0
  1017f7:	e8 51 ea ff ff       	call   10024d <cprintf>
  1017fc:	83 c4 10             	add    $0x10,%esp
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  1017ff:	90                   	nop
  101800:	c9                   	leave  
  101801:	c3                   	ret    

00101802 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  101802:	55                   	push   %ebp
  101803:	89 e5                	mov    %esp,%ebp
  101805:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  101808:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10180f:	e9 c3 00 00 00       	jmp    1018d7 <idt_init+0xd5>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  101814:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101817:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  10181e:	89 c2                	mov    %eax,%edx
  101820:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101823:	66 89 14 c5 a0 f0 10 	mov    %dx,0x10f0a0(,%eax,8)
  10182a:	00 
  10182b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10182e:	66 c7 04 c5 a2 f0 10 	movw   $0x8,0x10f0a2(,%eax,8)
  101835:	00 08 00 
  101838:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10183b:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  101842:	00 
  101843:	83 e2 e0             	and    $0xffffffe0,%edx
  101846:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  10184d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101850:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  101857:	00 
  101858:	83 e2 1f             	and    $0x1f,%edx
  10185b:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  101862:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101865:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  10186c:	00 
  10186d:	83 e2 f0             	and    $0xfffffff0,%edx
  101870:	83 ca 0e             	or     $0xe,%edx
  101873:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  10187a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10187d:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  101884:	00 
  101885:	83 e2 ef             	and    $0xffffffef,%edx
  101888:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  10188f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101892:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  101899:	00 
  10189a:	83 e2 9f             	and    $0xffffff9f,%edx
  10189d:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018a7:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018ae:	00 
  1018af:	83 ca 80             	or     $0xffffff80,%edx
  1018b2:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018bc:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  1018c3:	c1 e8 10             	shr    $0x10,%eax
  1018c6:	89 c2                	mov    %eax,%edx
  1018c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018cb:	66 89 14 c5 a6 f0 10 	mov    %dx,0x10f0a6(,%eax,8)
  1018d2:	00 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  1018d3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1018d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018da:	3d ff 00 00 00       	cmp    $0xff,%eax
  1018df:	0f 86 2f ff ff ff    	jbe    101814 <idt_init+0x12>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
    }
	// set for switch from user to kernel
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
  1018e5:	a1 c4 e7 10 00       	mov    0x10e7c4,%eax
  1018ea:	66 a3 68 f4 10 00    	mov    %ax,0x10f468
  1018f0:	66 c7 05 6a f4 10 00 	movw   $0x8,0x10f46a
  1018f7:	08 00 
  1018f9:	0f b6 05 6c f4 10 00 	movzbl 0x10f46c,%eax
  101900:	83 e0 e0             	and    $0xffffffe0,%eax
  101903:	a2 6c f4 10 00       	mov    %al,0x10f46c
  101908:	0f b6 05 6c f4 10 00 	movzbl 0x10f46c,%eax
  10190f:	83 e0 1f             	and    $0x1f,%eax
  101912:	a2 6c f4 10 00       	mov    %al,0x10f46c
  101917:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  10191e:	83 e0 f0             	and    $0xfffffff0,%eax
  101921:	83 c8 0e             	or     $0xe,%eax
  101924:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101929:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  101930:	83 e0 ef             	and    $0xffffffef,%eax
  101933:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101938:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  10193f:	83 c8 60             	or     $0x60,%eax
  101942:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101947:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  10194e:	83 c8 80             	or     $0xffffff80,%eax
  101951:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101956:	a1 c4 e7 10 00       	mov    0x10e7c4,%eax
  10195b:	c1 e8 10             	shr    $0x10,%eax
  10195e:	66 a3 6e f4 10 00    	mov    %ax,0x10f46e
  101964:	c7 45 f8 60 e5 10 00 	movl   $0x10e560,-0x8(%ebp)
    return ebp;
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd));
  10196b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10196e:	0f 01 18             	lidtl  (%eax)
	// load the IDT
    lidt(&idt_pd);
}
  101971:	90                   	nop
  101972:	c9                   	leave  
  101973:	c3                   	ret    

00101974 <trapname>:

static const char *
trapname(int trapno) {
  101974:	55                   	push   %ebp
  101975:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101977:	8b 45 08             	mov    0x8(%ebp),%eax
  10197a:	83 f8 13             	cmp    $0x13,%eax
  10197d:	77 0c                	ja     10198b <trapname+0x17>
        return excnames[trapno];
  10197f:	8b 45 08             	mov    0x8(%ebp),%eax
  101982:	8b 04 85 00 3c 10 00 	mov    0x103c00(,%eax,4),%eax
  101989:	eb 18                	jmp    1019a3 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  10198b:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  10198f:	7e 0d                	jle    10199e <trapname+0x2a>
  101991:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101995:	7f 07                	jg     10199e <trapname+0x2a>
        return "Hardware Interrupt";
  101997:	b8 aa 38 10 00       	mov    $0x1038aa,%eax
  10199c:	eb 05                	jmp    1019a3 <trapname+0x2f>
    }
    return "(unknown trap)";
  10199e:	b8 bd 38 10 00       	mov    $0x1038bd,%eax
}
  1019a3:	5d                   	pop    %ebp
  1019a4:	c3                   	ret    

001019a5 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  1019a5:	55                   	push   %ebp
  1019a6:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  1019a8:	8b 45 08             	mov    0x8(%ebp),%eax
  1019ab:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  1019af:	66 83 f8 08          	cmp    $0x8,%ax
  1019b3:	0f 94 c0             	sete   %al
  1019b6:	0f b6 c0             	movzbl %al,%eax
}
  1019b9:	5d                   	pop    %ebp
  1019ba:	c3                   	ret    

001019bb <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  1019bb:	55                   	push   %ebp
  1019bc:	89 e5                	mov    %esp,%ebp
  1019be:	83 ec 18             	sub    $0x18,%esp
    cprintf("trapframe at %p\n", tf);
  1019c1:	83 ec 08             	sub    $0x8,%esp
  1019c4:	ff 75 08             	pushl  0x8(%ebp)
  1019c7:	68 fe 38 10 00       	push   $0x1038fe
  1019cc:	e8 7c e8 ff ff       	call   10024d <cprintf>
  1019d1:	83 c4 10             	add    $0x10,%esp
    print_regs(&tf->tf_regs);
  1019d4:	8b 45 08             	mov    0x8(%ebp),%eax
  1019d7:	83 ec 0c             	sub    $0xc,%esp
  1019da:	50                   	push   %eax
  1019db:	e8 b8 01 00 00       	call   101b98 <print_regs>
  1019e0:	83 c4 10             	add    $0x10,%esp
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  1019e3:	8b 45 08             	mov    0x8(%ebp),%eax
  1019e6:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  1019ea:	0f b7 c0             	movzwl %ax,%eax
  1019ed:	83 ec 08             	sub    $0x8,%esp
  1019f0:	50                   	push   %eax
  1019f1:	68 0f 39 10 00       	push   $0x10390f
  1019f6:	e8 52 e8 ff ff       	call   10024d <cprintf>
  1019fb:	83 c4 10             	add    $0x10,%esp
    cprintf("  es   0x----%04x\n", tf->tf_es);
  1019fe:	8b 45 08             	mov    0x8(%ebp),%eax
  101a01:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101a05:	0f b7 c0             	movzwl %ax,%eax
  101a08:	83 ec 08             	sub    $0x8,%esp
  101a0b:	50                   	push   %eax
  101a0c:	68 22 39 10 00       	push   $0x103922
  101a11:	e8 37 e8 ff ff       	call   10024d <cprintf>
  101a16:	83 c4 10             	add    $0x10,%esp
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101a19:	8b 45 08             	mov    0x8(%ebp),%eax
  101a1c:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101a20:	0f b7 c0             	movzwl %ax,%eax
  101a23:	83 ec 08             	sub    $0x8,%esp
  101a26:	50                   	push   %eax
  101a27:	68 35 39 10 00       	push   $0x103935
  101a2c:	e8 1c e8 ff ff       	call   10024d <cprintf>
  101a31:	83 c4 10             	add    $0x10,%esp
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101a34:	8b 45 08             	mov    0x8(%ebp),%eax
  101a37:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101a3b:	0f b7 c0             	movzwl %ax,%eax
  101a3e:	83 ec 08             	sub    $0x8,%esp
  101a41:	50                   	push   %eax
  101a42:	68 48 39 10 00       	push   $0x103948
  101a47:	e8 01 e8 ff ff       	call   10024d <cprintf>
  101a4c:	83 c4 10             	add    $0x10,%esp
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101a4f:	8b 45 08             	mov    0x8(%ebp),%eax
  101a52:	8b 40 30             	mov    0x30(%eax),%eax
  101a55:	83 ec 0c             	sub    $0xc,%esp
  101a58:	50                   	push   %eax
  101a59:	e8 16 ff ff ff       	call   101974 <trapname>
  101a5e:	83 c4 10             	add    $0x10,%esp
  101a61:	89 c2                	mov    %eax,%edx
  101a63:	8b 45 08             	mov    0x8(%ebp),%eax
  101a66:	8b 40 30             	mov    0x30(%eax),%eax
  101a69:	83 ec 04             	sub    $0x4,%esp
  101a6c:	52                   	push   %edx
  101a6d:	50                   	push   %eax
  101a6e:	68 5b 39 10 00       	push   $0x10395b
  101a73:	e8 d5 e7 ff ff       	call   10024d <cprintf>
  101a78:	83 c4 10             	add    $0x10,%esp
    cprintf("  err  0x%08x\n", tf->tf_err);
  101a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  101a7e:	8b 40 34             	mov    0x34(%eax),%eax
  101a81:	83 ec 08             	sub    $0x8,%esp
  101a84:	50                   	push   %eax
  101a85:	68 6d 39 10 00       	push   $0x10396d
  101a8a:	e8 be e7 ff ff       	call   10024d <cprintf>
  101a8f:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101a92:	8b 45 08             	mov    0x8(%ebp),%eax
  101a95:	8b 40 38             	mov    0x38(%eax),%eax
  101a98:	83 ec 08             	sub    $0x8,%esp
  101a9b:	50                   	push   %eax
  101a9c:	68 7c 39 10 00       	push   $0x10397c
  101aa1:	e8 a7 e7 ff ff       	call   10024d <cprintf>
  101aa6:	83 c4 10             	add    $0x10,%esp
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  101aac:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101ab0:	0f b7 c0             	movzwl %ax,%eax
  101ab3:	83 ec 08             	sub    $0x8,%esp
  101ab6:	50                   	push   %eax
  101ab7:	68 8b 39 10 00       	push   $0x10398b
  101abc:	e8 8c e7 ff ff       	call   10024d <cprintf>
  101ac1:	83 c4 10             	add    $0x10,%esp
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  101ac7:	8b 40 40             	mov    0x40(%eax),%eax
  101aca:	83 ec 08             	sub    $0x8,%esp
  101acd:	50                   	push   %eax
  101ace:	68 9e 39 10 00       	push   $0x10399e
  101ad3:	e8 75 e7 ff ff       	call   10024d <cprintf>
  101ad8:	83 c4 10             	add    $0x10,%esp

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101adb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101ae2:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101ae9:	eb 3f                	jmp    101b2a <print_trapframe+0x16f>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  101aee:	8b 50 40             	mov    0x40(%eax),%edx
  101af1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101af4:	21 d0                	and    %edx,%eax
  101af6:	85 c0                	test   %eax,%eax
  101af8:	74 29                	je     101b23 <print_trapframe+0x168>
  101afa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101afd:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101b04:	85 c0                	test   %eax,%eax
  101b06:	74 1b                	je     101b23 <print_trapframe+0x168>
            cprintf("%s,", IA32flags[i]);
  101b08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b0b:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101b12:	83 ec 08             	sub    $0x8,%esp
  101b15:	50                   	push   %eax
  101b16:	68 ad 39 10 00       	push   $0x1039ad
  101b1b:	e8 2d e7 ff ff       	call   10024d <cprintf>
  101b20:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b23:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101b27:	d1 65 f0             	shll   -0x10(%ebp)
  101b2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b2d:	83 f8 17             	cmp    $0x17,%eax
  101b30:	76 b9                	jbe    101aeb <print_trapframe+0x130>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101b32:	8b 45 08             	mov    0x8(%ebp),%eax
  101b35:	8b 40 40             	mov    0x40(%eax),%eax
  101b38:	25 00 30 00 00       	and    $0x3000,%eax
  101b3d:	c1 e8 0c             	shr    $0xc,%eax
  101b40:	83 ec 08             	sub    $0x8,%esp
  101b43:	50                   	push   %eax
  101b44:	68 b1 39 10 00       	push   $0x1039b1
  101b49:	e8 ff e6 ff ff       	call   10024d <cprintf>
  101b4e:	83 c4 10             	add    $0x10,%esp

    if (!trap_in_kernel(tf)) {
  101b51:	83 ec 0c             	sub    $0xc,%esp
  101b54:	ff 75 08             	pushl  0x8(%ebp)
  101b57:	e8 49 fe ff ff       	call   1019a5 <trap_in_kernel>
  101b5c:	83 c4 10             	add    $0x10,%esp
  101b5f:	85 c0                	test   %eax,%eax
  101b61:	75 32                	jne    101b95 <print_trapframe+0x1da>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101b63:	8b 45 08             	mov    0x8(%ebp),%eax
  101b66:	8b 40 44             	mov    0x44(%eax),%eax
  101b69:	83 ec 08             	sub    $0x8,%esp
  101b6c:	50                   	push   %eax
  101b6d:	68 ba 39 10 00       	push   $0x1039ba
  101b72:	e8 d6 e6 ff ff       	call   10024d <cprintf>
  101b77:	83 c4 10             	add    $0x10,%esp
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  101b7d:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101b81:	0f b7 c0             	movzwl %ax,%eax
  101b84:	83 ec 08             	sub    $0x8,%esp
  101b87:	50                   	push   %eax
  101b88:	68 c9 39 10 00       	push   $0x1039c9
  101b8d:	e8 bb e6 ff ff       	call   10024d <cprintf>
  101b92:	83 c4 10             	add    $0x10,%esp
    }
}
  101b95:	90                   	nop
  101b96:	c9                   	leave  
  101b97:	c3                   	ret    

00101b98 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101b98:	55                   	push   %ebp
  101b99:	89 e5                	mov    %esp,%ebp
  101b9b:	83 ec 08             	sub    $0x8,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  101ba1:	8b 00                	mov    (%eax),%eax
  101ba3:	83 ec 08             	sub    $0x8,%esp
  101ba6:	50                   	push   %eax
  101ba7:	68 dc 39 10 00       	push   $0x1039dc
  101bac:	e8 9c e6 ff ff       	call   10024d <cprintf>
  101bb1:	83 c4 10             	add    $0x10,%esp
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  101bb7:	8b 40 04             	mov    0x4(%eax),%eax
  101bba:	83 ec 08             	sub    $0x8,%esp
  101bbd:	50                   	push   %eax
  101bbe:	68 eb 39 10 00       	push   $0x1039eb
  101bc3:	e8 85 e6 ff ff       	call   10024d <cprintf>
  101bc8:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101bcb:	8b 45 08             	mov    0x8(%ebp),%eax
  101bce:	8b 40 08             	mov    0x8(%eax),%eax
  101bd1:	83 ec 08             	sub    $0x8,%esp
  101bd4:	50                   	push   %eax
  101bd5:	68 fa 39 10 00       	push   $0x1039fa
  101bda:	e8 6e e6 ff ff       	call   10024d <cprintf>
  101bdf:	83 c4 10             	add    $0x10,%esp
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101be2:	8b 45 08             	mov    0x8(%ebp),%eax
  101be5:	8b 40 0c             	mov    0xc(%eax),%eax
  101be8:	83 ec 08             	sub    $0x8,%esp
  101beb:	50                   	push   %eax
  101bec:	68 09 3a 10 00       	push   $0x103a09
  101bf1:	e8 57 e6 ff ff       	call   10024d <cprintf>
  101bf6:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  101bfc:	8b 40 10             	mov    0x10(%eax),%eax
  101bff:	83 ec 08             	sub    $0x8,%esp
  101c02:	50                   	push   %eax
  101c03:	68 18 3a 10 00       	push   $0x103a18
  101c08:	e8 40 e6 ff ff       	call   10024d <cprintf>
  101c0d:	83 c4 10             	add    $0x10,%esp
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101c10:	8b 45 08             	mov    0x8(%ebp),%eax
  101c13:	8b 40 14             	mov    0x14(%eax),%eax
  101c16:	83 ec 08             	sub    $0x8,%esp
  101c19:	50                   	push   %eax
  101c1a:	68 27 3a 10 00       	push   $0x103a27
  101c1f:	e8 29 e6 ff ff       	call   10024d <cprintf>
  101c24:	83 c4 10             	add    $0x10,%esp
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101c27:	8b 45 08             	mov    0x8(%ebp),%eax
  101c2a:	8b 40 18             	mov    0x18(%eax),%eax
  101c2d:	83 ec 08             	sub    $0x8,%esp
  101c30:	50                   	push   %eax
  101c31:	68 36 3a 10 00       	push   $0x103a36
  101c36:	e8 12 e6 ff ff       	call   10024d <cprintf>
  101c3b:	83 c4 10             	add    $0x10,%esp
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101c3e:	8b 45 08             	mov    0x8(%ebp),%eax
  101c41:	8b 40 1c             	mov    0x1c(%eax),%eax
  101c44:	83 ec 08             	sub    $0x8,%esp
  101c47:	50                   	push   %eax
  101c48:	68 45 3a 10 00       	push   $0x103a45
  101c4d:	e8 fb e5 ff ff       	call   10024d <cprintf>
  101c52:	83 c4 10             	add    $0x10,%esp
}
  101c55:	90                   	nop
  101c56:	c9                   	leave  
  101c57:	c3                   	ret    

00101c58 <trap_dispatch>:
/* temporary trapframe or pointer to trapframe */
struct trapframe switchk2u, *switchu2k;

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101c58:	55                   	push   %ebp
  101c59:	89 e5                	mov    %esp,%ebp
  101c5b:	57                   	push   %edi
  101c5c:	56                   	push   %esi
  101c5d:	53                   	push   %ebx
  101c5e:	83 ec 1c             	sub    $0x1c,%esp
    char c;

    switch (tf->tf_trapno) {
  101c61:	8b 45 08             	mov    0x8(%ebp),%eax
  101c64:	8b 40 30             	mov    0x30(%eax),%eax
  101c67:	83 f8 2f             	cmp    $0x2f,%eax
  101c6a:	77 21                	ja     101c8d <trap_dispatch+0x35>
  101c6c:	83 f8 2e             	cmp    $0x2e,%eax
  101c6f:	0f 83 ff 01 00 00    	jae    101e74 <trap_dispatch+0x21c>
  101c75:	83 f8 21             	cmp    $0x21,%eax
  101c78:	0f 84 87 00 00 00    	je     101d05 <trap_dispatch+0xad>
  101c7e:	83 f8 24             	cmp    $0x24,%eax
  101c81:	74 5b                	je     101cde <trap_dispatch+0x86>
  101c83:	83 f8 20             	cmp    $0x20,%eax
  101c86:	74 1c                	je     101ca4 <trap_dispatch+0x4c>
  101c88:	e9 b1 01 00 00       	jmp    101e3e <trap_dispatch+0x1e6>
  101c8d:	83 f8 78             	cmp    $0x78,%eax
  101c90:	0f 84 96 00 00 00    	je     101d2c <trap_dispatch+0xd4>
  101c96:	83 f8 79             	cmp    $0x79,%eax
  101c99:	0f 84 29 01 00 00    	je     101dc8 <trap_dispatch+0x170>
  101c9f:	e9 9a 01 00 00       	jmp    101e3e <trap_dispatch+0x1e6>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
  101ca4:	a1 08 f9 10 00       	mov    0x10f908,%eax
  101ca9:	83 c0 01             	add    $0x1,%eax
  101cac:	a3 08 f9 10 00       	mov    %eax,0x10f908
        if (ticks % TICK_NUM == 0) {
  101cb1:	8b 0d 08 f9 10 00    	mov    0x10f908,%ecx
  101cb7:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101cbc:	89 c8                	mov    %ecx,%eax
  101cbe:	f7 e2                	mul    %edx
  101cc0:	89 d0                	mov    %edx,%eax
  101cc2:	c1 e8 05             	shr    $0x5,%eax
  101cc5:	6b c0 64             	imul   $0x64,%eax,%eax
  101cc8:	29 c1                	sub    %eax,%ecx
  101cca:	89 c8                	mov    %ecx,%eax
  101ccc:	85 c0                	test   %eax,%eax
  101cce:	0f 85 a3 01 00 00    	jne    101e77 <trap_dispatch+0x21f>
            print_ticks();
  101cd4:	e8 0e fb ff ff       	call   1017e7 <print_ticks>
        }
        break;
  101cd9:	e9 99 01 00 00       	jmp    101e77 <trap_dispatch+0x21f>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101cde:	e8 d7 f8 ff ff       	call   1015ba <cons_getc>
  101ce3:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101ce6:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101cea:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101cee:	83 ec 04             	sub    $0x4,%esp
  101cf1:	52                   	push   %edx
  101cf2:	50                   	push   %eax
  101cf3:	68 54 3a 10 00       	push   $0x103a54
  101cf8:	e8 50 e5 ff ff       	call   10024d <cprintf>
  101cfd:	83 c4 10             	add    $0x10,%esp
        break;
  101d00:	e9 79 01 00 00       	jmp    101e7e <trap_dispatch+0x226>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101d05:	e8 b0 f8 ff ff       	call   1015ba <cons_getc>
  101d0a:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101d0d:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101d11:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101d15:	83 ec 04             	sub    $0x4,%esp
  101d18:	52                   	push   %edx
  101d19:	50                   	push   %eax
  101d1a:	68 66 3a 10 00       	push   $0x103a66
  101d1f:	e8 29 e5 ff ff       	call   10024d <cprintf>
  101d24:	83 c4 10             	add    $0x10,%esp
        break;
  101d27:	e9 52 01 00 00       	jmp    101e7e <trap_dispatch+0x226>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
        if (tf->tf_cs != USER_CS) {
  101d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  101d2f:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101d33:	66 83 f8 1b          	cmp    $0x1b,%ax
  101d37:	0f 84 3d 01 00 00    	je     101e7a <trap_dispatch+0x222>
            switchk2u = *tf;
  101d3d:	8b 55 08             	mov    0x8(%ebp),%edx
  101d40:	b8 20 f9 10 00       	mov    $0x10f920,%eax
  101d45:	89 d3                	mov    %edx,%ebx
  101d47:	ba 4c 00 00 00       	mov    $0x4c,%edx
  101d4c:	8b 0b                	mov    (%ebx),%ecx
  101d4e:	89 08                	mov    %ecx,(%eax)
  101d50:	8b 4c 13 fc          	mov    -0x4(%ebx,%edx,1),%ecx
  101d54:	89 4c 10 fc          	mov    %ecx,-0x4(%eax,%edx,1)
  101d58:	8d 78 04             	lea    0x4(%eax),%edi
  101d5b:	83 e7 fc             	and    $0xfffffffc,%edi
  101d5e:	29 f8                	sub    %edi,%eax
  101d60:	29 c3                	sub    %eax,%ebx
  101d62:	01 c2                	add    %eax,%edx
  101d64:	83 e2 fc             	and    $0xfffffffc,%edx
  101d67:	89 d0                	mov    %edx,%eax
  101d69:	c1 e8 02             	shr    $0x2,%eax
  101d6c:	89 de                	mov    %ebx,%esi
  101d6e:	89 c1                	mov    %eax,%ecx
  101d70:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
            switchk2u.tf_cs = USER_CS;
  101d72:	66 c7 05 5c f9 10 00 	movw   $0x1b,0x10f95c
  101d79:	1b 00 
            switchk2u.tf_ds = switchk2u.tf_es = switchk2u.tf_ss = USER_DS;
  101d7b:	66 c7 05 68 f9 10 00 	movw   $0x23,0x10f968
  101d82:	23 00 
  101d84:	0f b7 05 68 f9 10 00 	movzwl 0x10f968,%eax
  101d8b:	66 a3 48 f9 10 00    	mov    %ax,0x10f948
  101d91:	0f b7 05 48 f9 10 00 	movzwl 0x10f948,%eax
  101d98:	66 a3 4c f9 10 00    	mov    %ax,0x10f94c
            switchk2u.tf_esp = (uint32_t)tf + sizeof(struct trapframe) - 8;
  101d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  101da1:	83 c0 44             	add    $0x44,%eax
  101da4:	a3 64 f9 10 00       	mov    %eax,0x10f964
		
            // set eflags, make sure ucore can use io under user mode.
            // if CPL > IOPL, then cpu will generate a general protection.
            switchk2u.tf_eflags |= FL_IOPL_MASK;
  101da9:	a1 60 f9 10 00       	mov    0x10f960,%eax
  101dae:	80 cc 30             	or     $0x30,%ah
  101db1:	a3 60 f9 10 00       	mov    %eax,0x10f960
		
            // set temporary stack
            // then iret will jump to the right stack
            *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
  101db6:	8b 45 08             	mov    0x8(%ebp),%eax
  101db9:	83 e8 04             	sub    $0x4,%eax
  101dbc:	ba 20 f9 10 00       	mov    $0x10f920,%edx
  101dc1:	89 10                	mov    %edx,(%eax)
        }
        break;
  101dc3:	e9 b2 00 00 00       	jmp    101e7a <trap_dispatch+0x222>
    case T_SWITCH_TOK:
        if (tf->tf_cs != KERNEL_CS) {
  101dc8:	8b 45 08             	mov    0x8(%ebp),%eax
  101dcb:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101dcf:	66 83 f8 08          	cmp    $0x8,%ax
  101dd3:	0f 84 a4 00 00 00    	je     101e7d <trap_dispatch+0x225>
            tf->tf_cs = KERNEL_CS;
  101dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  101ddc:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
            tf->tf_ds = tf->tf_es = KERNEL_DS;
  101de2:	8b 45 08             	mov    0x8(%ebp),%eax
  101de5:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
  101deb:	8b 45 08             	mov    0x8(%ebp),%eax
  101dee:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101df2:	8b 45 08             	mov    0x8(%ebp),%eax
  101df5:	66 89 50 2c          	mov    %dx,0x2c(%eax)
            tf->tf_eflags &= ~FL_IOPL_MASK;
  101df9:	8b 45 08             	mov    0x8(%ebp),%eax
  101dfc:	8b 40 40             	mov    0x40(%eax),%eax
  101dff:	80 e4 cf             	and    $0xcf,%ah
  101e02:	89 c2                	mov    %eax,%edx
  101e04:	8b 45 08             	mov    0x8(%ebp),%eax
  101e07:	89 50 40             	mov    %edx,0x40(%eax)
            switchu2k = (struct trapframe *)(tf->tf_esp - (sizeof(struct trapframe) - 8));
  101e0a:	8b 45 08             	mov    0x8(%ebp),%eax
  101e0d:	8b 40 44             	mov    0x44(%eax),%eax
  101e10:	83 e8 44             	sub    $0x44,%eax
  101e13:	a3 6c f9 10 00       	mov    %eax,0x10f96c
            memmove(switchu2k, tf, sizeof(struct trapframe) - 8);
  101e18:	a1 6c f9 10 00       	mov    0x10f96c,%eax
  101e1d:	83 ec 04             	sub    $0x4,%esp
  101e20:	6a 44                	push   $0x44
  101e22:	ff 75 08             	pushl  0x8(%ebp)
  101e25:	50                   	push   %eax
  101e26:	e8 b9 0f 00 00       	call   102de4 <memmove>
  101e2b:	83 c4 10             	add    $0x10,%esp
            *((uint32_t *)tf - 1) = (uint32_t)switchu2k;
  101e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  101e31:	83 e8 04             	sub    $0x4,%eax
  101e34:	8b 15 6c f9 10 00    	mov    0x10f96c,%edx
  101e3a:	89 10                	mov    %edx,(%eax)
        }
        break;
  101e3c:	eb 3f                	jmp    101e7d <trap_dispatch+0x225>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101e3e:	8b 45 08             	mov    0x8(%ebp),%eax
  101e41:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101e45:	0f b7 c0             	movzwl %ax,%eax
  101e48:	83 e0 03             	and    $0x3,%eax
  101e4b:	85 c0                	test   %eax,%eax
  101e4d:	75 2f                	jne    101e7e <trap_dispatch+0x226>
            print_trapframe(tf);
  101e4f:	83 ec 0c             	sub    $0xc,%esp
  101e52:	ff 75 08             	pushl  0x8(%ebp)
  101e55:	e8 61 fb ff ff       	call   1019bb <print_trapframe>
  101e5a:	83 c4 10             	add    $0x10,%esp
            panic("unexpected trap in kernel.\n");
  101e5d:	83 ec 04             	sub    $0x4,%esp
  101e60:	68 75 3a 10 00       	push   $0x103a75
  101e65:	68 d2 00 00 00       	push   $0xd2
  101e6a:	68 91 3a 10 00       	push   $0x103a91
  101e6f:	e8 3f e5 ff ff       	call   1003b3 <__panic>
        }
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101e74:	90                   	nop
  101e75:	eb 07                	jmp    101e7e <trap_dispatch+0x226>
         */
        ticks ++;
        if (ticks % TICK_NUM == 0) {
            print_ticks();
        }
        break;
  101e77:	90                   	nop
  101e78:	eb 04                	jmp    101e7e <trap_dispatch+0x226>
		
            // set temporary stack
            // then iret will jump to the right stack
            *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
        }
        break;
  101e7a:	90                   	nop
  101e7b:	eb 01                	jmp    101e7e <trap_dispatch+0x226>
            tf->tf_eflags &= ~FL_IOPL_MASK;
            switchu2k = (struct trapframe *)(tf->tf_esp - (sizeof(struct trapframe) - 8));
            memmove(switchu2k, tf, sizeof(struct trapframe) - 8);
            *((uint32_t *)tf - 1) = (uint32_t)switchu2k;
        }
        break;
  101e7d:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101e7e:	90                   	nop
  101e7f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  101e82:	5b                   	pop    %ebx
  101e83:	5e                   	pop    %esi
  101e84:	5f                   	pop    %edi
  101e85:	5d                   	pop    %ebp
  101e86:	c3                   	ret    

00101e87 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101e87:	55                   	push   %ebp
  101e88:	89 e5                	mov    %esp,%ebp
  101e8a:	83 ec 08             	sub    $0x8,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101e8d:	83 ec 0c             	sub    $0xc,%esp
  101e90:	ff 75 08             	pushl  0x8(%ebp)
  101e93:	e8 c0 fd ff ff       	call   101c58 <trap_dispatch>
  101e98:	83 c4 10             	add    $0x10,%esp
}
  101e9b:	90                   	nop
  101e9c:	c9                   	leave  
  101e9d:	c3                   	ret    

00101e9e <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101e9e:	6a 00                	push   $0x0
  pushl $0
  101ea0:	6a 00                	push   $0x0
  jmp __alltraps
  101ea2:	e9 67 0a 00 00       	jmp    10290e <__alltraps>

00101ea7 <vector1>:
.globl vector1
vector1:
  pushl $0
  101ea7:	6a 00                	push   $0x0
  pushl $1
  101ea9:	6a 01                	push   $0x1
  jmp __alltraps
  101eab:	e9 5e 0a 00 00       	jmp    10290e <__alltraps>

00101eb0 <vector2>:
.globl vector2
vector2:
  pushl $0
  101eb0:	6a 00                	push   $0x0
  pushl $2
  101eb2:	6a 02                	push   $0x2
  jmp __alltraps
  101eb4:	e9 55 0a 00 00       	jmp    10290e <__alltraps>

00101eb9 <vector3>:
.globl vector3
vector3:
  pushl $0
  101eb9:	6a 00                	push   $0x0
  pushl $3
  101ebb:	6a 03                	push   $0x3
  jmp __alltraps
  101ebd:	e9 4c 0a 00 00       	jmp    10290e <__alltraps>

00101ec2 <vector4>:
.globl vector4
vector4:
  pushl $0
  101ec2:	6a 00                	push   $0x0
  pushl $4
  101ec4:	6a 04                	push   $0x4
  jmp __alltraps
  101ec6:	e9 43 0a 00 00       	jmp    10290e <__alltraps>

00101ecb <vector5>:
.globl vector5
vector5:
  pushl $0
  101ecb:	6a 00                	push   $0x0
  pushl $5
  101ecd:	6a 05                	push   $0x5
  jmp __alltraps
  101ecf:	e9 3a 0a 00 00       	jmp    10290e <__alltraps>

00101ed4 <vector6>:
.globl vector6
vector6:
  pushl $0
  101ed4:	6a 00                	push   $0x0
  pushl $6
  101ed6:	6a 06                	push   $0x6
  jmp __alltraps
  101ed8:	e9 31 0a 00 00       	jmp    10290e <__alltraps>

00101edd <vector7>:
.globl vector7
vector7:
  pushl $0
  101edd:	6a 00                	push   $0x0
  pushl $7
  101edf:	6a 07                	push   $0x7
  jmp __alltraps
  101ee1:	e9 28 0a 00 00       	jmp    10290e <__alltraps>

00101ee6 <vector8>:
.globl vector8
vector8:
  pushl $8
  101ee6:	6a 08                	push   $0x8
  jmp __alltraps
  101ee8:	e9 21 0a 00 00       	jmp    10290e <__alltraps>

00101eed <vector9>:
.globl vector9
vector9:
  pushl $9
  101eed:	6a 09                	push   $0x9
  jmp __alltraps
  101eef:	e9 1a 0a 00 00       	jmp    10290e <__alltraps>

00101ef4 <vector10>:
.globl vector10
vector10:
  pushl $10
  101ef4:	6a 0a                	push   $0xa
  jmp __alltraps
  101ef6:	e9 13 0a 00 00       	jmp    10290e <__alltraps>

00101efb <vector11>:
.globl vector11
vector11:
  pushl $11
  101efb:	6a 0b                	push   $0xb
  jmp __alltraps
  101efd:	e9 0c 0a 00 00       	jmp    10290e <__alltraps>

00101f02 <vector12>:
.globl vector12
vector12:
  pushl $12
  101f02:	6a 0c                	push   $0xc
  jmp __alltraps
  101f04:	e9 05 0a 00 00       	jmp    10290e <__alltraps>

00101f09 <vector13>:
.globl vector13
vector13:
  pushl $13
  101f09:	6a 0d                	push   $0xd
  jmp __alltraps
  101f0b:	e9 fe 09 00 00       	jmp    10290e <__alltraps>

00101f10 <vector14>:
.globl vector14
vector14:
  pushl $14
  101f10:	6a 0e                	push   $0xe
  jmp __alltraps
  101f12:	e9 f7 09 00 00       	jmp    10290e <__alltraps>

00101f17 <vector15>:
.globl vector15
vector15:
  pushl $0
  101f17:	6a 00                	push   $0x0
  pushl $15
  101f19:	6a 0f                	push   $0xf
  jmp __alltraps
  101f1b:	e9 ee 09 00 00       	jmp    10290e <__alltraps>

00101f20 <vector16>:
.globl vector16
vector16:
  pushl $0
  101f20:	6a 00                	push   $0x0
  pushl $16
  101f22:	6a 10                	push   $0x10
  jmp __alltraps
  101f24:	e9 e5 09 00 00       	jmp    10290e <__alltraps>

00101f29 <vector17>:
.globl vector17
vector17:
  pushl $17
  101f29:	6a 11                	push   $0x11
  jmp __alltraps
  101f2b:	e9 de 09 00 00       	jmp    10290e <__alltraps>

00101f30 <vector18>:
.globl vector18
vector18:
  pushl $0
  101f30:	6a 00                	push   $0x0
  pushl $18
  101f32:	6a 12                	push   $0x12
  jmp __alltraps
  101f34:	e9 d5 09 00 00       	jmp    10290e <__alltraps>

00101f39 <vector19>:
.globl vector19
vector19:
  pushl $0
  101f39:	6a 00                	push   $0x0
  pushl $19
  101f3b:	6a 13                	push   $0x13
  jmp __alltraps
  101f3d:	e9 cc 09 00 00       	jmp    10290e <__alltraps>

00101f42 <vector20>:
.globl vector20
vector20:
  pushl $0
  101f42:	6a 00                	push   $0x0
  pushl $20
  101f44:	6a 14                	push   $0x14
  jmp __alltraps
  101f46:	e9 c3 09 00 00       	jmp    10290e <__alltraps>

00101f4b <vector21>:
.globl vector21
vector21:
  pushl $0
  101f4b:	6a 00                	push   $0x0
  pushl $21
  101f4d:	6a 15                	push   $0x15
  jmp __alltraps
  101f4f:	e9 ba 09 00 00       	jmp    10290e <__alltraps>

00101f54 <vector22>:
.globl vector22
vector22:
  pushl $0
  101f54:	6a 00                	push   $0x0
  pushl $22
  101f56:	6a 16                	push   $0x16
  jmp __alltraps
  101f58:	e9 b1 09 00 00       	jmp    10290e <__alltraps>

00101f5d <vector23>:
.globl vector23
vector23:
  pushl $0
  101f5d:	6a 00                	push   $0x0
  pushl $23
  101f5f:	6a 17                	push   $0x17
  jmp __alltraps
  101f61:	e9 a8 09 00 00       	jmp    10290e <__alltraps>

00101f66 <vector24>:
.globl vector24
vector24:
  pushl $0
  101f66:	6a 00                	push   $0x0
  pushl $24
  101f68:	6a 18                	push   $0x18
  jmp __alltraps
  101f6a:	e9 9f 09 00 00       	jmp    10290e <__alltraps>

00101f6f <vector25>:
.globl vector25
vector25:
  pushl $0
  101f6f:	6a 00                	push   $0x0
  pushl $25
  101f71:	6a 19                	push   $0x19
  jmp __alltraps
  101f73:	e9 96 09 00 00       	jmp    10290e <__alltraps>

00101f78 <vector26>:
.globl vector26
vector26:
  pushl $0
  101f78:	6a 00                	push   $0x0
  pushl $26
  101f7a:	6a 1a                	push   $0x1a
  jmp __alltraps
  101f7c:	e9 8d 09 00 00       	jmp    10290e <__alltraps>

00101f81 <vector27>:
.globl vector27
vector27:
  pushl $0
  101f81:	6a 00                	push   $0x0
  pushl $27
  101f83:	6a 1b                	push   $0x1b
  jmp __alltraps
  101f85:	e9 84 09 00 00       	jmp    10290e <__alltraps>

00101f8a <vector28>:
.globl vector28
vector28:
  pushl $0
  101f8a:	6a 00                	push   $0x0
  pushl $28
  101f8c:	6a 1c                	push   $0x1c
  jmp __alltraps
  101f8e:	e9 7b 09 00 00       	jmp    10290e <__alltraps>

00101f93 <vector29>:
.globl vector29
vector29:
  pushl $0
  101f93:	6a 00                	push   $0x0
  pushl $29
  101f95:	6a 1d                	push   $0x1d
  jmp __alltraps
  101f97:	e9 72 09 00 00       	jmp    10290e <__alltraps>

00101f9c <vector30>:
.globl vector30
vector30:
  pushl $0
  101f9c:	6a 00                	push   $0x0
  pushl $30
  101f9e:	6a 1e                	push   $0x1e
  jmp __alltraps
  101fa0:	e9 69 09 00 00       	jmp    10290e <__alltraps>

00101fa5 <vector31>:
.globl vector31
vector31:
  pushl $0
  101fa5:	6a 00                	push   $0x0
  pushl $31
  101fa7:	6a 1f                	push   $0x1f
  jmp __alltraps
  101fa9:	e9 60 09 00 00       	jmp    10290e <__alltraps>

00101fae <vector32>:
.globl vector32
vector32:
  pushl $0
  101fae:	6a 00                	push   $0x0
  pushl $32
  101fb0:	6a 20                	push   $0x20
  jmp __alltraps
  101fb2:	e9 57 09 00 00       	jmp    10290e <__alltraps>

00101fb7 <vector33>:
.globl vector33
vector33:
  pushl $0
  101fb7:	6a 00                	push   $0x0
  pushl $33
  101fb9:	6a 21                	push   $0x21
  jmp __alltraps
  101fbb:	e9 4e 09 00 00       	jmp    10290e <__alltraps>

00101fc0 <vector34>:
.globl vector34
vector34:
  pushl $0
  101fc0:	6a 00                	push   $0x0
  pushl $34
  101fc2:	6a 22                	push   $0x22
  jmp __alltraps
  101fc4:	e9 45 09 00 00       	jmp    10290e <__alltraps>

00101fc9 <vector35>:
.globl vector35
vector35:
  pushl $0
  101fc9:	6a 00                	push   $0x0
  pushl $35
  101fcb:	6a 23                	push   $0x23
  jmp __alltraps
  101fcd:	e9 3c 09 00 00       	jmp    10290e <__alltraps>

00101fd2 <vector36>:
.globl vector36
vector36:
  pushl $0
  101fd2:	6a 00                	push   $0x0
  pushl $36
  101fd4:	6a 24                	push   $0x24
  jmp __alltraps
  101fd6:	e9 33 09 00 00       	jmp    10290e <__alltraps>

00101fdb <vector37>:
.globl vector37
vector37:
  pushl $0
  101fdb:	6a 00                	push   $0x0
  pushl $37
  101fdd:	6a 25                	push   $0x25
  jmp __alltraps
  101fdf:	e9 2a 09 00 00       	jmp    10290e <__alltraps>

00101fe4 <vector38>:
.globl vector38
vector38:
  pushl $0
  101fe4:	6a 00                	push   $0x0
  pushl $38
  101fe6:	6a 26                	push   $0x26
  jmp __alltraps
  101fe8:	e9 21 09 00 00       	jmp    10290e <__alltraps>

00101fed <vector39>:
.globl vector39
vector39:
  pushl $0
  101fed:	6a 00                	push   $0x0
  pushl $39
  101fef:	6a 27                	push   $0x27
  jmp __alltraps
  101ff1:	e9 18 09 00 00       	jmp    10290e <__alltraps>

00101ff6 <vector40>:
.globl vector40
vector40:
  pushl $0
  101ff6:	6a 00                	push   $0x0
  pushl $40
  101ff8:	6a 28                	push   $0x28
  jmp __alltraps
  101ffa:	e9 0f 09 00 00       	jmp    10290e <__alltraps>

00101fff <vector41>:
.globl vector41
vector41:
  pushl $0
  101fff:	6a 00                	push   $0x0
  pushl $41
  102001:	6a 29                	push   $0x29
  jmp __alltraps
  102003:	e9 06 09 00 00       	jmp    10290e <__alltraps>

00102008 <vector42>:
.globl vector42
vector42:
  pushl $0
  102008:	6a 00                	push   $0x0
  pushl $42
  10200a:	6a 2a                	push   $0x2a
  jmp __alltraps
  10200c:	e9 fd 08 00 00       	jmp    10290e <__alltraps>

00102011 <vector43>:
.globl vector43
vector43:
  pushl $0
  102011:	6a 00                	push   $0x0
  pushl $43
  102013:	6a 2b                	push   $0x2b
  jmp __alltraps
  102015:	e9 f4 08 00 00       	jmp    10290e <__alltraps>

0010201a <vector44>:
.globl vector44
vector44:
  pushl $0
  10201a:	6a 00                	push   $0x0
  pushl $44
  10201c:	6a 2c                	push   $0x2c
  jmp __alltraps
  10201e:	e9 eb 08 00 00       	jmp    10290e <__alltraps>

00102023 <vector45>:
.globl vector45
vector45:
  pushl $0
  102023:	6a 00                	push   $0x0
  pushl $45
  102025:	6a 2d                	push   $0x2d
  jmp __alltraps
  102027:	e9 e2 08 00 00       	jmp    10290e <__alltraps>

0010202c <vector46>:
.globl vector46
vector46:
  pushl $0
  10202c:	6a 00                	push   $0x0
  pushl $46
  10202e:	6a 2e                	push   $0x2e
  jmp __alltraps
  102030:	e9 d9 08 00 00       	jmp    10290e <__alltraps>

00102035 <vector47>:
.globl vector47
vector47:
  pushl $0
  102035:	6a 00                	push   $0x0
  pushl $47
  102037:	6a 2f                	push   $0x2f
  jmp __alltraps
  102039:	e9 d0 08 00 00       	jmp    10290e <__alltraps>

0010203e <vector48>:
.globl vector48
vector48:
  pushl $0
  10203e:	6a 00                	push   $0x0
  pushl $48
  102040:	6a 30                	push   $0x30
  jmp __alltraps
  102042:	e9 c7 08 00 00       	jmp    10290e <__alltraps>

00102047 <vector49>:
.globl vector49
vector49:
  pushl $0
  102047:	6a 00                	push   $0x0
  pushl $49
  102049:	6a 31                	push   $0x31
  jmp __alltraps
  10204b:	e9 be 08 00 00       	jmp    10290e <__alltraps>

00102050 <vector50>:
.globl vector50
vector50:
  pushl $0
  102050:	6a 00                	push   $0x0
  pushl $50
  102052:	6a 32                	push   $0x32
  jmp __alltraps
  102054:	e9 b5 08 00 00       	jmp    10290e <__alltraps>

00102059 <vector51>:
.globl vector51
vector51:
  pushl $0
  102059:	6a 00                	push   $0x0
  pushl $51
  10205b:	6a 33                	push   $0x33
  jmp __alltraps
  10205d:	e9 ac 08 00 00       	jmp    10290e <__alltraps>

00102062 <vector52>:
.globl vector52
vector52:
  pushl $0
  102062:	6a 00                	push   $0x0
  pushl $52
  102064:	6a 34                	push   $0x34
  jmp __alltraps
  102066:	e9 a3 08 00 00       	jmp    10290e <__alltraps>

0010206b <vector53>:
.globl vector53
vector53:
  pushl $0
  10206b:	6a 00                	push   $0x0
  pushl $53
  10206d:	6a 35                	push   $0x35
  jmp __alltraps
  10206f:	e9 9a 08 00 00       	jmp    10290e <__alltraps>

00102074 <vector54>:
.globl vector54
vector54:
  pushl $0
  102074:	6a 00                	push   $0x0
  pushl $54
  102076:	6a 36                	push   $0x36
  jmp __alltraps
  102078:	e9 91 08 00 00       	jmp    10290e <__alltraps>

0010207d <vector55>:
.globl vector55
vector55:
  pushl $0
  10207d:	6a 00                	push   $0x0
  pushl $55
  10207f:	6a 37                	push   $0x37
  jmp __alltraps
  102081:	e9 88 08 00 00       	jmp    10290e <__alltraps>

00102086 <vector56>:
.globl vector56
vector56:
  pushl $0
  102086:	6a 00                	push   $0x0
  pushl $56
  102088:	6a 38                	push   $0x38
  jmp __alltraps
  10208a:	e9 7f 08 00 00       	jmp    10290e <__alltraps>

0010208f <vector57>:
.globl vector57
vector57:
  pushl $0
  10208f:	6a 00                	push   $0x0
  pushl $57
  102091:	6a 39                	push   $0x39
  jmp __alltraps
  102093:	e9 76 08 00 00       	jmp    10290e <__alltraps>

00102098 <vector58>:
.globl vector58
vector58:
  pushl $0
  102098:	6a 00                	push   $0x0
  pushl $58
  10209a:	6a 3a                	push   $0x3a
  jmp __alltraps
  10209c:	e9 6d 08 00 00       	jmp    10290e <__alltraps>

001020a1 <vector59>:
.globl vector59
vector59:
  pushl $0
  1020a1:	6a 00                	push   $0x0
  pushl $59
  1020a3:	6a 3b                	push   $0x3b
  jmp __alltraps
  1020a5:	e9 64 08 00 00       	jmp    10290e <__alltraps>

001020aa <vector60>:
.globl vector60
vector60:
  pushl $0
  1020aa:	6a 00                	push   $0x0
  pushl $60
  1020ac:	6a 3c                	push   $0x3c
  jmp __alltraps
  1020ae:	e9 5b 08 00 00       	jmp    10290e <__alltraps>

001020b3 <vector61>:
.globl vector61
vector61:
  pushl $0
  1020b3:	6a 00                	push   $0x0
  pushl $61
  1020b5:	6a 3d                	push   $0x3d
  jmp __alltraps
  1020b7:	e9 52 08 00 00       	jmp    10290e <__alltraps>

001020bc <vector62>:
.globl vector62
vector62:
  pushl $0
  1020bc:	6a 00                	push   $0x0
  pushl $62
  1020be:	6a 3e                	push   $0x3e
  jmp __alltraps
  1020c0:	e9 49 08 00 00       	jmp    10290e <__alltraps>

001020c5 <vector63>:
.globl vector63
vector63:
  pushl $0
  1020c5:	6a 00                	push   $0x0
  pushl $63
  1020c7:	6a 3f                	push   $0x3f
  jmp __alltraps
  1020c9:	e9 40 08 00 00       	jmp    10290e <__alltraps>

001020ce <vector64>:
.globl vector64
vector64:
  pushl $0
  1020ce:	6a 00                	push   $0x0
  pushl $64
  1020d0:	6a 40                	push   $0x40
  jmp __alltraps
  1020d2:	e9 37 08 00 00       	jmp    10290e <__alltraps>

001020d7 <vector65>:
.globl vector65
vector65:
  pushl $0
  1020d7:	6a 00                	push   $0x0
  pushl $65
  1020d9:	6a 41                	push   $0x41
  jmp __alltraps
  1020db:	e9 2e 08 00 00       	jmp    10290e <__alltraps>

001020e0 <vector66>:
.globl vector66
vector66:
  pushl $0
  1020e0:	6a 00                	push   $0x0
  pushl $66
  1020e2:	6a 42                	push   $0x42
  jmp __alltraps
  1020e4:	e9 25 08 00 00       	jmp    10290e <__alltraps>

001020e9 <vector67>:
.globl vector67
vector67:
  pushl $0
  1020e9:	6a 00                	push   $0x0
  pushl $67
  1020eb:	6a 43                	push   $0x43
  jmp __alltraps
  1020ed:	e9 1c 08 00 00       	jmp    10290e <__alltraps>

001020f2 <vector68>:
.globl vector68
vector68:
  pushl $0
  1020f2:	6a 00                	push   $0x0
  pushl $68
  1020f4:	6a 44                	push   $0x44
  jmp __alltraps
  1020f6:	e9 13 08 00 00       	jmp    10290e <__alltraps>

001020fb <vector69>:
.globl vector69
vector69:
  pushl $0
  1020fb:	6a 00                	push   $0x0
  pushl $69
  1020fd:	6a 45                	push   $0x45
  jmp __alltraps
  1020ff:	e9 0a 08 00 00       	jmp    10290e <__alltraps>

00102104 <vector70>:
.globl vector70
vector70:
  pushl $0
  102104:	6a 00                	push   $0x0
  pushl $70
  102106:	6a 46                	push   $0x46
  jmp __alltraps
  102108:	e9 01 08 00 00       	jmp    10290e <__alltraps>

0010210d <vector71>:
.globl vector71
vector71:
  pushl $0
  10210d:	6a 00                	push   $0x0
  pushl $71
  10210f:	6a 47                	push   $0x47
  jmp __alltraps
  102111:	e9 f8 07 00 00       	jmp    10290e <__alltraps>

00102116 <vector72>:
.globl vector72
vector72:
  pushl $0
  102116:	6a 00                	push   $0x0
  pushl $72
  102118:	6a 48                	push   $0x48
  jmp __alltraps
  10211a:	e9 ef 07 00 00       	jmp    10290e <__alltraps>

0010211f <vector73>:
.globl vector73
vector73:
  pushl $0
  10211f:	6a 00                	push   $0x0
  pushl $73
  102121:	6a 49                	push   $0x49
  jmp __alltraps
  102123:	e9 e6 07 00 00       	jmp    10290e <__alltraps>

00102128 <vector74>:
.globl vector74
vector74:
  pushl $0
  102128:	6a 00                	push   $0x0
  pushl $74
  10212a:	6a 4a                	push   $0x4a
  jmp __alltraps
  10212c:	e9 dd 07 00 00       	jmp    10290e <__alltraps>

00102131 <vector75>:
.globl vector75
vector75:
  pushl $0
  102131:	6a 00                	push   $0x0
  pushl $75
  102133:	6a 4b                	push   $0x4b
  jmp __alltraps
  102135:	e9 d4 07 00 00       	jmp    10290e <__alltraps>

0010213a <vector76>:
.globl vector76
vector76:
  pushl $0
  10213a:	6a 00                	push   $0x0
  pushl $76
  10213c:	6a 4c                	push   $0x4c
  jmp __alltraps
  10213e:	e9 cb 07 00 00       	jmp    10290e <__alltraps>

00102143 <vector77>:
.globl vector77
vector77:
  pushl $0
  102143:	6a 00                	push   $0x0
  pushl $77
  102145:	6a 4d                	push   $0x4d
  jmp __alltraps
  102147:	e9 c2 07 00 00       	jmp    10290e <__alltraps>

0010214c <vector78>:
.globl vector78
vector78:
  pushl $0
  10214c:	6a 00                	push   $0x0
  pushl $78
  10214e:	6a 4e                	push   $0x4e
  jmp __alltraps
  102150:	e9 b9 07 00 00       	jmp    10290e <__alltraps>

00102155 <vector79>:
.globl vector79
vector79:
  pushl $0
  102155:	6a 00                	push   $0x0
  pushl $79
  102157:	6a 4f                	push   $0x4f
  jmp __alltraps
  102159:	e9 b0 07 00 00       	jmp    10290e <__alltraps>

0010215e <vector80>:
.globl vector80
vector80:
  pushl $0
  10215e:	6a 00                	push   $0x0
  pushl $80
  102160:	6a 50                	push   $0x50
  jmp __alltraps
  102162:	e9 a7 07 00 00       	jmp    10290e <__alltraps>

00102167 <vector81>:
.globl vector81
vector81:
  pushl $0
  102167:	6a 00                	push   $0x0
  pushl $81
  102169:	6a 51                	push   $0x51
  jmp __alltraps
  10216b:	e9 9e 07 00 00       	jmp    10290e <__alltraps>

00102170 <vector82>:
.globl vector82
vector82:
  pushl $0
  102170:	6a 00                	push   $0x0
  pushl $82
  102172:	6a 52                	push   $0x52
  jmp __alltraps
  102174:	e9 95 07 00 00       	jmp    10290e <__alltraps>

00102179 <vector83>:
.globl vector83
vector83:
  pushl $0
  102179:	6a 00                	push   $0x0
  pushl $83
  10217b:	6a 53                	push   $0x53
  jmp __alltraps
  10217d:	e9 8c 07 00 00       	jmp    10290e <__alltraps>

00102182 <vector84>:
.globl vector84
vector84:
  pushl $0
  102182:	6a 00                	push   $0x0
  pushl $84
  102184:	6a 54                	push   $0x54
  jmp __alltraps
  102186:	e9 83 07 00 00       	jmp    10290e <__alltraps>

0010218b <vector85>:
.globl vector85
vector85:
  pushl $0
  10218b:	6a 00                	push   $0x0
  pushl $85
  10218d:	6a 55                	push   $0x55
  jmp __alltraps
  10218f:	e9 7a 07 00 00       	jmp    10290e <__alltraps>

00102194 <vector86>:
.globl vector86
vector86:
  pushl $0
  102194:	6a 00                	push   $0x0
  pushl $86
  102196:	6a 56                	push   $0x56
  jmp __alltraps
  102198:	e9 71 07 00 00       	jmp    10290e <__alltraps>

0010219d <vector87>:
.globl vector87
vector87:
  pushl $0
  10219d:	6a 00                	push   $0x0
  pushl $87
  10219f:	6a 57                	push   $0x57
  jmp __alltraps
  1021a1:	e9 68 07 00 00       	jmp    10290e <__alltraps>

001021a6 <vector88>:
.globl vector88
vector88:
  pushl $0
  1021a6:	6a 00                	push   $0x0
  pushl $88
  1021a8:	6a 58                	push   $0x58
  jmp __alltraps
  1021aa:	e9 5f 07 00 00       	jmp    10290e <__alltraps>

001021af <vector89>:
.globl vector89
vector89:
  pushl $0
  1021af:	6a 00                	push   $0x0
  pushl $89
  1021b1:	6a 59                	push   $0x59
  jmp __alltraps
  1021b3:	e9 56 07 00 00       	jmp    10290e <__alltraps>

001021b8 <vector90>:
.globl vector90
vector90:
  pushl $0
  1021b8:	6a 00                	push   $0x0
  pushl $90
  1021ba:	6a 5a                	push   $0x5a
  jmp __alltraps
  1021bc:	e9 4d 07 00 00       	jmp    10290e <__alltraps>

001021c1 <vector91>:
.globl vector91
vector91:
  pushl $0
  1021c1:	6a 00                	push   $0x0
  pushl $91
  1021c3:	6a 5b                	push   $0x5b
  jmp __alltraps
  1021c5:	e9 44 07 00 00       	jmp    10290e <__alltraps>

001021ca <vector92>:
.globl vector92
vector92:
  pushl $0
  1021ca:	6a 00                	push   $0x0
  pushl $92
  1021cc:	6a 5c                	push   $0x5c
  jmp __alltraps
  1021ce:	e9 3b 07 00 00       	jmp    10290e <__alltraps>

001021d3 <vector93>:
.globl vector93
vector93:
  pushl $0
  1021d3:	6a 00                	push   $0x0
  pushl $93
  1021d5:	6a 5d                	push   $0x5d
  jmp __alltraps
  1021d7:	e9 32 07 00 00       	jmp    10290e <__alltraps>

001021dc <vector94>:
.globl vector94
vector94:
  pushl $0
  1021dc:	6a 00                	push   $0x0
  pushl $94
  1021de:	6a 5e                	push   $0x5e
  jmp __alltraps
  1021e0:	e9 29 07 00 00       	jmp    10290e <__alltraps>

001021e5 <vector95>:
.globl vector95
vector95:
  pushl $0
  1021e5:	6a 00                	push   $0x0
  pushl $95
  1021e7:	6a 5f                	push   $0x5f
  jmp __alltraps
  1021e9:	e9 20 07 00 00       	jmp    10290e <__alltraps>

001021ee <vector96>:
.globl vector96
vector96:
  pushl $0
  1021ee:	6a 00                	push   $0x0
  pushl $96
  1021f0:	6a 60                	push   $0x60
  jmp __alltraps
  1021f2:	e9 17 07 00 00       	jmp    10290e <__alltraps>

001021f7 <vector97>:
.globl vector97
vector97:
  pushl $0
  1021f7:	6a 00                	push   $0x0
  pushl $97
  1021f9:	6a 61                	push   $0x61
  jmp __alltraps
  1021fb:	e9 0e 07 00 00       	jmp    10290e <__alltraps>

00102200 <vector98>:
.globl vector98
vector98:
  pushl $0
  102200:	6a 00                	push   $0x0
  pushl $98
  102202:	6a 62                	push   $0x62
  jmp __alltraps
  102204:	e9 05 07 00 00       	jmp    10290e <__alltraps>

00102209 <vector99>:
.globl vector99
vector99:
  pushl $0
  102209:	6a 00                	push   $0x0
  pushl $99
  10220b:	6a 63                	push   $0x63
  jmp __alltraps
  10220d:	e9 fc 06 00 00       	jmp    10290e <__alltraps>

00102212 <vector100>:
.globl vector100
vector100:
  pushl $0
  102212:	6a 00                	push   $0x0
  pushl $100
  102214:	6a 64                	push   $0x64
  jmp __alltraps
  102216:	e9 f3 06 00 00       	jmp    10290e <__alltraps>

0010221b <vector101>:
.globl vector101
vector101:
  pushl $0
  10221b:	6a 00                	push   $0x0
  pushl $101
  10221d:	6a 65                	push   $0x65
  jmp __alltraps
  10221f:	e9 ea 06 00 00       	jmp    10290e <__alltraps>

00102224 <vector102>:
.globl vector102
vector102:
  pushl $0
  102224:	6a 00                	push   $0x0
  pushl $102
  102226:	6a 66                	push   $0x66
  jmp __alltraps
  102228:	e9 e1 06 00 00       	jmp    10290e <__alltraps>

0010222d <vector103>:
.globl vector103
vector103:
  pushl $0
  10222d:	6a 00                	push   $0x0
  pushl $103
  10222f:	6a 67                	push   $0x67
  jmp __alltraps
  102231:	e9 d8 06 00 00       	jmp    10290e <__alltraps>

00102236 <vector104>:
.globl vector104
vector104:
  pushl $0
  102236:	6a 00                	push   $0x0
  pushl $104
  102238:	6a 68                	push   $0x68
  jmp __alltraps
  10223a:	e9 cf 06 00 00       	jmp    10290e <__alltraps>

0010223f <vector105>:
.globl vector105
vector105:
  pushl $0
  10223f:	6a 00                	push   $0x0
  pushl $105
  102241:	6a 69                	push   $0x69
  jmp __alltraps
  102243:	e9 c6 06 00 00       	jmp    10290e <__alltraps>

00102248 <vector106>:
.globl vector106
vector106:
  pushl $0
  102248:	6a 00                	push   $0x0
  pushl $106
  10224a:	6a 6a                	push   $0x6a
  jmp __alltraps
  10224c:	e9 bd 06 00 00       	jmp    10290e <__alltraps>

00102251 <vector107>:
.globl vector107
vector107:
  pushl $0
  102251:	6a 00                	push   $0x0
  pushl $107
  102253:	6a 6b                	push   $0x6b
  jmp __alltraps
  102255:	e9 b4 06 00 00       	jmp    10290e <__alltraps>

0010225a <vector108>:
.globl vector108
vector108:
  pushl $0
  10225a:	6a 00                	push   $0x0
  pushl $108
  10225c:	6a 6c                	push   $0x6c
  jmp __alltraps
  10225e:	e9 ab 06 00 00       	jmp    10290e <__alltraps>

00102263 <vector109>:
.globl vector109
vector109:
  pushl $0
  102263:	6a 00                	push   $0x0
  pushl $109
  102265:	6a 6d                	push   $0x6d
  jmp __alltraps
  102267:	e9 a2 06 00 00       	jmp    10290e <__alltraps>

0010226c <vector110>:
.globl vector110
vector110:
  pushl $0
  10226c:	6a 00                	push   $0x0
  pushl $110
  10226e:	6a 6e                	push   $0x6e
  jmp __alltraps
  102270:	e9 99 06 00 00       	jmp    10290e <__alltraps>

00102275 <vector111>:
.globl vector111
vector111:
  pushl $0
  102275:	6a 00                	push   $0x0
  pushl $111
  102277:	6a 6f                	push   $0x6f
  jmp __alltraps
  102279:	e9 90 06 00 00       	jmp    10290e <__alltraps>

0010227e <vector112>:
.globl vector112
vector112:
  pushl $0
  10227e:	6a 00                	push   $0x0
  pushl $112
  102280:	6a 70                	push   $0x70
  jmp __alltraps
  102282:	e9 87 06 00 00       	jmp    10290e <__alltraps>

00102287 <vector113>:
.globl vector113
vector113:
  pushl $0
  102287:	6a 00                	push   $0x0
  pushl $113
  102289:	6a 71                	push   $0x71
  jmp __alltraps
  10228b:	e9 7e 06 00 00       	jmp    10290e <__alltraps>

00102290 <vector114>:
.globl vector114
vector114:
  pushl $0
  102290:	6a 00                	push   $0x0
  pushl $114
  102292:	6a 72                	push   $0x72
  jmp __alltraps
  102294:	e9 75 06 00 00       	jmp    10290e <__alltraps>

00102299 <vector115>:
.globl vector115
vector115:
  pushl $0
  102299:	6a 00                	push   $0x0
  pushl $115
  10229b:	6a 73                	push   $0x73
  jmp __alltraps
  10229d:	e9 6c 06 00 00       	jmp    10290e <__alltraps>

001022a2 <vector116>:
.globl vector116
vector116:
  pushl $0
  1022a2:	6a 00                	push   $0x0
  pushl $116
  1022a4:	6a 74                	push   $0x74
  jmp __alltraps
  1022a6:	e9 63 06 00 00       	jmp    10290e <__alltraps>

001022ab <vector117>:
.globl vector117
vector117:
  pushl $0
  1022ab:	6a 00                	push   $0x0
  pushl $117
  1022ad:	6a 75                	push   $0x75
  jmp __alltraps
  1022af:	e9 5a 06 00 00       	jmp    10290e <__alltraps>

001022b4 <vector118>:
.globl vector118
vector118:
  pushl $0
  1022b4:	6a 00                	push   $0x0
  pushl $118
  1022b6:	6a 76                	push   $0x76
  jmp __alltraps
  1022b8:	e9 51 06 00 00       	jmp    10290e <__alltraps>

001022bd <vector119>:
.globl vector119
vector119:
  pushl $0
  1022bd:	6a 00                	push   $0x0
  pushl $119
  1022bf:	6a 77                	push   $0x77
  jmp __alltraps
  1022c1:	e9 48 06 00 00       	jmp    10290e <__alltraps>

001022c6 <vector120>:
.globl vector120
vector120:
  pushl $0
  1022c6:	6a 00                	push   $0x0
  pushl $120
  1022c8:	6a 78                	push   $0x78
  jmp __alltraps
  1022ca:	e9 3f 06 00 00       	jmp    10290e <__alltraps>

001022cf <vector121>:
.globl vector121
vector121:
  pushl $0
  1022cf:	6a 00                	push   $0x0
  pushl $121
  1022d1:	6a 79                	push   $0x79
  jmp __alltraps
  1022d3:	e9 36 06 00 00       	jmp    10290e <__alltraps>

001022d8 <vector122>:
.globl vector122
vector122:
  pushl $0
  1022d8:	6a 00                	push   $0x0
  pushl $122
  1022da:	6a 7a                	push   $0x7a
  jmp __alltraps
  1022dc:	e9 2d 06 00 00       	jmp    10290e <__alltraps>

001022e1 <vector123>:
.globl vector123
vector123:
  pushl $0
  1022e1:	6a 00                	push   $0x0
  pushl $123
  1022e3:	6a 7b                	push   $0x7b
  jmp __alltraps
  1022e5:	e9 24 06 00 00       	jmp    10290e <__alltraps>

001022ea <vector124>:
.globl vector124
vector124:
  pushl $0
  1022ea:	6a 00                	push   $0x0
  pushl $124
  1022ec:	6a 7c                	push   $0x7c
  jmp __alltraps
  1022ee:	e9 1b 06 00 00       	jmp    10290e <__alltraps>

001022f3 <vector125>:
.globl vector125
vector125:
  pushl $0
  1022f3:	6a 00                	push   $0x0
  pushl $125
  1022f5:	6a 7d                	push   $0x7d
  jmp __alltraps
  1022f7:	e9 12 06 00 00       	jmp    10290e <__alltraps>

001022fc <vector126>:
.globl vector126
vector126:
  pushl $0
  1022fc:	6a 00                	push   $0x0
  pushl $126
  1022fe:	6a 7e                	push   $0x7e
  jmp __alltraps
  102300:	e9 09 06 00 00       	jmp    10290e <__alltraps>

00102305 <vector127>:
.globl vector127
vector127:
  pushl $0
  102305:	6a 00                	push   $0x0
  pushl $127
  102307:	6a 7f                	push   $0x7f
  jmp __alltraps
  102309:	e9 00 06 00 00       	jmp    10290e <__alltraps>

0010230e <vector128>:
.globl vector128
vector128:
  pushl $0
  10230e:	6a 00                	push   $0x0
  pushl $128
  102310:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  102315:	e9 f4 05 00 00       	jmp    10290e <__alltraps>

0010231a <vector129>:
.globl vector129
vector129:
  pushl $0
  10231a:	6a 00                	push   $0x0
  pushl $129
  10231c:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  102321:	e9 e8 05 00 00       	jmp    10290e <__alltraps>

00102326 <vector130>:
.globl vector130
vector130:
  pushl $0
  102326:	6a 00                	push   $0x0
  pushl $130
  102328:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  10232d:	e9 dc 05 00 00       	jmp    10290e <__alltraps>

00102332 <vector131>:
.globl vector131
vector131:
  pushl $0
  102332:	6a 00                	push   $0x0
  pushl $131
  102334:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  102339:	e9 d0 05 00 00       	jmp    10290e <__alltraps>

0010233e <vector132>:
.globl vector132
vector132:
  pushl $0
  10233e:	6a 00                	push   $0x0
  pushl $132
  102340:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  102345:	e9 c4 05 00 00       	jmp    10290e <__alltraps>

0010234a <vector133>:
.globl vector133
vector133:
  pushl $0
  10234a:	6a 00                	push   $0x0
  pushl $133
  10234c:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  102351:	e9 b8 05 00 00       	jmp    10290e <__alltraps>

00102356 <vector134>:
.globl vector134
vector134:
  pushl $0
  102356:	6a 00                	push   $0x0
  pushl $134
  102358:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  10235d:	e9 ac 05 00 00       	jmp    10290e <__alltraps>

00102362 <vector135>:
.globl vector135
vector135:
  pushl $0
  102362:	6a 00                	push   $0x0
  pushl $135
  102364:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  102369:	e9 a0 05 00 00       	jmp    10290e <__alltraps>

0010236e <vector136>:
.globl vector136
vector136:
  pushl $0
  10236e:	6a 00                	push   $0x0
  pushl $136
  102370:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  102375:	e9 94 05 00 00       	jmp    10290e <__alltraps>

0010237a <vector137>:
.globl vector137
vector137:
  pushl $0
  10237a:	6a 00                	push   $0x0
  pushl $137
  10237c:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  102381:	e9 88 05 00 00       	jmp    10290e <__alltraps>

00102386 <vector138>:
.globl vector138
vector138:
  pushl $0
  102386:	6a 00                	push   $0x0
  pushl $138
  102388:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  10238d:	e9 7c 05 00 00       	jmp    10290e <__alltraps>

00102392 <vector139>:
.globl vector139
vector139:
  pushl $0
  102392:	6a 00                	push   $0x0
  pushl $139
  102394:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  102399:	e9 70 05 00 00       	jmp    10290e <__alltraps>

0010239e <vector140>:
.globl vector140
vector140:
  pushl $0
  10239e:	6a 00                	push   $0x0
  pushl $140
  1023a0:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  1023a5:	e9 64 05 00 00       	jmp    10290e <__alltraps>

001023aa <vector141>:
.globl vector141
vector141:
  pushl $0
  1023aa:	6a 00                	push   $0x0
  pushl $141
  1023ac:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  1023b1:	e9 58 05 00 00       	jmp    10290e <__alltraps>

001023b6 <vector142>:
.globl vector142
vector142:
  pushl $0
  1023b6:	6a 00                	push   $0x0
  pushl $142
  1023b8:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  1023bd:	e9 4c 05 00 00       	jmp    10290e <__alltraps>

001023c2 <vector143>:
.globl vector143
vector143:
  pushl $0
  1023c2:	6a 00                	push   $0x0
  pushl $143
  1023c4:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  1023c9:	e9 40 05 00 00       	jmp    10290e <__alltraps>

001023ce <vector144>:
.globl vector144
vector144:
  pushl $0
  1023ce:	6a 00                	push   $0x0
  pushl $144
  1023d0:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  1023d5:	e9 34 05 00 00       	jmp    10290e <__alltraps>

001023da <vector145>:
.globl vector145
vector145:
  pushl $0
  1023da:	6a 00                	push   $0x0
  pushl $145
  1023dc:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  1023e1:	e9 28 05 00 00       	jmp    10290e <__alltraps>

001023e6 <vector146>:
.globl vector146
vector146:
  pushl $0
  1023e6:	6a 00                	push   $0x0
  pushl $146
  1023e8:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  1023ed:	e9 1c 05 00 00       	jmp    10290e <__alltraps>

001023f2 <vector147>:
.globl vector147
vector147:
  pushl $0
  1023f2:	6a 00                	push   $0x0
  pushl $147
  1023f4:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  1023f9:	e9 10 05 00 00       	jmp    10290e <__alltraps>

001023fe <vector148>:
.globl vector148
vector148:
  pushl $0
  1023fe:	6a 00                	push   $0x0
  pushl $148
  102400:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  102405:	e9 04 05 00 00       	jmp    10290e <__alltraps>

0010240a <vector149>:
.globl vector149
vector149:
  pushl $0
  10240a:	6a 00                	push   $0x0
  pushl $149
  10240c:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  102411:	e9 f8 04 00 00       	jmp    10290e <__alltraps>

00102416 <vector150>:
.globl vector150
vector150:
  pushl $0
  102416:	6a 00                	push   $0x0
  pushl $150
  102418:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  10241d:	e9 ec 04 00 00       	jmp    10290e <__alltraps>

00102422 <vector151>:
.globl vector151
vector151:
  pushl $0
  102422:	6a 00                	push   $0x0
  pushl $151
  102424:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  102429:	e9 e0 04 00 00       	jmp    10290e <__alltraps>

0010242e <vector152>:
.globl vector152
vector152:
  pushl $0
  10242e:	6a 00                	push   $0x0
  pushl $152
  102430:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  102435:	e9 d4 04 00 00       	jmp    10290e <__alltraps>

0010243a <vector153>:
.globl vector153
vector153:
  pushl $0
  10243a:	6a 00                	push   $0x0
  pushl $153
  10243c:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  102441:	e9 c8 04 00 00       	jmp    10290e <__alltraps>

00102446 <vector154>:
.globl vector154
vector154:
  pushl $0
  102446:	6a 00                	push   $0x0
  pushl $154
  102448:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  10244d:	e9 bc 04 00 00       	jmp    10290e <__alltraps>

00102452 <vector155>:
.globl vector155
vector155:
  pushl $0
  102452:	6a 00                	push   $0x0
  pushl $155
  102454:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  102459:	e9 b0 04 00 00       	jmp    10290e <__alltraps>

0010245e <vector156>:
.globl vector156
vector156:
  pushl $0
  10245e:	6a 00                	push   $0x0
  pushl $156
  102460:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  102465:	e9 a4 04 00 00       	jmp    10290e <__alltraps>

0010246a <vector157>:
.globl vector157
vector157:
  pushl $0
  10246a:	6a 00                	push   $0x0
  pushl $157
  10246c:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  102471:	e9 98 04 00 00       	jmp    10290e <__alltraps>

00102476 <vector158>:
.globl vector158
vector158:
  pushl $0
  102476:	6a 00                	push   $0x0
  pushl $158
  102478:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  10247d:	e9 8c 04 00 00       	jmp    10290e <__alltraps>

00102482 <vector159>:
.globl vector159
vector159:
  pushl $0
  102482:	6a 00                	push   $0x0
  pushl $159
  102484:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  102489:	e9 80 04 00 00       	jmp    10290e <__alltraps>

0010248e <vector160>:
.globl vector160
vector160:
  pushl $0
  10248e:	6a 00                	push   $0x0
  pushl $160
  102490:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  102495:	e9 74 04 00 00       	jmp    10290e <__alltraps>

0010249a <vector161>:
.globl vector161
vector161:
  pushl $0
  10249a:	6a 00                	push   $0x0
  pushl $161
  10249c:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  1024a1:	e9 68 04 00 00       	jmp    10290e <__alltraps>

001024a6 <vector162>:
.globl vector162
vector162:
  pushl $0
  1024a6:	6a 00                	push   $0x0
  pushl $162
  1024a8:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  1024ad:	e9 5c 04 00 00       	jmp    10290e <__alltraps>

001024b2 <vector163>:
.globl vector163
vector163:
  pushl $0
  1024b2:	6a 00                	push   $0x0
  pushl $163
  1024b4:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  1024b9:	e9 50 04 00 00       	jmp    10290e <__alltraps>

001024be <vector164>:
.globl vector164
vector164:
  pushl $0
  1024be:	6a 00                	push   $0x0
  pushl $164
  1024c0:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  1024c5:	e9 44 04 00 00       	jmp    10290e <__alltraps>

001024ca <vector165>:
.globl vector165
vector165:
  pushl $0
  1024ca:	6a 00                	push   $0x0
  pushl $165
  1024cc:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  1024d1:	e9 38 04 00 00       	jmp    10290e <__alltraps>

001024d6 <vector166>:
.globl vector166
vector166:
  pushl $0
  1024d6:	6a 00                	push   $0x0
  pushl $166
  1024d8:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  1024dd:	e9 2c 04 00 00       	jmp    10290e <__alltraps>

001024e2 <vector167>:
.globl vector167
vector167:
  pushl $0
  1024e2:	6a 00                	push   $0x0
  pushl $167
  1024e4:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  1024e9:	e9 20 04 00 00       	jmp    10290e <__alltraps>

001024ee <vector168>:
.globl vector168
vector168:
  pushl $0
  1024ee:	6a 00                	push   $0x0
  pushl $168
  1024f0:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  1024f5:	e9 14 04 00 00       	jmp    10290e <__alltraps>

001024fa <vector169>:
.globl vector169
vector169:
  pushl $0
  1024fa:	6a 00                	push   $0x0
  pushl $169
  1024fc:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  102501:	e9 08 04 00 00       	jmp    10290e <__alltraps>

00102506 <vector170>:
.globl vector170
vector170:
  pushl $0
  102506:	6a 00                	push   $0x0
  pushl $170
  102508:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  10250d:	e9 fc 03 00 00       	jmp    10290e <__alltraps>

00102512 <vector171>:
.globl vector171
vector171:
  pushl $0
  102512:	6a 00                	push   $0x0
  pushl $171
  102514:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  102519:	e9 f0 03 00 00       	jmp    10290e <__alltraps>

0010251e <vector172>:
.globl vector172
vector172:
  pushl $0
  10251e:	6a 00                	push   $0x0
  pushl $172
  102520:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  102525:	e9 e4 03 00 00       	jmp    10290e <__alltraps>

0010252a <vector173>:
.globl vector173
vector173:
  pushl $0
  10252a:	6a 00                	push   $0x0
  pushl $173
  10252c:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  102531:	e9 d8 03 00 00       	jmp    10290e <__alltraps>

00102536 <vector174>:
.globl vector174
vector174:
  pushl $0
  102536:	6a 00                	push   $0x0
  pushl $174
  102538:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  10253d:	e9 cc 03 00 00       	jmp    10290e <__alltraps>

00102542 <vector175>:
.globl vector175
vector175:
  pushl $0
  102542:	6a 00                	push   $0x0
  pushl $175
  102544:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  102549:	e9 c0 03 00 00       	jmp    10290e <__alltraps>

0010254e <vector176>:
.globl vector176
vector176:
  pushl $0
  10254e:	6a 00                	push   $0x0
  pushl $176
  102550:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  102555:	e9 b4 03 00 00       	jmp    10290e <__alltraps>

0010255a <vector177>:
.globl vector177
vector177:
  pushl $0
  10255a:	6a 00                	push   $0x0
  pushl $177
  10255c:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  102561:	e9 a8 03 00 00       	jmp    10290e <__alltraps>

00102566 <vector178>:
.globl vector178
vector178:
  pushl $0
  102566:	6a 00                	push   $0x0
  pushl $178
  102568:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  10256d:	e9 9c 03 00 00       	jmp    10290e <__alltraps>

00102572 <vector179>:
.globl vector179
vector179:
  pushl $0
  102572:	6a 00                	push   $0x0
  pushl $179
  102574:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  102579:	e9 90 03 00 00       	jmp    10290e <__alltraps>

0010257e <vector180>:
.globl vector180
vector180:
  pushl $0
  10257e:	6a 00                	push   $0x0
  pushl $180
  102580:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  102585:	e9 84 03 00 00       	jmp    10290e <__alltraps>

0010258a <vector181>:
.globl vector181
vector181:
  pushl $0
  10258a:	6a 00                	push   $0x0
  pushl $181
  10258c:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  102591:	e9 78 03 00 00       	jmp    10290e <__alltraps>

00102596 <vector182>:
.globl vector182
vector182:
  pushl $0
  102596:	6a 00                	push   $0x0
  pushl $182
  102598:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  10259d:	e9 6c 03 00 00       	jmp    10290e <__alltraps>

001025a2 <vector183>:
.globl vector183
vector183:
  pushl $0
  1025a2:	6a 00                	push   $0x0
  pushl $183
  1025a4:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  1025a9:	e9 60 03 00 00       	jmp    10290e <__alltraps>

001025ae <vector184>:
.globl vector184
vector184:
  pushl $0
  1025ae:	6a 00                	push   $0x0
  pushl $184
  1025b0:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  1025b5:	e9 54 03 00 00       	jmp    10290e <__alltraps>

001025ba <vector185>:
.globl vector185
vector185:
  pushl $0
  1025ba:	6a 00                	push   $0x0
  pushl $185
  1025bc:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  1025c1:	e9 48 03 00 00       	jmp    10290e <__alltraps>

001025c6 <vector186>:
.globl vector186
vector186:
  pushl $0
  1025c6:	6a 00                	push   $0x0
  pushl $186
  1025c8:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  1025cd:	e9 3c 03 00 00       	jmp    10290e <__alltraps>

001025d2 <vector187>:
.globl vector187
vector187:
  pushl $0
  1025d2:	6a 00                	push   $0x0
  pushl $187
  1025d4:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  1025d9:	e9 30 03 00 00       	jmp    10290e <__alltraps>

001025de <vector188>:
.globl vector188
vector188:
  pushl $0
  1025de:	6a 00                	push   $0x0
  pushl $188
  1025e0:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  1025e5:	e9 24 03 00 00       	jmp    10290e <__alltraps>

001025ea <vector189>:
.globl vector189
vector189:
  pushl $0
  1025ea:	6a 00                	push   $0x0
  pushl $189
  1025ec:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  1025f1:	e9 18 03 00 00       	jmp    10290e <__alltraps>

001025f6 <vector190>:
.globl vector190
vector190:
  pushl $0
  1025f6:	6a 00                	push   $0x0
  pushl $190
  1025f8:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  1025fd:	e9 0c 03 00 00       	jmp    10290e <__alltraps>

00102602 <vector191>:
.globl vector191
vector191:
  pushl $0
  102602:	6a 00                	push   $0x0
  pushl $191
  102604:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  102609:	e9 00 03 00 00       	jmp    10290e <__alltraps>

0010260e <vector192>:
.globl vector192
vector192:
  pushl $0
  10260e:	6a 00                	push   $0x0
  pushl $192
  102610:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  102615:	e9 f4 02 00 00       	jmp    10290e <__alltraps>

0010261a <vector193>:
.globl vector193
vector193:
  pushl $0
  10261a:	6a 00                	push   $0x0
  pushl $193
  10261c:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  102621:	e9 e8 02 00 00       	jmp    10290e <__alltraps>

00102626 <vector194>:
.globl vector194
vector194:
  pushl $0
  102626:	6a 00                	push   $0x0
  pushl $194
  102628:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  10262d:	e9 dc 02 00 00       	jmp    10290e <__alltraps>

00102632 <vector195>:
.globl vector195
vector195:
  pushl $0
  102632:	6a 00                	push   $0x0
  pushl $195
  102634:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  102639:	e9 d0 02 00 00       	jmp    10290e <__alltraps>

0010263e <vector196>:
.globl vector196
vector196:
  pushl $0
  10263e:	6a 00                	push   $0x0
  pushl $196
  102640:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  102645:	e9 c4 02 00 00       	jmp    10290e <__alltraps>

0010264a <vector197>:
.globl vector197
vector197:
  pushl $0
  10264a:	6a 00                	push   $0x0
  pushl $197
  10264c:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102651:	e9 b8 02 00 00       	jmp    10290e <__alltraps>

00102656 <vector198>:
.globl vector198
vector198:
  pushl $0
  102656:	6a 00                	push   $0x0
  pushl $198
  102658:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  10265d:	e9 ac 02 00 00       	jmp    10290e <__alltraps>

00102662 <vector199>:
.globl vector199
vector199:
  pushl $0
  102662:	6a 00                	push   $0x0
  pushl $199
  102664:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  102669:	e9 a0 02 00 00       	jmp    10290e <__alltraps>

0010266e <vector200>:
.globl vector200
vector200:
  pushl $0
  10266e:	6a 00                	push   $0x0
  pushl $200
  102670:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  102675:	e9 94 02 00 00       	jmp    10290e <__alltraps>

0010267a <vector201>:
.globl vector201
vector201:
  pushl $0
  10267a:	6a 00                	push   $0x0
  pushl $201
  10267c:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  102681:	e9 88 02 00 00       	jmp    10290e <__alltraps>

00102686 <vector202>:
.globl vector202
vector202:
  pushl $0
  102686:	6a 00                	push   $0x0
  pushl $202
  102688:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  10268d:	e9 7c 02 00 00       	jmp    10290e <__alltraps>

00102692 <vector203>:
.globl vector203
vector203:
  pushl $0
  102692:	6a 00                	push   $0x0
  pushl $203
  102694:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  102699:	e9 70 02 00 00       	jmp    10290e <__alltraps>

0010269e <vector204>:
.globl vector204
vector204:
  pushl $0
  10269e:	6a 00                	push   $0x0
  pushl $204
  1026a0:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  1026a5:	e9 64 02 00 00       	jmp    10290e <__alltraps>

001026aa <vector205>:
.globl vector205
vector205:
  pushl $0
  1026aa:	6a 00                	push   $0x0
  pushl $205
  1026ac:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  1026b1:	e9 58 02 00 00       	jmp    10290e <__alltraps>

001026b6 <vector206>:
.globl vector206
vector206:
  pushl $0
  1026b6:	6a 00                	push   $0x0
  pushl $206
  1026b8:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  1026bd:	e9 4c 02 00 00       	jmp    10290e <__alltraps>

001026c2 <vector207>:
.globl vector207
vector207:
  pushl $0
  1026c2:	6a 00                	push   $0x0
  pushl $207
  1026c4:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  1026c9:	e9 40 02 00 00       	jmp    10290e <__alltraps>

001026ce <vector208>:
.globl vector208
vector208:
  pushl $0
  1026ce:	6a 00                	push   $0x0
  pushl $208
  1026d0:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  1026d5:	e9 34 02 00 00       	jmp    10290e <__alltraps>

001026da <vector209>:
.globl vector209
vector209:
  pushl $0
  1026da:	6a 00                	push   $0x0
  pushl $209
  1026dc:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  1026e1:	e9 28 02 00 00       	jmp    10290e <__alltraps>

001026e6 <vector210>:
.globl vector210
vector210:
  pushl $0
  1026e6:	6a 00                	push   $0x0
  pushl $210
  1026e8:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  1026ed:	e9 1c 02 00 00       	jmp    10290e <__alltraps>

001026f2 <vector211>:
.globl vector211
vector211:
  pushl $0
  1026f2:	6a 00                	push   $0x0
  pushl $211
  1026f4:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  1026f9:	e9 10 02 00 00       	jmp    10290e <__alltraps>

001026fe <vector212>:
.globl vector212
vector212:
  pushl $0
  1026fe:	6a 00                	push   $0x0
  pushl $212
  102700:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  102705:	e9 04 02 00 00       	jmp    10290e <__alltraps>

0010270a <vector213>:
.globl vector213
vector213:
  pushl $0
  10270a:	6a 00                	push   $0x0
  pushl $213
  10270c:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  102711:	e9 f8 01 00 00       	jmp    10290e <__alltraps>

00102716 <vector214>:
.globl vector214
vector214:
  pushl $0
  102716:	6a 00                	push   $0x0
  pushl $214
  102718:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  10271d:	e9 ec 01 00 00       	jmp    10290e <__alltraps>

00102722 <vector215>:
.globl vector215
vector215:
  pushl $0
  102722:	6a 00                	push   $0x0
  pushl $215
  102724:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  102729:	e9 e0 01 00 00       	jmp    10290e <__alltraps>

0010272e <vector216>:
.globl vector216
vector216:
  pushl $0
  10272e:	6a 00                	push   $0x0
  pushl $216
  102730:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  102735:	e9 d4 01 00 00       	jmp    10290e <__alltraps>

0010273a <vector217>:
.globl vector217
vector217:
  pushl $0
  10273a:	6a 00                	push   $0x0
  pushl $217
  10273c:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102741:	e9 c8 01 00 00       	jmp    10290e <__alltraps>

00102746 <vector218>:
.globl vector218
vector218:
  pushl $0
  102746:	6a 00                	push   $0x0
  pushl $218
  102748:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  10274d:	e9 bc 01 00 00       	jmp    10290e <__alltraps>

00102752 <vector219>:
.globl vector219
vector219:
  pushl $0
  102752:	6a 00                	push   $0x0
  pushl $219
  102754:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  102759:	e9 b0 01 00 00       	jmp    10290e <__alltraps>

0010275e <vector220>:
.globl vector220
vector220:
  pushl $0
  10275e:	6a 00                	push   $0x0
  pushl $220
  102760:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  102765:	e9 a4 01 00 00       	jmp    10290e <__alltraps>

0010276a <vector221>:
.globl vector221
vector221:
  pushl $0
  10276a:	6a 00                	push   $0x0
  pushl $221
  10276c:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  102771:	e9 98 01 00 00       	jmp    10290e <__alltraps>

00102776 <vector222>:
.globl vector222
vector222:
  pushl $0
  102776:	6a 00                	push   $0x0
  pushl $222
  102778:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  10277d:	e9 8c 01 00 00       	jmp    10290e <__alltraps>

00102782 <vector223>:
.globl vector223
vector223:
  pushl $0
  102782:	6a 00                	push   $0x0
  pushl $223
  102784:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  102789:	e9 80 01 00 00       	jmp    10290e <__alltraps>

0010278e <vector224>:
.globl vector224
vector224:
  pushl $0
  10278e:	6a 00                	push   $0x0
  pushl $224
  102790:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  102795:	e9 74 01 00 00       	jmp    10290e <__alltraps>

0010279a <vector225>:
.globl vector225
vector225:
  pushl $0
  10279a:	6a 00                	push   $0x0
  pushl $225
  10279c:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  1027a1:	e9 68 01 00 00       	jmp    10290e <__alltraps>

001027a6 <vector226>:
.globl vector226
vector226:
  pushl $0
  1027a6:	6a 00                	push   $0x0
  pushl $226
  1027a8:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  1027ad:	e9 5c 01 00 00       	jmp    10290e <__alltraps>

001027b2 <vector227>:
.globl vector227
vector227:
  pushl $0
  1027b2:	6a 00                	push   $0x0
  pushl $227
  1027b4:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  1027b9:	e9 50 01 00 00       	jmp    10290e <__alltraps>

001027be <vector228>:
.globl vector228
vector228:
  pushl $0
  1027be:	6a 00                	push   $0x0
  pushl $228
  1027c0:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  1027c5:	e9 44 01 00 00       	jmp    10290e <__alltraps>

001027ca <vector229>:
.globl vector229
vector229:
  pushl $0
  1027ca:	6a 00                	push   $0x0
  pushl $229
  1027cc:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  1027d1:	e9 38 01 00 00       	jmp    10290e <__alltraps>

001027d6 <vector230>:
.globl vector230
vector230:
  pushl $0
  1027d6:	6a 00                	push   $0x0
  pushl $230
  1027d8:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  1027dd:	e9 2c 01 00 00       	jmp    10290e <__alltraps>

001027e2 <vector231>:
.globl vector231
vector231:
  pushl $0
  1027e2:	6a 00                	push   $0x0
  pushl $231
  1027e4:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  1027e9:	e9 20 01 00 00       	jmp    10290e <__alltraps>

001027ee <vector232>:
.globl vector232
vector232:
  pushl $0
  1027ee:	6a 00                	push   $0x0
  pushl $232
  1027f0:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  1027f5:	e9 14 01 00 00       	jmp    10290e <__alltraps>

001027fa <vector233>:
.globl vector233
vector233:
  pushl $0
  1027fa:	6a 00                	push   $0x0
  pushl $233
  1027fc:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102801:	e9 08 01 00 00       	jmp    10290e <__alltraps>

00102806 <vector234>:
.globl vector234
vector234:
  pushl $0
  102806:	6a 00                	push   $0x0
  pushl $234
  102808:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  10280d:	e9 fc 00 00 00       	jmp    10290e <__alltraps>

00102812 <vector235>:
.globl vector235
vector235:
  pushl $0
  102812:	6a 00                	push   $0x0
  pushl $235
  102814:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  102819:	e9 f0 00 00 00       	jmp    10290e <__alltraps>

0010281e <vector236>:
.globl vector236
vector236:
  pushl $0
  10281e:	6a 00                	push   $0x0
  pushl $236
  102820:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102825:	e9 e4 00 00 00       	jmp    10290e <__alltraps>

0010282a <vector237>:
.globl vector237
vector237:
  pushl $0
  10282a:	6a 00                	push   $0x0
  pushl $237
  10282c:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102831:	e9 d8 00 00 00       	jmp    10290e <__alltraps>

00102836 <vector238>:
.globl vector238
vector238:
  pushl $0
  102836:	6a 00                	push   $0x0
  pushl $238
  102838:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  10283d:	e9 cc 00 00 00       	jmp    10290e <__alltraps>

00102842 <vector239>:
.globl vector239
vector239:
  pushl $0
  102842:	6a 00                	push   $0x0
  pushl $239
  102844:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  102849:	e9 c0 00 00 00       	jmp    10290e <__alltraps>

0010284e <vector240>:
.globl vector240
vector240:
  pushl $0
  10284e:	6a 00                	push   $0x0
  pushl $240
  102850:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102855:	e9 b4 00 00 00       	jmp    10290e <__alltraps>

0010285a <vector241>:
.globl vector241
vector241:
  pushl $0
  10285a:	6a 00                	push   $0x0
  pushl $241
  10285c:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102861:	e9 a8 00 00 00       	jmp    10290e <__alltraps>

00102866 <vector242>:
.globl vector242
vector242:
  pushl $0
  102866:	6a 00                	push   $0x0
  pushl $242
  102868:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  10286d:	e9 9c 00 00 00       	jmp    10290e <__alltraps>

00102872 <vector243>:
.globl vector243
vector243:
  pushl $0
  102872:	6a 00                	push   $0x0
  pushl $243
  102874:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  102879:	e9 90 00 00 00       	jmp    10290e <__alltraps>

0010287e <vector244>:
.globl vector244
vector244:
  pushl $0
  10287e:	6a 00                	push   $0x0
  pushl $244
  102880:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  102885:	e9 84 00 00 00       	jmp    10290e <__alltraps>

0010288a <vector245>:
.globl vector245
vector245:
  pushl $0
  10288a:	6a 00                	push   $0x0
  pushl $245
  10288c:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  102891:	e9 78 00 00 00       	jmp    10290e <__alltraps>

00102896 <vector246>:
.globl vector246
vector246:
  pushl $0
  102896:	6a 00                	push   $0x0
  pushl $246
  102898:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  10289d:	e9 6c 00 00 00       	jmp    10290e <__alltraps>

001028a2 <vector247>:
.globl vector247
vector247:
  pushl $0
  1028a2:	6a 00                	push   $0x0
  pushl $247
  1028a4:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  1028a9:	e9 60 00 00 00       	jmp    10290e <__alltraps>

001028ae <vector248>:
.globl vector248
vector248:
  pushl $0
  1028ae:	6a 00                	push   $0x0
  pushl $248
  1028b0:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  1028b5:	e9 54 00 00 00       	jmp    10290e <__alltraps>

001028ba <vector249>:
.globl vector249
vector249:
  pushl $0
  1028ba:	6a 00                	push   $0x0
  pushl $249
  1028bc:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  1028c1:	e9 48 00 00 00       	jmp    10290e <__alltraps>

001028c6 <vector250>:
.globl vector250
vector250:
  pushl $0
  1028c6:	6a 00                	push   $0x0
  pushl $250
  1028c8:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  1028cd:	e9 3c 00 00 00       	jmp    10290e <__alltraps>

001028d2 <vector251>:
.globl vector251
vector251:
  pushl $0
  1028d2:	6a 00                	push   $0x0
  pushl $251
  1028d4:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  1028d9:	e9 30 00 00 00       	jmp    10290e <__alltraps>

001028de <vector252>:
.globl vector252
vector252:
  pushl $0
  1028de:	6a 00                	push   $0x0
  pushl $252
  1028e0:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  1028e5:	e9 24 00 00 00       	jmp    10290e <__alltraps>

001028ea <vector253>:
.globl vector253
vector253:
  pushl $0
  1028ea:	6a 00                	push   $0x0
  pushl $253
  1028ec:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  1028f1:	e9 18 00 00 00       	jmp    10290e <__alltraps>

001028f6 <vector254>:
.globl vector254
vector254:
  pushl $0
  1028f6:	6a 00                	push   $0x0
  pushl $254
  1028f8:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  1028fd:	e9 0c 00 00 00       	jmp    10290e <__alltraps>

00102902 <vector255>:
.globl vector255
vector255:
  pushl $0
  102902:	6a 00                	push   $0x0
  pushl $255
  102904:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102909:	e9 00 00 00 00       	jmp    10290e <__alltraps>

0010290e <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  10290e:	1e                   	push   %ds
    pushl %es
  10290f:	06                   	push   %es
    pushl %fs
  102910:	0f a0                	push   %fs
    pushl %gs
  102912:	0f a8                	push   %gs
    pushal
  102914:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  102915:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  10291a:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  10291c:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  10291e:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  10291f:	e8 63 f5 ff ff       	call   101e87 <trap>

    # pop the pushed stack pointer
    popl %esp
  102924:	5c                   	pop    %esp

00102925 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  102925:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  102926:	0f a9                	pop    %gs
    popl %fs
  102928:	0f a1                	pop    %fs
    popl %es
  10292a:	07                   	pop    %es
    popl %ds
  10292b:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  10292c:	83 c4 08             	add    $0x8,%esp
    iret
  10292f:	cf                   	iret   

00102930 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  102930:	55                   	push   %ebp
  102931:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  102933:	8b 45 08             	mov    0x8(%ebp),%eax
  102936:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  102939:	b8 23 00 00 00       	mov    $0x23,%eax
  10293e:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  102940:	b8 23 00 00 00       	mov    $0x23,%eax
  102945:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102947:	b8 10 00 00 00       	mov    $0x10,%eax
  10294c:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  10294e:	b8 10 00 00 00       	mov    $0x10,%eax
  102953:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102955:	b8 10 00 00 00       	mov    $0x10,%eax
  10295a:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  10295c:	ea 63 29 10 00 08 00 	ljmp   $0x8,$0x102963
}
  102963:	90                   	nop
  102964:	5d                   	pop    %ebp
  102965:	c3                   	ret    

00102966 <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102966:	55                   	push   %ebp
  102967:	89 e5                	mov    %esp,%ebp
  102969:	83 ec 10             	sub    $0x10,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  10296c:	b8 80 f9 10 00       	mov    $0x10f980,%eax
  102971:	05 00 04 00 00       	add    $0x400,%eax
  102976:	a3 a4 f8 10 00       	mov    %eax,0x10f8a4
    ts.ts_ss0 = KERNEL_DS;
  10297b:	66 c7 05 a8 f8 10 00 	movw   $0x10,0x10f8a8
  102982:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  102984:	66 c7 05 08 ea 10 00 	movw   $0x68,0x10ea08
  10298b:	68 00 
  10298d:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  102992:	66 a3 0a ea 10 00    	mov    %ax,0x10ea0a
  102998:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  10299d:	c1 e8 10             	shr    $0x10,%eax
  1029a0:	a2 0c ea 10 00       	mov    %al,0x10ea0c
  1029a5:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1029ac:	83 e0 f0             	and    $0xfffffff0,%eax
  1029af:	83 c8 09             	or     $0x9,%eax
  1029b2:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1029b7:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1029be:	83 c8 10             	or     $0x10,%eax
  1029c1:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1029c6:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1029cd:	83 e0 9f             	and    $0xffffff9f,%eax
  1029d0:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1029d5:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1029dc:	83 c8 80             	or     $0xffffff80,%eax
  1029df:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1029e4:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1029eb:	83 e0 f0             	and    $0xfffffff0,%eax
  1029ee:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  1029f3:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1029fa:	83 e0 ef             	and    $0xffffffef,%eax
  1029fd:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102a02:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102a09:	83 e0 df             	and    $0xffffffdf,%eax
  102a0c:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102a11:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102a18:	83 c8 40             	or     $0x40,%eax
  102a1b:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102a20:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102a27:	83 e0 7f             	and    $0x7f,%eax
  102a2a:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102a2f:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  102a34:	c1 e8 18             	shr    $0x18,%eax
  102a37:	a2 0f ea 10 00       	mov    %al,0x10ea0f
    gdt[SEG_TSS].sd_s = 0;
  102a3c:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102a43:	83 e0 ef             	and    $0xffffffef,%eax
  102a46:	a2 0d ea 10 00       	mov    %al,0x10ea0d

    // reload all segment registers
    lgdt(&gdt_pd);
  102a4b:	68 10 ea 10 00       	push   $0x10ea10
  102a50:	e8 db fe ff ff       	call   102930 <lgdt>
  102a55:	83 c4 04             	add    $0x4,%esp
  102a58:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  102a5e:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102a62:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  102a65:	90                   	nop
  102a66:	c9                   	leave  
  102a67:	c3                   	ret    

00102a68 <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  102a68:	55                   	push   %ebp
  102a69:	89 e5                	mov    %esp,%ebp
    gdt_init();
  102a6b:	e8 f6 fe ff ff       	call   102966 <gdt_init>
}
  102a70:	90                   	nop
  102a71:	5d                   	pop    %ebp
  102a72:	c3                   	ret    

00102a73 <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  102a73:	55                   	push   %ebp
  102a74:	89 e5                	mov    %esp,%ebp
  102a76:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102a79:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  102a80:	eb 04                	jmp    102a86 <strlen+0x13>
        cnt ++;
  102a82:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  102a86:	8b 45 08             	mov    0x8(%ebp),%eax
  102a89:	8d 50 01             	lea    0x1(%eax),%edx
  102a8c:	89 55 08             	mov    %edx,0x8(%ebp)
  102a8f:	0f b6 00             	movzbl (%eax),%eax
  102a92:	84 c0                	test   %al,%al
  102a94:	75 ec                	jne    102a82 <strlen+0xf>
        cnt ++;
    }
    return cnt;
  102a96:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102a99:	c9                   	leave  
  102a9a:	c3                   	ret    

00102a9b <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  102a9b:	55                   	push   %ebp
  102a9c:	89 e5                	mov    %esp,%ebp
  102a9e:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102aa1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102aa8:	eb 04                	jmp    102aae <strnlen+0x13>
        cnt ++;
  102aaa:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  102aae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102ab1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  102ab4:	73 10                	jae    102ac6 <strnlen+0x2b>
  102ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  102ab9:	8d 50 01             	lea    0x1(%eax),%edx
  102abc:	89 55 08             	mov    %edx,0x8(%ebp)
  102abf:	0f b6 00             	movzbl (%eax),%eax
  102ac2:	84 c0                	test   %al,%al
  102ac4:	75 e4                	jne    102aaa <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  102ac6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102ac9:	c9                   	leave  
  102aca:	c3                   	ret    

00102acb <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  102acb:	55                   	push   %ebp
  102acc:	89 e5                	mov    %esp,%ebp
  102ace:	57                   	push   %edi
  102acf:	56                   	push   %esi
  102ad0:	83 ec 20             	sub    $0x20,%esp
  102ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  102ad6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102ad9:	8b 45 0c             	mov    0xc(%ebp),%eax
  102adc:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  102adf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102ae2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ae5:	89 d1                	mov    %edx,%ecx
  102ae7:	89 c2                	mov    %eax,%edx
  102ae9:	89 ce                	mov    %ecx,%esi
  102aeb:	89 d7                	mov    %edx,%edi
  102aed:	ac                   	lods   %ds:(%esi),%al
  102aee:	aa                   	stos   %al,%es:(%edi)
  102aef:	84 c0                	test   %al,%al
  102af1:	75 fa                	jne    102aed <strcpy+0x22>
  102af3:	89 fa                	mov    %edi,%edx
  102af5:	89 f1                	mov    %esi,%ecx
  102af7:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102afa:	89 55 e8             	mov    %edx,-0x18(%ebp)
  102afd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  102b00:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
  102b03:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  102b04:	83 c4 20             	add    $0x20,%esp
  102b07:	5e                   	pop    %esi
  102b08:	5f                   	pop    %edi
  102b09:	5d                   	pop    %ebp
  102b0a:	c3                   	ret    

00102b0b <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  102b0b:	55                   	push   %ebp
  102b0c:	89 e5                	mov    %esp,%ebp
  102b0e:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  102b11:	8b 45 08             	mov    0x8(%ebp),%eax
  102b14:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  102b17:	eb 21                	jmp    102b3a <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  102b19:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b1c:	0f b6 10             	movzbl (%eax),%edx
  102b1f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102b22:	88 10                	mov    %dl,(%eax)
  102b24:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102b27:	0f b6 00             	movzbl (%eax),%eax
  102b2a:	84 c0                	test   %al,%al
  102b2c:	74 04                	je     102b32 <strncpy+0x27>
            src ++;
  102b2e:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  102b32:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  102b36:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  102b3a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102b3e:	75 d9                	jne    102b19 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  102b40:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102b43:	c9                   	leave  
  102b44:	c3                   	ret    

00102b45 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  102b45:	55                   	push   %ebp
  102b46:	89 e5                	mov    %esp,%ebp
  102b48:	57                   	push   %edi
  102b49:	56                   	push   %esi
  102b4a:	83 ec 20             	sub    $0x20,%esp
  102b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  102b50:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102b53:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b56:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  102b59:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102b5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b5f:	89 d1                	mov    %edx,%ecx
  102b61:	89 c2                	mov    %eax,%edx
  102b63:	89 ce                	mov    %ecx,%esi
  102b65:	89 d7                	mov    %edx,%edi
  102b67:	ac                   	lods   %ds:(%esi),%al
  102b68:	ae                   	scas   %es:(%edi),%al
  102b69:	75 08                	jne    102b73 <strcmp+0x2e>
  102b6b:	84 c0                	test   %al,%al
  102b6d:	75 f8                	jne    102b67 <strcmp+0x22>
  102b6f:	31 c0                	xor    %eax,%eax
  102b71:	eb 04                	jmp    102b77 <strcmp+0x32>
  102b73:	19 c0                	sbb    %eax,%eax
  102b75:	0c 01                	or     $0x1,%al
  102b77:	89 fa                	mov    %edi,%edx
  102b79:	89 f1                	mov    %esi,%ecx
  102b7b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102b7e:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  102b81:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            "orb $1, %%al;"
            "3:"
            : "=a" (ret), "=&S" (d0), "=&D" (d1)
            : "1" (s1), "2" (s2)
            : "memory");
    return ret;
  102b84:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
  102b87:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  102b88:	83 c4 20             	add    $0x20,%esp
  102b8b:	5e                   	pop    %esi
  102b8c:	5f                   	pop    %edi
  102b8d:	5d                   	pop    %ebp
  102b8e:	c3                   	ret    

00102b8f <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  102b8f:	55                   	push   %ebp
  102b90:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102b92:	eb 0c                	jmp    102ba0 <strncmp+0x11>
        n --, s1 ++, s2 ++;
  102b94:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  102b98:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102b9c:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102ba0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102ba4:	74 1a                	je     102bc0 <strncmp+0x31>
  102ba6:	8b 45 08             	mov    0x8(%ebp),%eax
  102ba9:	0f b6 00             	movzbl (%eax),%eax
  102bac:	84 c0                	test   %al,%al
  102bae:	74 10                	je     102bc0 <strncmp+0x31>
  102bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  102bb3:	0f b6 10             	movzbl (%eax),%edx
  102bb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  102bb9:	0f b6 00             	movzbl (%eax),%eax
  102bbc:	38 c2                	cmp    %al,%dl
  102bbe:	74 d4                	je     102b94 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  102bc0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102bc4:	74 18                	je     102bde <strncmp+0x4f>
  102bc6:	8b 45 08             	mov    0x8(%ebp),%eax
  102bc9:	0f b6 00             	movzbl (%eax),%eax
  102bcc:	0f b6 d0             	movzbl %al,%edx
  102bcf:	8b 45 0c             	mov    0xc(%ebp),%eax
  102bd2:	0f b6 00             	movzbl (%eax),%eax
  102bd5:	0f b6 c0             	movzbl %al,%eax
  102bd8:	29 c2                	sub    %eax,%edx
  102bda:	89 d0                	mov    %edx,%eax
  102bdc:	eb 05                	jmp    102be3 <strncmp+0x54>
  102bde:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102be3:	5d                   	pop    %ebp
  102be4:	c3                   	ret    

00102be5 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  102be5:	55                   	push   %ebp
  102be6:	89 e5                	mov    %esp,%ebp
  102be8:	83 ec 04             	sub    $0x4,%esp
  102beb:	8b 45 0c             	mov    0xc(%ebp),%eax
  102bee:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102bf1:	eb 14                	jmp    102c07 <strchr+0x22>
        if (*s == c) {
  102bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  102bf6:	0f b6 00             	movzbl (%eax),%eax
  102bf9:	3a 45 fc             	cmp    -0x4(%ebp),%al
  102bfc:	75 05                	jne    102c03 <strchr+0x1e>
            return (char *)s;
  102bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  102c01:	eb 13                	jmp    102c16 <strchr+0x31>
        }
        s ++;
  102c03:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  102c07:	8b 45 08             	mov    0x8(%ebp),%eax
  102c0a:	0f b6 00             	movzbl (%eax),%eax
  102c0d:	84 c0                	test   %al,%al
  102c0f:	75 e2                	jne    102bf3 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  102c11:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102c16:	c9                   	leave  
  102c17:	c3                   	ret    

00102c18 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  102c18:	55                   	push   %ebp
  102c19:	89 e5                	mov    %esp,%ebp
  102c1b:	83 ec 04             	sub    $0x4,%esp
  102c1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c21:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102c24:	eb 0f                	jmp    102c35 <strfind+0x1d>
        if (*s == c) {
  102c26:	8b 45 08             	mov    0x8(%ebp),%eax
  102c29:	0f b6 00             	movzbl (%eax),%eax
  102c2c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  102c2f:	74 10                	je     102c41 <strfind+0x29>
            break;
        }
        s ++;
  102c31:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  102c35:	8b 45 08             	mov    0x8(%ebp),%eax
  102c38:	0f b6 00             	movzbl (%eax),%eax
  102c3b:	84 c0                	test   %al,%al
  102c3d:	75 e7                	jne    102c26 <strfind+0xe>
  102c3f:	eb 01                	jmp    102c42 <strfind+0x2a>
        if (*s == c) {
            break;
  102c41:	90                   	nop
        }
        s ++;
    }
    return (char *)s;
  102c42:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102c45:	c9                   	leave  
  102c46:	c3                   	ret    

00102c47 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  102c47:	55                   	push   %ebp
  102c48:	89 e5                	mov    %esp,%ebp
  102c4a:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  102c4d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  102c54:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  102c5b:	eb 04                	jmp    102c61 <strtol+0x1a>
        s ++;
  102c5d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  102c61:	8b 45 08             	mov    0x8(%ebp),%eax
  102c64:	0f b6 00             	movzbl (%eax),%eax
  102c67:	3c 20                	cmp    $0x20,%al
  102c69:	74 f2                	je     102c5d <strtol+0x16>
  102c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  102c6e:	0f b6 00             	movzbl (%eax),%eax
  102c71:	3c 09                	cmp    $0x9,%al
  102c73:	74 e8                	je     102c5d <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  102c75:	8b 45 08             	mov    0x8(%ebp),%eax
  102c78:	0f b6 00             	movzbl (%eax),%eax
  102c7b:	3c 2b                	cmp    $0x2b,%al
  102c7d:	75 06                	jne    102c85 <strtol+0x3e>
        s ++;
  102c7f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102c83:	eb 15                	jmp    102c9a <strtol+0x53>
    }
    else if (*s == '-') {
  102c85:	8b 45 08             	mov    0x8(%ebp),%eax
  102c88:	0f b6 00             	movzbl (%eax),%eax
  102c8b:	3c 2d                	cmp    $0x2d,%al
  102c8d:	75 0b                	jne    102c9a <strtol+0x53>
        s ++, neg = 1;
  102c8f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102c93:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  102c9a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102c9e:	74 06                	je     102ca6 <strtol+0x5f>
  102ca0:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  102ca4:	75 24                	jne    102cca <strtol+0x83>
  102ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  102ca9:	0f b6 00             	movzbl (%eax),%eax
  102cac:	3c 30                	cmp    $0x30,%al
  102cae:	75 1a                	jne    102cca <strtol+0x83>
  102cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  102cb3:	83 c0 01             	add    $0x1,%eax
  102cb6:	0f b6 00             	movzbl (%eax),%eax
  102cb9:	3c 78                	cmp    $0x78,%al
  102cbb:	75 0d                	jne    102cca <strtol+0x83>
        s += 2, base = 16;
  102cbd:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  102cc1:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  102cc8:	eb 2a                	jmp    102cf4 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  102cca:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102cce:	75 17                	jne    102ce7 <strtol+0xa0>
  102cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  102cd3:	0f b6 00             	movzbl (%eax),%eax
  102cd6:	3c 30                	cmp    $0x30,%al
  102cd8:	75 0d                	jne    102ce7 <strtol+0xa0>
        s ++, base = 8;
  102cda:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102cde:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  102ce5:	eb 0d                	jmp    102cf4 <strtol+0xad>
    }
    else if (base == 0) {
  102ce7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102ceb:	75 07                	jne    102cf4 <strtol+0xad>
        base = 10;
  102ced:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  102cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  102cf7:	0f b6 00             	movzbl (%eax),%eax
  102cfa:	3c 2f                	cmp    $0x2f,%al
  102cfc:	7e 1b                	jle    102d19 <strtol+0xd2>
  102cfe:	8b 45 08             	mov    0x8(%ebp),%eax
  102d01:	0f b6 00             	movzbl (%eax),%eax
  102d04:	3c 39                	cmp    $0x39,%al
  102d06:	7f 11                	jg     102d19 <strtol+0xd2>
            dig = *s - '0';
  102d08:	8b 45 08             	mov    0x8(%ebp),%eax
  102d0b:	0f b6 00             	movzbl (%eax),%eax
  102d0e:	0f be c0             	movsbl %al,%eax
  102d11:	83 e8 30             	sub    $0x30,%eax
  102d14:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102d17:	eb 48                	jmp    102d61 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  102d19:	8b 45 08             	mov    0x8(%ebp),%eax
  102d1c:	0f b6 00             	movzbl (%eax),%eax
  102d1f:	3c 60                	cmp    $0x60,%al
  102d21:	7e 1b                	jle    102d3e <strtol+0xf7>
  102d23:	8b 45 08             	mov    0x8(%ebp),%eax
  102d26:	0f b6 00             	movzbl (%eax),%eax
  102d29:	3c 7a                	cmp    $0x7a,%al
  102d2b:	7f 11                	jg     102d3e <strtol+0xf7>
            dig = *s - 'a' + 10;
  102d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  102d30:	0f b6 00             	movzbl (%eax),%eax
  102d33:	0f be c0             	movsbl %al,%eax
  102d36:	83 e8 57             	sub    $0x57,%eax
  102d39:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102d3c:	eb 23                	jmp    102d61 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  102d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  102d41:	0f b6 00             	movzbl (%eax),%eax
  102d44:	3c 40                	cmp    $0x40,%al
  102d46:	7e 3c                	jle    102d84 <strtol+0x13d>
  102d48:	8b 45 08             	mov    0x8(%ebp),%eax
  102d4b:	0f b6 00             	movzbl (%eax),%eax
  102d4e:	3c 5a                	cmp    $0x5a,%al
  102d50:	7f 32                	jg     102d84 <strtol+0x13d>
            dig = *s - 'A' + 10;
  102d52:	8b 45 08             	mov    0x8(%ebp),%eax
  102d55:	0f b6 00             	movzbl (%eax),%eax
  102d58:	0f be c0             	movsbl %al,%eax
  102d5b:	83 e8 37             	sub    $0x37,%eax
  102d5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  102d61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d64:	3b 45 10             	cmp    0x10(%ebp),%eax
  102d67:	7d 1a                	jge    102d83 <strtol+0x13c>
            break;
        }
        s ++, val = (val * base) + dig;
  102d69:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102d6d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102d70:	0f af 45 10          	imul   0x10(%ebp),%eax
  102d74:	89 c2                	mov    %eax,%edx
  102d76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d79:	01 d0                	add    %edx,%eax
  102d7b:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  102d7e:	e9 71 ff ff ff       	jmp    102cf4 <strtol+0xad>
        }
        else {
            break;
        }
        if (dig >= base) {
            break;
  102d83:	90                   	nop
        }
        s ++, val = (val * base) + dig;
        // we don't properly detect overflow!
    }

    if (endptr) {
  102d84:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102d88:	74 08                	je     102d92 <strtol+0x14b>
        *endptr = (char *) s;
  102d8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d8d:	8b 55 08             	mov    0x8(%ebp),%edx
  102d90:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  102d92:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  102d96:	74 07                	je     102d9f <strtol+0x158>
  102d98:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102d9b:	f7 d8                	neg    %eax
  102d9d:	eb 03                	jmp    102da2 <strtol+0x15b>
  102d9f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  102da2:	c9                   	leave  
  102da3:	c3                   	ret    

00102da4 <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  102da4:	55                   	push   %ebp
  102da5:	89 e5                	mov    %esp,%ebp
  102da7:	57                   	push   %edi
  102da8:	83 ec 24             	sub    $0x24,%esp
  102dab:	8b 45 0c             	mov    0xc(%ebp),%eax
  102dae:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  102db1:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  102db5:	8b 55 08             	mov    0x8(%ebp),%edx
  102db8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  102dbb:	88 45 f7             	mov    %al,-0x9(%ebp)
  102dbe:	8b 45 10             	mov    0x10(%ebp),%eax
  102dc1:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  102dc4:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  102dc7:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  102dcb:	8b 55 f8             	mov    -0x8(%ebp),%edx
  102dce:	89 d7                	mov    %edx,%edi
  102dd0:	f3 aa                	rep stos %al,%es:(%edi)
  102dd2:	89 fa                	mov    %edi,%edx
  102dd4:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102dd7:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  102dda:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102ddd:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  102dde:	83 c4 24             	add    $0x24,%esp
  102de1:	5f                   	pop    %edi
  102de2:	5d                   	pop    %ebp
  102de3:	c3                   	ret    

00102de4 <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  102de4:	55                   	push   %ebp
  102de5:	89 e5                	mov    %esp,%ebp
  102de7:	57                   	push   %edi
  102de8:	56                   	push   %esi
  102de9:	53                   	push   %ebx
  102dea:	83 ec 30             	sub    $0x30,%esp
  102ded:	8b 45 08             	mov    0x8(%ebp),%eax
  102df0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102df3:	8b 45 0c             	mov    0xc(%ebp),%eax
  102df6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102df9:	8b 45 10             	mov    0x10(%ebp),%eax
  102dfc:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  102dff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e02:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  102e05:	73 42                	jae    102e49 <memmove+0x65>
  102e07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e0a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102e0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102e10:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102e13:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102e16:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  102e19:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102e1c:	c1 e8 02             	shr    $0x2,%eax
  102e1f:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  102e21:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102e24:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102e27:	89 d7                	mov    %edx,%edi
  102e29:	89 c6                	mov    %eax,%esi
  102e2b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  102e2d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  102e30:	83 e1 03             	and    $0x3,%ecx
  102e33:	74 02                	je     102e37 <memmove+0x53>
  102e35:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102e37:	89 f0                	mov    %esi,%eax
  102e39:	89 fa                	mov    %edi,%edx
  102e3b:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  102e3e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102e41:	89 45 d0             	mov    %eax,-0x30(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  102e44:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
  102e47:	eb 36                	jmp    102e7f <memmove+0x9b>
    asm volatile (
            "std;"
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  102e49:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102e4c:	8d 50 ff             	lea    -0x1(%eax),%edx
  102e4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102e52:	01 c2                	add    %eax,%edx
  102e54:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102e57:	8d 48 ff             	lea    -0x1(%eax),%ecx
  102e5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e5d:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  102e60:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102e63:	89 c1                	mov    %eax,%ecx
  102e65:	89 d8                	mov    %ebx,%eax
  102e67:	89 d6                	mov    %edx,%esi
  102e69:	89 c7                	mov    %eax,%edi
  102e6b:	fd                   	std    
  102e6c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102e6e:	fc                   	cld    
  102e6f:	89 f8                	mov    %edi,%eax
  102e71:	89 f2                	mov    %esi,%edx
  102e73:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  102e76:	89 55 c8             	mov    %edx,-0x38(%ebp)
  102e79:	89 45 c4             	mov    %eax,-0x3c(%ebp)
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
            : "memory");
    return dst;
  102e7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  102e7f:	83 c4 30             	add    $0x30,%esp
  102e82:	5b                   	pop    %ebx
  102e83:	5e                   	pop    %esi
  102e84:	5f                   	pop    %edi
  102e85:	5d                   	pop    %ebp
  102e86:	c3                   	ret    

00102e87 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  102e87:	55                   	push   %ebp
  102e88:	89 e5                	mov    %esp,%ebp
  102e8a:	57                   	push   %edi
  102e8b:	56                   	push   %esi
  102e8c:	83 ec 20             	sub    $0x20,%esp
  102e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  102e92:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102e95:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e98:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e9b:	8b 45 10             	mov    0x10(%ebp),%eax
  102e9e:	89 45 ec             	mov    %eax,-0x14(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  102ea1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102ea4:	c1 e8 02             	shr    $0x2,%eax
  102ea7:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  102ea9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102eac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102eaf:	89 d7                	mov    %edx,%edi
  102eb1:	89 c6                	mov    %eax,%esi
  102eb3:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  102eb5:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  102eb8:	83 e1 03             	and    $0x3,%ecx
  102ebb:	74 02                	je     102ebf <memcpy+0x38>
  102ebd:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102ebf:	89 f0                	mov    %esi,%eax
  102ec1:	89 fa                	mov    %edi,%edx
  102ec3:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  102ec6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  102ec9:	89 45 e0             	mov    %eax,-0x20(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  102ecc:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
  102ecf:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  102ed0:	83 c4 20             	add    $0x20,%esp
  102ed3:	5e                   	pop    %esi
  102ed4:	5f                   	pop    %edi
  102ed5:	5d                   	pop    %ebp
  102ed6:	c3                   	ret    

00102ed7 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  102ed7:	55                   	push   %ebp
  102ed8:	89 e5                	mov    %esp,%ebp
  102eda:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  102edd:	8b 45 08             	mov    0x8(%ebp),%eax
  102ee0:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  102ee3:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ee6:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  102ee9:	eb 30                	jmp    102f1b <memcmp+0x44>
        if (*s1 != *s2) {
  102eeb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102eee:	0f b6 10             	movzbl (%eax),%edx
  102ef1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102ef4:	0f b6 00             	movzbl (%eax),%eax
  102ef7:	38 c2                	cmp    %al,%dl
  102ef9:	74 18                	je     102f13 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  102efb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102efe:	0f b6 00             	movzbl (%eax),%eax
  102f01:	0f b6 d0             	movzbl %al,%edx
  102f04:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102f07:	0f b6 00             	movzbl (%eax),%eax
  102f0a:	0f b6 c0             	movzbl %al,%eax
  102f0d:	29 c2                	sub    %eax,%edx
  102f0f:	89 d0                	mov    %edx,%eax
  102f11:	eb 1a                	jmp    102f2d <memcmp+0x56>
        }
        s1 ++, s2 ++;
  102f13:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  102f17:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  102f1b:	8b 45 10             	mov    0x10(%ebp),%eax
  102f1e:	8d 50 ff             	lea    -0x1(%eax),%edx
  102f21:	89 55 10             	mov    %edx,0x10(%ebp)
  102f24:	85 c0                	test   %eax,%eax
  102f26:	75 c3                	jne    102eeb <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  102f28:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102f2d:	c9                   	leave  
  102f2e:	c3                   	ret    

00102f2f <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  102f2f:	55                   	push   %ebp
  102f30:	89 e5                	mov    %esp,%ebp
  102f32:	83 ec 38             	sub    $0x38,%esp
  102f35:	8b 45 10             	mov    0x10(%ebp),%eax
  102f38:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102f3b:	8b 45 14             	mov    0x14(%ebp),%eax
  102f3e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  102f41:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102f44:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102f47:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102f4a:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  102f4d:	8b 45 18             	mov    0x18(%ebp),%eax
  102f50:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102f53:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102f56:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102f59:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102f5c:	89 55 f0             	mov    %edx,-0x10(%ebp)
  102f5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f62:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102f65:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102f69:	74 1c                	je     102f87 <printnum+0x58>
  102f6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f6e:	ba 00 00 00 00       	mov    $0x0,%edx
  102f73:	f7 75 e4             	divl   -0x1c(%ebp)
  102f76:	89 55 f4             	mov    %edx,-0xc(%ebp)
  102f79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f7c:	ba 00 00 00 00       	mov    $0x0,%edx
  102f81:	f7 75 e4             	divl   -0x1c(%ebp)
  102f84:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f87:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102f8a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102f8d:	f7 75 e4             	divl   -0x1c(%ebp)
  102f90:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102f93:	89 55 dc             	mov    %edx,-0x24(%ebp)
  102f96:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102f99:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102f9c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102f9f:	89 55 ec             	mov    %edx,-0x14(%ebp)
  102fa2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102fa5:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  102fa8:	8b 45 18             	mov    0x18(%ebp),%eax
  102fab:	ba 00 00 00 00       	mov    $0x0,%edx
  102fb0:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102fb3:	77 41                	ja     102ff6 <printnum+0xc7>
  102fb5:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102fb8:	72 05                	jb     102fbf <printnum+0x90>
  102fba:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  102fbd:	77 37                	ja     102ff6 <printnum+0xc7>
        printnum(putch, putdat, result, base, width - 1, padc);
  102fbf:	8b 45 1c             	mov    0x1c(%ebp),%eax
  102fc2:	83 e8 01             	sub    $0x1,%eax
  102fc5:	83 ec 04             	sub    $0x4,%esp
  102fc8:	ff 75 20             	pushl  0x20(%ebp)
  102fcb:	50                   	push   %eax
  102fcc:	ff 75 18             	pushl  0x18(%ebp)
  102fcf:	ff 75 ec             	pushl  -0x14(%ebp)
  102fd2:	ff 75 e8             	pushl  -0x18(%ebp)
  102fd5:	ff 75 0c             	pushl  0xc(%ebp)
  102fd8:	ff 75 08             	pushl  0x8(%ebp)
  102fdb:	e8 4f ff ff ff       	call   102f2f <printnum>
  102fe0:	83 c4 20             	add    $0x20,%esp
  102fe3:	eb 1b                	jmp    103000 <printnum+0xd1>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  102fe5:	83 ec 08             	sub    $0x8,%esp
  102fe8:	ff 75 0c             	pushl  0xc(%ebp)
  102feb:	ff 75 20             	pushl  0x20(%ebp)
  102fee:	8b 45 08             	mov    0x8(%ebp),%eax
  102ff1:	ff d0                	call   *%eax
  102ff3:	83 c4 10             	add    $0x10,%esp
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  102ff6:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  102ffa:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  102ffe:	7f e5                	jg     102fe5 <printnum+0xb6>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  103000:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103003:	05 d0 3c 10 00       	add    $0x103cd0,%eax
  103008:	0f b6 00             	movzbl (%eax),%eax
  10300b:	0f be c0             	movsbl %al,%eax
  10300e:	83 ec 08             	sub    $0x8,%esp
  103011:	ff 75 0c             	pushl  0xc(%ebp)
  103014:	50                   	push   %eax
  103015:	8b 45 08             	mov    0x8(%ebp),%eax
  103018:	ff d0                	call   *%eax
  10301a:	83 c4 10             	add    $0x10,%esp
}
  10301d:	90                   	nop
  10301e:	c9                   	leave  
  10301f:	c3                   	ret    

00103020 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  103020:	55                   	push   %ebp
  103021:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  103023:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  103027:	7e 14                	jle    10303d <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  103029:	8b 45 08             	mov    0x8(%ebp),%eax
  10302c:	8b 00                	mov    (%eax),%eax
  10302e:	8d 48 08             	lea    0x8(%eax),%ecx
  103031:	8b 55 08             	mov    0x8(%ebp),%edx
  103034:	89 0a                	mov    %ecx,(%edx)
  103036:	8b 50 04             	mov    0x4(%eax),%edx
  103039:	8b 00                	mov    (%eax),%eax
  10303b:	eb 30                	jmp    10306d <getuint+0x4d>
    }
    else if (lflag) {
  10303d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  103041:	74 16                	je     103059 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  103043:	8b 45 08             	mov    0x8(%ebp),%eax
  103046:	8b 00                	mov    (%eax),%eax
  103048:	8d 48 04             	lea    0x4(%eax),%ecx
  10304b:	8b 55 08             	mov    0x8(%ebp),%edx
  10304e:	89 0a                	mov    %ecx,(%edx)
  103050:	8b 00                	mov    (%eax),%eax
  103052:	ba 00 00 00 00       	mov    $0x0,%edx
  103057:	eb 14                	jmp    10306d <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  103059:	8b 45 08             	mov    0x8(%ebp),%eax
  10305c:	8b 00                	mov    (%eax),%eax
  10305e:	8d 48 04             	lea    0x4(%eax),%ecx
  103061:	8b 55 08             	mov    0x8(%ebp),%edx
  103064:	89 0a                	mov    %ecx,(%edx)
  103066:	8b 00                	mov    (%eax),%eax
  103068:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  10306d:	5d                   	pop    %ebp
  10306e:	c3                   	ret    

0010306f <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  10306f:	55                   	push   %ebp
  103070:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  103072:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  103076:	7e 14                	jle    10308c <getint+0x1d>
        return va_arg(*ap, long long);
  103078:	8b 45 08             	mov    0x8(%ebp),%eax
  10307b:	8b 00                	mov    (%eax),%eax
  10307d:	8d 48 08             	lea    0x8(%eax),%ecx
  103080:	8b 55 08             	mov    0x8(%ebp),%edx
  103083:	89 0a                	mov    %ecx,(%edx)
  103085:	8b 50 04             	mov    0x4(%eax),%edx
  103088:	8b 00                	mov    (%eax),%eax
  10308a:	eb 28                	jmp    1030b4 <getint+0x45>
    }
    else if (lflag) {
  10308c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  103090:	74 12                	je     1030a4 <getint+0x35>
        return va_arg(*ap, long);
  103092:	8b 45 08             	mov    0x8(%ebp),%eax
  103095:	8b 00                	mov    (%eax),%eax
  103097:	8d 48 04             	lea    0x4(%eax),%ecx
  10309a:	8b 55 08             	mov    0x8(%ebp),%edx
  10309d:	89 0a                	mov    %ecx,(%edx)
  10309f:	8b 00                	mov    (%eax),%eax
  1030a1:	99                   	cltd   
  1030a2:	eb 10                	jmp    1030b4 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  1030a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1030a7:	8b 00                	mov    (%eax),%eax
  1030a9:	8d 48 04             	lea    0x4(%eax),%ecx
  1030ac:	8b 55 08             	mov    0x8(%ebp),%edx
  1030af:	89 0a                	mov    %ecx,(%edx)
  1030b1:	8b 00                	mov    (%eax),%eax
  1030b3:	99                   	cltd   
    }
}
  1030b4:	5d                   	pop    %ebp
  1030b5:	c3                   	ret    

001030b6 <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  1030b6:	55                   	push   %ebp
  1030b7:	89 e5                	mov    %esp,%ebp
  1030b9:	83 ec 18             	sub    $0x18,%esp
    va_list ap;

    va_start(ap, fmt);
  1030bc:	8d 45 14             	lea    0x14(%ebp),%eax
  1030bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  1030c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1030c5:	50                   	push   %eax
  1030c6:	ff 75 10             	pushl  0x10(%ebp)
  1030c9:	ff 75 0c             	pushl  0xc(%ebp)
  1030cc:	ff 75 08             	pushl  0x8(%ebp)
  1030cf:	e8 06 00 00 00       	call   1030da <vprintfmt>
  1030d4:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
  1030d7:	90                   	nop
  1030d8:	c9                   	leave  
  1030d9:	c3                   	ret    

001030da <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  1030da:	55                   	push   %ebp
  1030db:	89 e5                	mov    %esp,%ebp
  1030dd:	56                   	push   %esi
  1030de:	53                   	push   %ebx
  1030df:	83 ec 20             	sub    $0x20,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1030e2:	eb 17                	jmp    1030fb <vprintfmt+0x21>
            if (ch == '\0') {
  1030e4:	85 db                	test   %ebx,%ebx
  1030e6:	0f 84 8e 03 00 00    	je     10347a <vprintfmt+0x3a0>
                return;
            }
            putch(ch, putdat);
  1030ec:	83 ec 08             	sub    $0x8,%esp
  1030ef:	ff 75 0c             	pushl  0xc(%ebp)
  1030f2:	53                   	push   %ebx
  1030f3:	8b 45 08             	mov    0x8(%ebp),%eax
  1030f6:	ff d0                	call   *%eax
  1030f8:	83 c4 10             	add    $0x10,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1030fb:	8b 45 10             	mov    0x10(%ebp),%eax
  1030fe:	8d 50 01             	lea    0x1(%eax),%edx
  103101:	89 55 10             	mov    %edx,0x10(%ebp)
  103104:	0f b6 00             	movzbl (%eax),%eax
  103107:	0f b6 d8             	movzbl %al,%ebx
  10310a:	83 fb 25             	cmp    $0x25,%ebx
  10310d:	75 d5                	jne    1030e4 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  10310f:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  103113:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  10311a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10311d:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  103120:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103127:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10312a:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  10312d:	8b 45 10             	mov    0x10(%ebp),%eax
  103130:	8d 50 01             	lea    0x1(%eax),%edx
  103133:	89 55 10             	mov    %edx,0x10(%ebp)
  103136:	0f b6 00             	movzbl (%eax),%eax
  103139:	0f b6 d8             	movzbl %al,%ebx
  10313c:	8d 43 dd             	lea    -0x23(%ebx),%eax
  10313f:	83 f8 55             	cmp    $0x55,%eax
  103142:	0f 87 05 03 00 00    	ja     10344d <vprintfmt+0x373>
  103148:	8b 04 85 f4 3c 10 00 	mov    0x103cf4(,%eax,4),%eax
  10314f:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  103151:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  103155:	eb d6                	jmp    10312d <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  103157:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  10315b:	eb d0                	jmp    10312d <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  10315d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  103164:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103167:	89 d0                	mov    %edx,%eax
  103169:	c1 e0 02             	shl    $0x2,%eax
  10316c:	01 d0                	add    %edx,%eax
  10316e:	01 c0                	add    %eax,%eax
  103170:	01 d8                	add    %ebx,%eax
  103172:	83 e8 30             	sub    $0x30,%eax
  103175:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  103178:	8b 45 10             	mov    0x10(%ebp),%eax
  10317b:	0f b6 00             	movzbl (%eax),%eax
  10317e:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  103181:	83 fb 2f             	cmp    $0x2f,%ebx
  103184:	7e 39                	jle    1031bf <vprintfmt+0xe5>
  103186:	83 fb 39             	cmp    $0x39,%ebx
  103189:	7f 34                	jg     1031bf <vprintfmt+0xe5>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  10318b:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  10318f:	eb d3                	jmp    103164 <vprintfmt+0x8a>
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  103191:	8b 45 14             	mov    0x14(%ebp),%eax
  103194:	8d 50 04             	lea    0x4(%eax),%edx
  103197:	89 55 14             	mov    %edx,0x14(%ebp)
  10319a:	8b 00                	mov    (%eax),%eax
  10319c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  10319f:	eb 1f                	jmp    1031c0 <vprintfmt+0xe6>

        case '.':
            if (width < 0)
  1031a1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1031a5:	79 86                	jns    10312d <vprintfmt+0x53>
                width = 0;
  1031a7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  1031ae:	e9 7a ff ff ff       	jmp    10312d <vprintfmt+0x53>

        case '#':
            altflag = 1;
  1031b3:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  1031ba:	e9 6e ff ff ff       	jmp    10312d <vprintfmt+0x53>
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
            goto process_precision;
  1031bf:	90                   	nop
        case '#':
            altflag = 1;
            goto reswitch;

        process_precision:
            if (width < 0)
  1031c0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1031c4:	0f 89 63 ff ff ff    	jns    10312d <vprintfmt+0x53>
                width = precision, precision = -1;
  1031ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1031cd:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1031d0:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  1031d7:	e9 51 ff ff ff       	jmp    10312d <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  1031dc:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  1031e0:	e9 48 ff ff ff       	jmp    10312d <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  1031e5:	8b 45 14             	mov    0x14(%ebp),%eax
  1031e8:	8d 50 04             	lea    0x4(%eax),%edx
  1031eb:	89 55 14             	mov    %edx,0x14(%ebp)
  1031ee:	8b 00                	mov    (%eax),%eax
  1031f0:	83 ec 08             	sub    $0x8,%esp
  1031f3:	ff 75 0c             	pushl  0xc(%ebp)
  1031f6:	50                   	push   %eax
  1031f7:	8b 45 08             	mov    0x8(%ebp),%eax
  1031fa:	ff d0                	call   *%eax
  1031fc:	83 c4 10             	add    $0x10,%esp
            break;
  1031ff:	e9 71 02 00 00       	jmp    103475 <vprintfmt+0x39b>

        // error message
        case 'e':
            err = va_arg(ap, int);
  103204:	8b 45 14             	mov    0x14(%ebp),%eax
  103207:	8d 50 04             	lea    0x4(%eax),%edx
  10320a:	89 55 14             	mov    %edx,0x14(%ebp)
  10320d:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  10320f:	85 db                	test   %ebx,%ebx
  103211:	79 02                	jns    103215 <vprintfmt+0x13b>
                err = -err;
  103213:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  103215:	83 fb 06             	cmp    $0x6,%ebx
  103218:	7f 0b                	jg     103225 <vprintfmt+0x14b>
  10321a:	8b 34 9d b4 3c 10 00 	mov    0x103cb4(,%ebx,4),%esi
  103221:	85 f6                	test   %esi,%esi
  103223:	75 19                	jne    10323e <vprintfmt+0x164>
                printfmt(putch, putdat, "error %d", err);
  103225:	53                   	push   %ebx
  103226:	68 e1 3c 10 00       	push   $0x103ce1
  10322b:	ff 75 0c             	pushl  0xc(%ebp)
  10322e:	ff 75 08             	pushl  0x8(%ebp)
  103231:	e8 80 fe ff ff       	call   1030b6 <printfmt>
  103236:	83 c4 10             	add    $0x10,%esp
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  103239:	e9 37 02 00 00       	jmp    103475 <vprintfmt+0x39b>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  10323e:	56                   	push   %esi
  10323f:	68 ea 3c 10 00       	push   $0x103cea
  103244:	ff 75 0c             	pushl  0xc(%ebp)
  103247:	ff 75 08             	pushl  0x8(%ebp)
  10324a:	e8 67 fe ff ff       	call   1030b6 <printfmt>
  10324f:	83 c4 10             	add    $0x10,%esp
            }
            break;
  103252:	e9 1e 02 00 00       	jmp    103475 <vprintfmt+0x39b>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  103257:	8b 45 14             	mov    0x14(%ebp),%eax
  10325a:	8d 50 04             	lea    0x4(%eax),%edx
  10325d:	89 55 14             	mov    %edx,0x14(%ebp)
  103260:	8b 30                	mov    (%eax),%esi
  103262:	85 f6                	test   %esi,%esi
  103264:	75 05                	jne    10326b <vprintfmt+0x191>
                p = "(null)";
  103266:	be ed 3c 10 00       	mov    $0x103ced,%esi
            }
            if (width > 0 && padc != '-') {
  10326b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10326f:	7e 76                	jle    1032e7 <vprintfmt+0x20d>
  103271:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  103275:	74 70                	je     1032e7 <vprintfmt+0x20d>
                for (width -= strnlen(p, precision); width > 0; width --) {
  103277:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10327a:	83 ec 08             	sub    $0x8,%esp
  10327d:	50                   	push   %eax
  10327e:	56                   	push   %esi
  10327f:	e8 17 f8 ff ff       	call   102a9b <strnlen>
  103284:	83 c4 10             	add    $0x10,%esp
  103287:	89 c2                	mov    %eax,%edx
  103289:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10328c:	29 d0                	sub    %edx,%eax
  10328e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103291:	eb 17                	jmp    1032aa <vprintfmt+0x1d0>
                    putch(padc, putdat);
  103293:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  103297:	83 ec 08             	sub    $0x8,%esp
  10329a:	ff 75 0c             	pushl  0xc(%ebp)
  10329d:	50                   	push   %eax
  10329e:	8b 45 08             	mov    0x8(%ebp),%eax
  1032a1:	ff d0                	call   *%eax
  1032a3:	83 c4 10             	add    $0x10,%esp
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  1032a6:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  1032aa:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1032ae:	7f e3                	jg     103293 <vprintfmt+0x1b9>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  1032b0:	eb 35                	jmp    1032e7 <vprintfmt+0x20d>
                if (altflag && (ch < ' ' || ch > '~')) {
  1032b2:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  1032b6:	74 1c                	je     1032d4 <vprintfmt+0x1fa>
  1032b8:	83 fb 1f             	cmp    $0x1f,%ebx
  1032bb:	7e 05                	jle    1032c2 <vprintfmt+0x1e8>
  1032bd:	83 fb 7e             	cmp    $0x7e,%ebx
  1032c0:	7e 12                	jle    1032d4 <vprintfmt+0x1fa>
                    putch('?', putdat);
  1032c2:	83 ec 08             	sub    $0x8,%esp
  1032c5:	ff 75 0c             	pushl  0xc(%ebp)
  1032c8:	6a 3f                	push   $0x3f
  1032ca:	8b 45 08             	mov    0x8(%ebp),%eax
  1032cd:	ff d0                	call   *%eax
  1032cf:	83 c4 10             	add    $0x10,%esp
  1032d2:	eb 0f                	jmp    1032e3 <vprintfmt+0x209>
                }
                else {
                    putch(ch, putdat);
  1032d4:	83 ec 08             	sub    $0x8,%esp
  1032d7:	ff 75 0c             	pushl  0xc(%ebp)
  1032da:	53                   	push   %ebx
  1032db:	8b 45 08             	mov    0x8(%ebp),%eax
  1032de:	ff d0                	call   *%eax
  1032e0:	83 c4 10             	add    $0x10,%esp
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  1032e3:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  1032e7:	89 f0                	mov    %esi,%eax
  1032e9:	8d 70 01             	lea    0x1(%eax),%esi
  1032ec:	0f b6 00             	movzbl (%eax),%eax
  1032ef:	0f be d8             	movsbl %al,%ebx
  1032f2:	85 db                	test   %ebx,%ebx
  1032f4:	74 26                	je     10331c <vprintfmt+0x242>
  1032f6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1032fa:	78 b6                	js     1032b2 <vprintfmt+0x1d8>
  1032fc:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  103300:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103304:	79 ac                	jns    1032b2 <vprintfmt+0x1d8>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  103306:	eb 14                	jmp    10331c <vprintfmt+0x242>
                putch(' ', putdat);
  103308:	83 ec 08             	sub    $0x8,%esp
  10330b:	ff 75 0c             	pushl  0xc(%ebp)
  10330e:	6a 20                	push   $0x20
  103310:	8b 45 08             	mov    0x8(%ebp),%eax
  103313:	ff d0                	call   *%eax
  103315:	83 c4 10             	add    $0x10,%esp
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  103318:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  10331c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103320:	7f e6                	jg     103308 <vprintfmt+0x22e>
                putch(' ', putdat);
            }
            break;
  103322:	e9 4e 01 00 00       	jmp    103475 <vprintfmt+0x39b>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  103327:	83 ec 08             	sub    $0x8,%esp
  10332a:	ff 75 e0             	pushl  -0x20(%ebp)
  10332d:	8d 45 14             	lea    0x14(%ebp),%eax
  103330:	50                   	push   %eax
  103331:	e8 39 fd ff ff       	call   10306f <getint>
  103336:	83 c4 10             	add    $0x10,%esp
  103339:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10333c:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  10333f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103342:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103345:	85 d2                	test   %edx,%edx
  103347:	79 23                	jns    10336c <vprintfmt+0x292>
                putch('-', putdat);
  103349:	83 ec 08             	sub    $0x8,%esp
  10334c:	ff 75 0c             	pushl  0xc(%ebp)
  10334f:	6a 2d                	push   $0x2d
  103351:	8b 45 08             	mov    0x8(%ebp),%eax
  103354:	ff d0                	call   *%eax
  103356:	83 c4 10             	add    $0x10,%esp
                num = -(long long)num;
  103359:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10335c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10335f:	f7 d8                	neg    %eax
  103361:	83 d2 00             	adc    $0x0,%edx
  103364:	f7 da                	neg    %edx
  103366:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103369:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  10336c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  103373:	e9 9f 00 00 00       	jmp    103417 <vprintfmt+0x33d>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  103378:	83 ec 08             	sub    $0x8,%esp
  10337b:	ff 75 e0             	pushl  -0x20(%ebp)
  10337e:	8d 45 14             	lea    0x14(%ebp),%eax
  103381:	50                   	push   %eax
  103382:	e8 99 fc ff ff       	call   103020 <getuint>
  103387:	83 c4 10             	add    $0x10,%esp
  10338a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10338d:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  103390:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  103397:	eb 7e                	jmp    103417 <vprintfmt+0x33d>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  103399:	83 ec 08             	sub    $0x8,%esp
  10339c:	ff 75 e0             	pushl  -0x20(%ebp)
  10339f:	8d 45 14             	lea    0x14(%ebp),%eax
  1033a2:	50                   	push   %eax
  1033a3:	e8 78 fc ff ff       	call   103020 <getuint>
  1033a8:	83 c4 10             	add    $0x10,%esp
  1033ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1033ae:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  1033b1:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  1033b8:	eb 5d                	jmp    103417 <vprintfmt+0x33d>

        // pointer
        case 'p':
            putch('0', putdat);
  1033ba:	83 ec 08             	sub    $0x8,%esp
  1033bd:	ff 75 0c             	pushl  0xc(%ebp)
  1033c0:	6a 30                	push   $0x30
  1033c2:	8b 45 08             	mov    0x8(%ebp),%eax
  1033c5:	ff d0                	call   *%eax
  1033c7:	83 c4 10             	add    $0x10,%esp
            putch('x', putdat);
  1033ca:	83 ec 08             	sub    $0x8,%esp
  1033cd:	ff 75 0c             	pushl  0xc(%ebp)
  1033d0:	6a 78                	push   $0x78
  1033d2:	8b 45 08             	mov    0x8(%ebp),%eax
  1033d5:	ff d0                	call   *%eax
  1033d7:	83 c4 10             	add    $0x10,%esp
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  1033da:	8b 45 14             	mov    0x14(%ebp),%eax
  1033dd:	8d 50 04             	lea    0x4(%eax),%edx
  1033e0:	89 55 14             	mov    %edx,0x14(%ebp)
  1033e3:	8b 00                	mov    (%eax),%eax
  1033e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1033e8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  1033ef:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  1033f6:	eb 1f                	jmp    103417 <vprintfmt+0x33d>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  1033f8:	83 ec 08             	sub    $0x8,%esp
  1033fb:	ff 75 e0             	pushl  -0x20(%ebp)
  1033fe:	8d 45 14             	lea    0x14(%ebp),%eax
  103401:	50                   	push   %eax
  103402:	e8 19 fc ff ff       	call   103020 <getuint>
  103407:	83 c4 10             	add    $0x10,%esp
  10340a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10340d:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  103410:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  103417:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  10341b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10341e:	83 ec 04             	sub    $0x4,%esp
  103421:	52                   	push   %edx
  103422:	ff 75 e8             	pushl  -0x18(%ebp)
  103425:	50                   	push   %eax
  103426:	ff 75 f4             	pushl  -0xc(%ebp)
  103429:	ff 75 f0             	pushl  -0x10(%ebp)
  10342c:	ff 75 0c             	pushl  0xc(%ebp)
  10342f:	ff 75 08             	pushl  0x8(%ebp)
  103432:	e8 f8 fa ff ff       	call   102f2f <printnum>
  103437:	83 c4 20             	add    $0x20,%esp
            break;
  10343a:	eb 39                	jmp    103475 <vprintfmt+0x39b>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  10343c:	83 ec 08             	sub    $0x8,%esp
  10343f:	ff 75 0c             	pushl  0xc(%ebp)
  103442:	53                   	push   %ebx
  103443:	8b 45 08             	mov    0x8(%ebp),%eax
  103446:	ff d0                	call   *%eax
  103448:	83 c4 10             	add    $0x10,%esp
            break;
  10344b:	eb 28                	jmp    103475 <vprintfmt+0x39b>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  10344d:	83 ec 08             	sub    $0x8,%esp
  103450:	ff 75 0c             	pushl  0xc(%ebp)
  103453:	6a 25                	push   $0x25
  103455:	8b 45 08             	mov    0x8(%ebp),%eax
  103458:	ff d0                	call   *%eax
  10345a:	83 c4 10             	add    $0x10,%esp
            for (fmt --; fmt[-1] != '%'; fmt --)
  10345d:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  103461:	eb 04                	jmp    103467 <vprintfmt+0x38d>
  103463:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  103467:	8b 45 10             	mov    0x10(%ebp),%eax
  10346a:	83 e8 01             	sub    $0x1,%eax
  10346d:	0f b6 00             	movzbl (%eax),%eax
  103470:	3c 25                	cmp    $0x25,%al
  103472:	75 ef                	jne    103463 <vprintfmt+0x389>
                /* do nothing */;
            break;
  103474:	90                   	nop
        }
    }
  103475:	e9 68 fc ff ff       	jmp    1030e2 <vprintfmt+0x8>
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
            if (ch == '\0') {
                return;
  10347a:	90                   	nop
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  10347b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  10347e:	5b                   	pop    %ebx
  10347f:	5e                   	pop    %esi
  103480:	5d                   	pop    %ebp
  103481:	c3                   	ret    

00103482 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  103482:	55                   	push   %ebp
  103483:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  103485:	8b 45 0c             	mov    0xc(%ebp),%eax
  103488:	8b 40 08             	mov    0x8(%eax),%eax
  10348b:	8d 50 01             	lea    0x1(%eax),%edx
  10348e:	8b 45 0c             	mov    0xc(%ebp),%eax
  103491:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  103494:	8b 45 0c             	mov    0xc(%ebp),%eax
  103497:	8b 10                	mov    (%eax),%edx
  103499:	8b 45 0c             	mov    0xc(%ebp),%eax
  10349c:	8b 40 04             	mov    0x4(%eax),%eax
  10349f:	39 c2                	cmp    %eax,%edx
  1034a1:	73 12                	jae    1034b5 <sprintputch+0x33>
        *b->buf ++ = ch;
  1034a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034a6:	8b 00                	mov    (%eax),%eax
  1034a8:	8d 48 01             	lea    0x1(%eax),%ecx
  1034ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  1034ae:	89 0a                	mov    %ecx,(%edx)
  1034b0:	8b 55 08             	mov    0x8(%ebp),%edx
  1034b3:	88 10                	mov    %dl,(%eax)
    }
}
  1034b5:	90                   	nop
  1034b6:	5d                   	pop    %ebp
  1034b7:	c3                   	ret    

001034b8 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  1034b8:	55                   	push   %ebp
  1034b9:	89 e5                	mov    %esp,%ebp
  1034bb:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  1034be:	8d 45 14             	lea    0x14(%ebp),%eax
  1034c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  1034c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1034c7:	50                   	push   %eax
  1034c8:	ff 75 10             	pushl  0x10(%ebp)
  1034cb:	ff 75 0c             	pushl  0xc(%ebp)
  1034ce:	ff 75 08             	pushl  0x8(%ebp)
  1034d1:	e8 0b 00 00 00       	call   1034e1 <vsnprintf>
  1034d6:	83 c4 10             	add    $0x10,%esp
  1034d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  1034dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1034df:	c9                   	leave  
  1034e0:	c3                   	ret    

001034e1 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  1034e1:	55                   	push   %ebp
  1034e2:	89 e5                	mov    %esp,%ebp
  1034e4:	83 ec 18             	sub    $0x18,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  1034e7:	8b 45 08             	mov    0x8(%ebp),%eax
  1034ea:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1034ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034f0:	8d 50 ff             	lea    -0x1(%eax),%edx
  1034f3:	8b 45 08             	mov    0x8(%ebp),%eax
  1034f6:	01 d0                	add    %edx,%eax
  1034f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1034fb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  103502:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103506:	74 0a                	je     103512 <vsnprintf+0x31>
  103508:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10350b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10350e:	39 c2                	cmp    %eax,%edx
  103510:	76 07                	jbe    103519 <vsnprintf+0x38>
        return -E_INVAL;
  103512:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  103517:	eb 20                	jmp    103539 <vsnprintf+0x58>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  103519:	ff 75 14             	pushl  0x14(%ebp)
  10351c:	ff 75 10             	pushl  0x10(%ebp)
  10351f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  103522:	50                   	push   %eax
  103523:	68 82 34 10 00       	push   $0x103482
  103528:	e8 ad fb ff ff       	call   1030da <vprintfmt>
  10352d:	83 c4 10             	add    $0x10,%esp
    // null terminate the buffer
    *b.buf = '\0';
  103530:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103533:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  103536:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103539:	c9                   	leave  
  10353a:	c3                   	ret    
