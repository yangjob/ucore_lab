
bin/kernel：     文件格式 elf32-i386


Disassembly of section .text:

00100000 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  100000:	55                   	push   %ebp
  100001:	89 e5                	mov    %esp,%ebp
  100003:	83 ec 18             	sub    $0x18,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100006:	ba 20 fd 10 00       	mov    $0x10fd20,%edx
  10000b:	b8 16 ea 10 00       	mov    $0x10ea16,%eax
  100010:	29 c2                	sub    %eax,%edx
  100012:	89 d0                	mov    %edx,%eax
  100014:	83 ec 04             	sub    $0x4,%esp
  100017:	50                   	push   %eax
  100018:	6a 00                	push   $0x0
  10001a:	68 16 ea 10 00       	push   $0x10ea16
  10001f:	e8 43 2c 00 00       	call   102c67 <memset>
  100024:	83 c4 10             	add    $0x10,%esp

    cons_init();                // init the console
  100027:	e8 0a 15 00 00       	call   101536 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  10002c:	c7 45 f4 00 34 10 00 	movl   $0x103400,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100033:	83 ec 08             	sub    $0x8,%esp
  100036:	ff 75 f4             	pushl  -0xc(%ebp)
  100039:	68 1c 34 10 00       	push   $0x10341c
  10003e:	e8 fa 01 00 00       	call   10023d <cprintf>
  100043:	83 c4 10             	add    $0x10,%esp

    print_kerninfo();
  100046:	e8 7c 08 00 00       	call   1008c7 <print_kerninfo>

    grade_backtrace();
  10004b:	e8 74 00 00 00       	call   1000c4 <grade_backtrace>

    pmm_init();                 // init physical memory management
  100050:	e8 d6 28 00 00       	call   10292b <pmm_init>

    pic_init();                 // init interrupt controller
  100055:	e8 1f 16 00 00       	call   101679 <pic_init>
    idt_init();                 // init interrupt descriptor table
  10005a:	e8 80 17 00 00       	call   1017df <idt_init>

    clock_init();               // init clock interrupt
  10005f:	e8 b7 0c 00 00       	call   100d1b <clock_init>
    intr_enable();              // enable irq interrupt
  100064:	e8 4d 17 00 00       	call   1017b6 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  100069:	eb fe                	jmp    100069 <kern_init+0x69>

0010006b <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  10006b:	55                   	push   %ebp
  10006c:	89 e5                	mov    %esp,%ebp
  10006e:	83 ec 08             	sub    $0x8,%esp
    mon_backtrace(0, NULL, NULL);
  100071:	83 ec 04             	sub    $0x4,%esp
  100074:	6a 00                	push   $0x0
  100076:	6a 00                	push   $0x0
  100078:	6a 00                	push   $0x0
  10007a:	e8 8a 0c 00 00       	call   100d09 <mon_backtrace>
  10007f:	83 c4 10             	add    $0x10,%esp
}
  100082:	90                   	nop
  100083:	c9                   	leave  
  100084:	c3                   	ret    

00100085 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  100085:	55                   	push   %ebp
  100086:	89 e5                	mov    %esp,%ebp
  100088:	53                   	push   %ebx
  100089:	83 ec 04             	sub    $0x4,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  10008c:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  10008f:	8b 55 0c             	mov    0xc(%ebp),%edx
  100092:	8d 5d 08             	lea    0x8(%ebp),%ebx
  100095:	8b 45 08             	mov    0x8(%ebp),%eax
  100098:	51                   	push   %ecx
  100099:	52                   	push   %edx
  10009a:	53                   	push   %ebx
  10009b:	50                   	push   %eax
  10009c:	e8 ca ff ff ff       	call   10006b <grade_backtrace2>
  1000a1:	83 c4 10             	add    $0x10,%esp
}
  1000a4:	90                   	nop
  1000a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1000a8:	c9                   	leave  
  1000a9:	c3                   	ret    

001000aa <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000aa:	55                   	push   %ebp
  1000ab:	89 e5                	mov    %esp,%ebp
  1000ad:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace1(arg0, arg2);
  1000b0:	83 ec 08             	sub    $0x8,%esp
  1000b3:	ff 75 10             	pushl  0x10(%ebp)
  1000b6:	ff 75 08             	pushl  0x8(%ebp)
  1000b9:	e8 c7 ff ff ff       	call   100085 <grade_backtrace1>
  1000be:	83 c4 10             	add    $0x10,%esp
}
  1000c1:	90                   	nop
  1000c2:	c9                   	leave  
  1000c3:	c3                   	ret    

001000c4 <grade_backtrace>:

void
grade_backtrace(void) {
  1000c4:	55                   	push   %ebp
  1000c5:	89 e5                	mov    %esp,%ebp
  1000c7:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  1000ca:	b8 00 00 10 00       	mov    $0x100000,%eax
  1000cf:	83 ec 04             	sub    $0x4,%esp
  1000d2:	68 00 00 ff ff       	push   $0xffff0000
  1000d7:	50                   	push   %eax
  1000d8:	6a 00                	push   $0x0
  1000da:	e8 cb ff ff ff       	call   1000aa <grade_backtrace0>
  1000df:	83 c4 10             	add    $0x10,%esp
}
  1000e2:	90                   	nop
  1000e3:	c9                   	leave  
  1000e4:	c3                   	ret    

001000e5 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  1000e5:	55                   	push   %ebp
  1000e6:	89 e5                	mov    %esp,%ebp
  1000e8:	83 ec 18             	sub    $0x18,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  1000eb:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  1000ee:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  1000f1:	8c 45 f2             	mov    %es,-0xe(%ebp)
  1000f4:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  1000f7:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  1000fb:	0f b7 c0             	movzwl %ax,%eax
  1000fe:	83 e0 03             	and    $0x3,%eax
  100101:	89 c2                	mov    %eax,%edx
  100103:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100108:	83 ec 04             	sub    $0x4,%esp
  10010b:	52                   	push   %edx
  10010c:	50                   	push   %eax
  10010d:	68 21 34 10 00       	push   $0x103421
  100112:	e8 26 01 00 00       	call   10023d <cprintf>
  100117:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  cs = %x\n", round, reg1);
  10011a:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10011e:	0f b7 d0             	movzwl %ax,%edx
  100121:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100126:	83 ec 04             	sub    $0x4,%esp
  100129:	52                   	push   %edx
  10012a:	50                   	push   %eax
  10012b:	68 2f 34 10 00       	push   $0x10342f
  100130:	e8 08 01 00 00       	call   10023d <cprintf>
  100135:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ds = %x\n", round, reg2);
  100138:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  10013c:	0f b7 d0             	movzwl %ax,%edx
  10013f:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100144:	83 ec 04             	sub    $0x4,%esp
  100147:	52                   	push   %edx
  100148:	50                   	push   %eax
  100149:	68 3d 34 10 00       	push   $0x10343d
  10014e:	e8 ea 00 00 00       	call   10023d <cprintf>
  100153:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  es = %x\n", round, reg3);
  100156:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  10015a:	0f b7 d0             	movzwl %ax,%edx
  10015d:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100162:	83 ec 04             	sub    $0x4,%esp
  100165:	52                   	push   %edx
  100166:	50                   	push   %eax
  100167:	68 4b 34 10 00       	push   $0x10344b
  10016c:	e8 cc 00 00 00       	call   10023d <cprintf>
  100171:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ss = %x\n", round, reg4);
  100174:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  100178:	0f b7 d0             	movzwl %ax,%edx
  10017b:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100180:	83 ec 04             	sub    $0x4,%esp
  100183:	52                   	push   %edx
  100184:	50                   	push   %eax
  100185:	68 59 34 10 00       	push   $0x103459
  10018a:	e8 ae 00 00 00       	call   10023d <cprintf>
  10018f:	83 c4 10             	add    $0x10,%esp
    round ++;
  100192:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100197:	83 c0 01             	add    $0x1,%eax
  10019a:	a3 20 ea 10 00       	mov    %eax,0x10ea20
}
  10019f:	90                   	nop
  1001a0:	c9                   	leave  
  1001a1:	c3                   	ret    

001001a2 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001a2:	55                   	push   %ebp
  1001a3:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
  1001a5:	90                   	nop
  1001a6:	5d                   	pop    %ebp
  1001a7:	c3                   	ret    

001001a8 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001a8:	55                   	push   %ebp
  1001a9:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
  1001ab:	90                   	nop
  1001ac:	5d                   	pop    %ebp
  1001ad:	c3                   	ret    

001001ae <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001ae:	55                   	push   %ebp
  1001af:	89 e5                	mov    %esp,%ebp
  1001b1:	83 ec 08             	sub    $0x8,%esp
    lab1_print_cur_status();
  1001b4:	e8 2c ff ff ff       	call   1000e5 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  1001b9:	83 ec 0c             	sub    $0xc,%esp
  1001bc:	68 68 34 10 00       	push   $0x103468
  1001c1:	e8 77 00 00 00       	call   10023d <cprintf>
  1001c6:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_user();
  1001c9:	e8 d4 ff ff ff       	call   1001a2 <lab1_switch_to_user>
    lab1_print_cur_status();
  1001ce:	e8 12 ff ff ff       	call   1000e5 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  1001d3:	83 ec 0c             	sub    $0xc,%esp
  1001d6:	68 88 34 10 00       	push   $0x103488
  1001db:	e8 5d 00 00 00       	call   10023d <cprintf>
  1001e0:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_kernel();
  1001e3:	e8 c0 ff ff ff       	call   1001a8 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  1001e8:	e8 f8 fe ff ff       	call   1000e5 <lab1_print_cur_status>
}
  1001ed:	90                   	nop
  1001ee:	c9                   	leave  
  1001ef:	c3                   	ret    

001001f0 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1001f0:	55                   	push   %ebp
  1001f1:	89 e5                	mov    %esp,%ebp
  1001f3:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
  1001f6:	83 ec 0c             	sub    $0xc,%esp
  1001f9:	ff 75 08             	pushl  0x8(%ebp)
  1001fc:	e8 66 13 00 00       	call   101567 <cons_putc>
  100201:	83 c4 10             	add    $0x10,%esp
    (*cnt) ++;
  100204:	8b 45 0c             	mov    0xc(%ebp),%eax
  100207:	8b 00                	mov    (%eax),%eax
  100209:	8d 50 01             	lea    0x1(%eax),%edx
  10020c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10020f:	89 10                	mov    %edx,(%eax)
}
  100211:	90                   	nop
  100212:	c9                   	leave  
  100213:	c3                   	ret    

00100214 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  100214:	55                   	push   %ebp
  100215:	89 e5                	mov    %esp,%ebp
  100217:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
  10021a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  100221:	ff 75 0c             	pushl  0xc(%ebp)
  100224:	ff 75 08             	pushl  0x8(%ebp)
  100227:	8d 45 f4             	lea    -0xc(%ebp),%eax
  10022a:	50                   	push   %eax
  10022b:	68 f0 01 10 00       	push   $0x1001f0
  100230:	e8 68 2d 00 00       	call   102f9d <vprintfmt>
  100235:	83 c4 10             	add    $0x10,%esp
    return cnt;
  100238:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10023b:	c9                   	leave  
  10023c:	c3                   	ret    

0010023d <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  10023d:	55                   	push   %ebp
  10023e:	89 e5                	mov    %esp,%ebp
  100240:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100243:	8d 45 0c             	lea    0xc(%ebp),%eax
  100246:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100249:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10024c:	83 ec 08             	sub    $0x8,%esp
  10024f:	50                   	push   %eax
  100250:	ff 75 08             	pushl  0x8(%ebp)
  100253:	e8 bc ff ff ff       	call   100214 <vcprintf>
  100258:	83 c4 10             	add    $0x10,%esp
  10025b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10025e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100261:	c9                   	leave  
  100262:	c3                   	ret    

00100263 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100263:	55                   	push   %ebp
  100264:	89 e5                	mov    %esp,%ebp
  100266:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
  100269:	83 ec 0c             	sub    $0xc,%esp
  10026c:	ff 75 08             	pushl  0x8(%ebp)
  10026f:	e8 f3 12 00 00       	call   101567 <cons_putc>
  100274:	83 c4 10             	add    $0x10,%esp
}
  100277:	90                   	nop
  100278:	c9                   	leave  
  100279:	c3                   	ret    

0010027a <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  10027a:	55                   	push   %ebp
  10027b:	89 e5                	mov    %esp,%ebp
  10027d:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
  100280:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  100287:	eb 14                	jmp    10029d <cputs+0x23>
        cputch(c, &cnt);
  100289:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  10028d:	83 ec 08             	sub    $0x8,%esp
  100290:	8d 55 f0             	lea    -0x10(%ebp),%edx
  100293:	52                   	push   %edx
  100294:	50                   	push   %eax
  100295:	e8 56 ff ff ff       	call   1001f0 <cputch>
  10029a:	83 c4 10             	add    $0x10,%esp
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  10029d:	8b 45 08             	mov    0x8(%ebp),%eax
  1002a0:	8d 50 01             	lea    0x1(%eax),%edx
  1002a3:	89 55 08             	mov    %edx,0x8(%ebp)
  1002a6:	0f b6 00             	movzbl (%eax),%eax
  1002a9:	88 45 f7             	mov    %al,-0x9(%ebp)
  1002ac:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1002b0:	75 d7                	jne    100289 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  1002b2:	83 ec 08             	sub    $0x8,%esp
  1002b5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1002b8:	50                   	push   %eax
  1002b9:	6a 0a                	push   $0xa
  1002bb:	e8 30 ff ff ff       	call   1001f0 <cputch>
  1002c0:	83 c4 10             	add    $0x10,%esp
    return cnt;
  1002c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1002c6:	c9                   	leave  
  1002c7:	c3                   	ret    

001002c8 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1002c8:	55                   	push   %ebp
  1002c9:	89 e5                	mov    %esp,%ebp
  1002cb:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1002ce:	e8 c4 12 00 00       	call   101597 <cons_getc>
  1002d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1002d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1002da:	74 f2                	je     1002ce <getchar+0x6>
        /* do nothing */;
    return c;
  1002dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1002df:	c9                   	leave  
  1002e0:	c3                   	ret    

001002e1 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  1002e1:	55                   	push   %ebp
  1002e2:	89 e5                	mov    %esp,%ebp
  1002e4:	83 ec 18             	sub    $0x18,%esp
    if (prompt != NULL) {
  1002e7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1002eb:	74 13                	je     100300 <readline+0x1f>
        cprintf("%s", prompt);
  1002ed:	83 ec 08             	sub    $0x8,%esp
  1002f0:	ff 75 08             	pushl  0x8(%ebp)
  1002f3:	68 a7 34 10 00       	push   $0x1034a7
  1002f8:	e8 40 ff ff ff       	call   10023d <cprintf>
  1002fd:	83 c4 10             	add    $0x10,%esp
    }
    int i = 0, c;
  100300:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100307:	e8 bc ff ff ff       	call   1002c8 <getchar>
  10030c:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  10030f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100313:	79 0a                	jns    10031f <readline+0x3e>
            return NULL;
  100315:	b8 00 00 00 00       	mov    $0x0,%eax
  10031a:	e9 82 00 00 00       	jmp    1003a1 <readline+0xc0>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  10031f:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100323:	7e 2b                	jle    100350 <readline+0x6f>
  100325:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  10032c:	7f 22                	jg     100350 <readline+0x6f>
            cputchar(c);
  10032e:	83 ec 0c             	sub    $0xc,%esp
  100331:	ff 75 f0             	pushl  -0x10(%ebp)
  100334:	e8 2a ff ff ff       	call   100263 <cputchar>
  100339:	83 c4 10             	add    $0x10,%esp
            buf[i ++] = c;
  10033c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10033f:	8d 50 01             	lea    0x1(%eax),%edx
  100342:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100345:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100348:	88 90 40 ea 10 00    	mov    %dl,0x10ea40(%eax)
  10034e:	eb 4c                	jmp    10039c <readline+0xbb>
        }
        else if (c == '\b' && i > 0) {
  100350:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  100354:	75 1a                	jne    100370 <readline+0x8f>
  100356:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10035a:	7e 14                	jle    100370 <readline+0x8f>
            cputchar(c);
  10035c:	83 ec 0c             	sub    $0xc,%esp
  10035f:	ff 75 f0             	pushl  -0x10(%ebp)
  100362:	e8 fc fe ff ff       	call   100263 <cputchar>
  100367:	83 c4 10             	add    $0x10,%esp
            i --;
  10036a:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  10036e:	eb 2c                	jmp    10039c <readline+0xbb>
        }
        else if (c == '\n' || c == '\r') {
  100370:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  100374:	74 06                	je     10037c <readline+0x9b>
  100376:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  10037a:	75 8b                	jne    100307 <readline+0x26>
            cputchar(c);
  10037c:	83 ec 0c             	sub    $0xc,%esp
  10037f:	ff 75 f0             	pushl  -0x10(%ebp)
  100382:	e8 dc fe ff ff       	call   100263 <cputchar>
  100387:	83 c4 10             	add    $0x10,%esp
            buf[i] = '\0';
  10038a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10038d:	05 40 ea 10 00       	add    $0x10ea40,%eax
  100392:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  100395:	b8 40 ea 10 00       	mov    $0x10ea40,%eax
  10039a:	eb 05                	jmp    1003a1 <readline+0xc0>
        }
    }
  10039c:	e9 66 ff ff ff       	jmp    100307 <readline+0x26>
}
  1003a1:	c9                   	leave  
  1003a2:	c3                   	ret    

001003a3 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  1003a3:	55                   	push   %ebp
  1003a4:	89 e5                	mov    %esp,%ebp
  1003a6:	83 ec 18             	sub    $0x18,%esp
    if (is_panic) {
  1003a9:	a1 40 ee 10 00       	mov    0x10ee40,%eax
  1003ae:	85 c0                	test   %eax,%eax
  1003b0:	75 4a                	jne    1003fc <__panic+0x59>
        goto panic_dead;
    }
    is_panic = 1;
  1003b2:	c7 05 40 ee 10 00 01 	movl   $0x1,0x10ee40
  1003b9:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  1003bc:	8d 45 14             	lea    0x14(%ebp),%eax
  1003bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  1003c2:	83 ec 04             	sub    $0x4,%esp
  1003c5:	ff 75 0c             	pushl  0xc(%ebp)
  1003c8:	ff 75 08             	pushl  0x8(%ebp)
  1003cb:	68 aa 34 10 00       	push   $0x1034aa
  1003d0:	e8 68 fe ff ff       	call   10023d <cprintf>
  1003d5:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
  1003d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003db:	83 ec 08             	sub    $0x8,%esp
  1003de:	50                   	push   %eax
  1003df:	ff 75 10             	pushl  0x10(%ebp)
  1003e2:	e8 2d fe ff ff       	call   100214 <vcprintf>
  1003e7:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
  1003ea:	83 ec 0c             	sub    $0xc,%esp
  1003ed:	68 c6 34 10 00       	push   $0x1034c6
  1003f2:	e8 46 fe ff ff       	call   10023d <cprintf>
  1003f7:	83 c4 10             	add    $0x10,%esp
  1003fa:	eb 01                	jmp    1003fd <__panic+0x5a>
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
        goto panic_dead;
  1003fc:	90                   	nop
    vcprintf(fmt, ap);
    cprintf("\n");
    va_end(ap);

panic_dead:
    intr_disable();
  1003fd:	e8 bb 13 00 00       	call   1017bd <intr_disable>
    while (1) {
        kmonitor(NULL);
  100402:	83 ec 0c             	sub    $0xc,%esp
  100405:	6a 00                	push   $0x0
  100407:	e8 23 08 00 00       	call   100c2f <kmonitor>
  10040c:	83 c4 10             	add    $0x10,%esp
    }
  10040f:	eb f1                	jmp    100402 <__panic+0x5f>

00100411 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100411:	55                   	push   %ebp
  100412:	89 e5                	mov    %esp,%ebp
  100414:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    va_start(ap, fmt);
  100417:	8d 45 14             	lea    0x14(%ebp),%eax
  10041a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  10041d:	83 ec 04             	sub    $0x4,%esp
  100420:	ff 75 0c             	pushl  0xc(%ebp)
  100423:	ff 75 08             	pushl  0x8(%ebp)
  100426:	68 c8 34 10 00       	push   $0x1034c8
  10042b:	e8 0d fe ff ff       	call   10023d <cprintf>
  100430:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
  100433:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100436:	83 ec 08             	sub    $0x8,%esp
  100439:	50                   	push   %eax
  10043a:	ff 75 10             	pushl  0x10(%ebp)
  10043d:	e8 d2 fd ff ff       	call   100214 <vcprintf>
  100442:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
  100445:	83 ec 0c             	sub    $0xc,%esp
  100448:	68 c6 34 10 00       	push   $0x1034c6
  10044d:	e8 eb fd ff ff       	call   10023d <cprintf>
  100452:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
  100455:	90                   	nop
  100456:	c9                   	leave  
  100457:	c3                   	ret    

00100458 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100458:	55                   	push   %ebp
  100459:	89 e5                	mov    %esp,%ebp
    return is_panic;
  10045b:	a1 40 ee 10 00       	mov    0x10ee40,%eax
}
  100460:	5d                   	pop    %ebp
  100461:	c3                   	ret    

00100462 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  100462:	55                   	push   %ebp
  100463:	89 e5                	mov    %esp,%ebp
  100465:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  100468:	8b 45 0c             	mov    0xc(%ebp),%eax
  10046b:	8b 00                	mov    (%eax),%eax
  10046d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100470:	8b 45 10             	mov    0x10(%ebp),%eax
  100473:	8b 00                	mov    (%eax),%eax
  100475:	89 45 f8             	mov    %eax,-0x8(%ebp)
  100478:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  10047f:	e9 d2 00 00 00       	jmp    100556 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  100484:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100487:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10048a:	01 d0                	add    %edx,%eax
  10048c:	89 c2                	mov    %eax,%edx
  10048e:	c1 ea 1f             	shr    $0x1f,%edx
  100491:	01 d0                	add    %edx,%eax
  100493:	d1 f8                	sar    %eax
  100495:	89 45 ec             	mov    %eax,-0x14(%ebp)
  100498:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10049b:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  10049e:	eb 04                	jmp    1004a4 <stab_binsearch+0x42>
            m --;
  1004a0:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1004a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004a7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004aa:	7c 1f                	jl     1004cb <stab_binsearch+0x69>
  1004ac:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004af:	89 d0                	mov    %edx,%eax
  1004b1:	01 c0                	add    %eax,%eax
  1004b3:	01 d0                	add    %edx,%eax
  1004b5:	c1 e0 02             	shl    $0x2,%eax
  1004b8:	89 c2                	mov    %eax,%edx
  1004ba:	8b 45 08             	mov    0x8(%ebp),%eax
  1004bd:	01 d0                	add    %edx,%eax
  1004bf:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1004c3:	0f b6 c0             	movzbl %al,%eax
  1004c6:	3b 45 14             	cmp    0x14(%ebp),%eax
  1004c9:	75 d5                	jne    1004a0 <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
  1004cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004ce:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004d1:	7d 0b                	jge    1004de <stab_binsearch+0x7c>
            l = true_m + 1;
  1004d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1004d6:	83 c0 01             	add    $0x1,%eax
  1004d9:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  1004dc:	eb 78                	jmp    100556 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  1004de:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  1004e5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004e8:	89 d0                	mov    %edx,%eax
  1004ea:	01 c0                	add    %eax,%eax
  1004ec:	01 d0                	add    %edx,%eax
  1004ee:	c1 e0 02             	shl    $0x2,%eax
  1004f1:	89 c2                	mov    %eax,%edx
  1004f3:	8b 45 08             	mov    0x8(%ebp),%eax
  1004f6:	01 d0                	add    %edx,%eax
  1004f8:	8b 40 08             	mov    0x8(%eax),%eax
  1004fb:	3b 45 18             	cmp    0x18(%ebp),%eax
  1004fe:	73 13                	jae    100513 <stab_binsearch+0xb1>
            *region_left = m;
  100500:	8b 45 0c             	mov    0xc(%ebp),%eax
  100503:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100506:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100508:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10050b:	83 c0 01             	add    $0x1,%eax
  10050e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100511:	eb 43                	jmp    100556 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  100513:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100516:	89 d0                	mov    %edx,%eax
  100518:	01 c0                	add    %eax,%eax
  10051a:	01 d0                	add    %edx,%eax
  10051c:	c1 e0 02             	shl    $0x2,%eax
  10051f:	89 c2                	mov    %eax,%edx
  100521:	8b 45 08             	mov    0x8(%ebp),%eax
  100524:	01 d0                	add    %edx,%eax
  100526:	8b 40 08             	mov    0x8(%eax),%eax
  100529:	3b 45 18             	cmp    0x18(%ebp),%eax
  10052c:	76 16                	jbe    100544 <stab_binsearch+0xe2>
            *region_right = m - 1;
  10052e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100531:	8d 50 ff             	lea    -0x1(%eax),%edx
  100534:	8b 45 10             	mov    0x10(%ebp),%eax
  100537:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  100539:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10053c:	83 e8 01             	sub    $0x1,%eax
  10053f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  100542:	eb 12                	jmp    100556 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  100544:	8b 45 0c             	mov    0xc(%ebp),%eax
  100547:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10054a:	89 10                	mov    %edx,(%eax)
            l = m;
  10054c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10054f:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  100552:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
  100556:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100559:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  10055c:	0f 8e 22 ff ff ff    	jle    100484 <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
  100562:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100566:	75 0f                	jne    100577 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  100568:	8b 45 0c             	mov    0xc(%ebp),%eax
  10056b:	8b 00                	mov    (%eax),%eax
  10056d:	8d 50 ff             	lea    -0x1(%eax),%edx
  100570:	8b 45 10             	mov    0x10(%ebp),%eax
  100573:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
  100575:	eb 3f                	jmp    1005b6 <stab_binsearch+0x154>
    if (!any_matches) {
        *region_right = *region_left - 1;
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  100577:	8b 45 10             	mov    0x10(%ebp),%eax
  10057a:	8b 00                	mov    (%eax),%eax
  10057c:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  10057f:	eb 04                	jmp    100585 <stab_binsearch+0x123>
  100581:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  100585:	8b 45 0c             	mov    0xc(%ebp),%eax
  100588:	8b 00                	mov    (%eax),%eax
  10058a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10058d:	7d 1f                	jge    1005ae <stab_binsearch+0x14c>
  10058f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100592:	89 d0                	mov    %edx,%eax
  100594:	01 c0                	add    %eax,%eax
  100596:	01 d0                	add    %edx,%eax
  100598:	c1 e0 02             	shl    $0x2,%eax
  10059b:	89 c2                	mov    %eax,%edx
  10059d:	8b 45 08             	mov    0x8(%ebp),%eax
  1005a0:	01 d0                	add    %edx,%eax
  1005a2:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1005a6:	0f b6 c0             	movzbl %al,%eax
  1005a9:	3b 45 14             	cmp    0x14(%ebp),%eax
  1005ac:	75 d3                	jne    100581 <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  1005ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005b1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005b4:	89 10                	mov    %edx,(%eax)
    }
}
  1005b6:	90                   	nop
  1005b7:	c9                   	leave  
  1005b8:	c3                   	ret    

001005b9 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  1005b9:	55                   	push   %ebp
  1005ba:	89 e5                	mov    %esp,%ebp
  1005bc:	83 ec 38             	sub    $0x38,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  1005bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005c2:	c7 00 e8 34 10 00    	movl   $0x1034e8,(%eax)
    info->eip_line = 0;
  1005c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005cb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  1005d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005d5:	c7 40 08 e8 34 10 00 	movl   $0x1034e8,0x8(%eax)
    info->eip_fn_namelen = 9;
  1005dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005df:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  1005e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005e9:	8b 55 08             	mov    0x8(%ebp),%edx
  1005ec:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  1005ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005f2:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  1005f9:	c7 45 f4 0c 3d 10 00 	movl   $0x103d0c,-0xc(%ebp)
    stab_end = __STAB_END__;
  100600:	c7 45 f0 44 b6 10 00 	movl   $0x10b644,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100607:	c7 45 ec 45 b6 10 00 	movl   $0x10b645,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  10060e:	c7 45 e8 79 d6 10 00 	movl   $0x10d679,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  100615:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100618:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  10061b:	76 0d                	jbe    10062a <debuginfo_eip+0x71>
  10061d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100620:	83 e8 01             	sub    $0x1,%eax
  100623:	0f b6 00             	movzbl (%eax),%eax
  100626:	84 c0                	test   %al,%al
  100628:	74 0a                	je     100634 <debuginfo_eip+0x7b>
        return -1;
  10062a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10062f:	e9 91 02 00 00       	jmp    1008c5 <debuginfo_eip+0x30c>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  100634:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  10063b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10063e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100641:	29 c2                	sub    %eax,%edx
  100643:	89 d0                	mov    %edx,%eax
  100645:	c1 f8 02             	sar    $0x2,%eax
  100648:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  10064e:	83 e8 01             	sub    $0x1,%eax
  100651:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  100654:	ff 75 08             	pushl  0x8(%ebp)
  100657:	6a 64                	push   $0x64
  100659:	8d 45 e0             	lea    -0x20(%ebp),%eax
  10065c:	50                   	push   %eax
  10065d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  100660:	50                   	push   %eax
  100661:	ff 75 f4             	pushl  -0xc(%ebp)
  100664:	e8 f9 fd ff ff       	call   100462 <stab_binsearch>
  100669:	83 c4 14             	add    $0x14,%esp
    if (lfile == 0)
  10066c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10066f:	85 c0                	test   %eax,%eax
  100671:	75 0a                	jne    10067d <debuginfo_eip+0xc4>
        return -1;
  100673:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100678:	e9 48 02 00 00       	jmp    1008c5 <debuginfo_eip+0x30c>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  10067d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100680:	89 45 dc             	mov    %eax,-0x24(%ebp)
  100683:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100686:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  100689:	ff 75 08             	pushl  0x8(%ebp)
  10068c:	6a 24                	push   $0x24
  10068e:	8d 45 d8             	lea    -0x28(%ebp),%eax
  100691:	50                   	push   %eax
  100692:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100695:	50                   	push   %eax
  100696:	ff 75 f4             	pushl  -0xc(%ebp)
  100699:	e8 c4 fd ff ff       	call   100462 <stab_binsearch>
  10069e:	83 c4 14             	add    $0x14,%esp

    if (lfun <= rfun) {
  1006a1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1006a4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006a7:	39 c2                	cmp    %eax,%edx
  1006a9:	7f 7c                	jg     100727 <debuginfo_eip+0x16e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  1006ab:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006ae:	89 c2                	mov    %eax,%edx
  1006b0:	89 d0                	mov    %edx,%eax
  1006b2:	01 c0                	add    %eax,%eax
  1006b4:	01 d0                	add    %edx,%eax
  1006b6:	c1 e0 02             	shl    $0x2,%eax
  1006b9:	89 c2                	mov    %eax,%edx
  1006bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006be:	01 d0                	add    %edx,%eax
  1006c0:	8b 00                	mov    (%eax),%eax
  1006c2:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1006c5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1006c8:	29 d1                	sub    %edx,%ecx
  1006ca:	89 ca                	mov    %ecx,%edx
  1006cc:	39 d0                	cmp    %edx,%eax
  1006ce:	73 22                	jae    1006f2 <debuginfo_eip+0x139>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  1006d0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006d3:	89 c2                	mov    %eax,%edx
  1006d5:	89 d0                	mov    %edx,%eax
  1006d7:	01 c0                	add    %eax,%eax
  1006d9:	01 d0                	add    %edx,%eax
  1006db:	c1 e0 02             	shl    $0x2,%eax
  1006de:	89 c2                	mov    %eax,%edx
  1006e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006e3:	01 d0                	add    %edx,%eax
  1006e5:	8b 10                	mov    (%eax),%edx
  1006e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1006ea:	01 c2                	add    %eax,%edx
  1006ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006ef:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  1006f2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006f5:	89 c2                	mov    %eax,%edx
  1006f7:	89 d0                	mov    %edx,%eax
  1006f9:	01 c0                	add    %eax,%eax
  1006fb:	01 d0                	add    %edx,%eax
  1006fd:	c1 e0 02             	shl    $0x2,%eax
  100700:	89 c2                	mov    %eax,%edx
  100702:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100705:	01 d0                	add    %edx,%eax
  100707:	8b 50 08             	mov    0x8(%eax),%edx
  10070a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10070d:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  100710:	8b 45 0c             	mov    0xc(%ebp),%eax
  100713:	8b 40 10             	mov    0x10(%eax),%eax
  100716:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  100719:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10071c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  10071f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100722:	89 45 d0             	mov    %eax,-0x30(%ebp)
  100725:	eb 15                	jmp    10073c <debuginfo_eip+0x183>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  100727:	8b 45 0c             	mov    0xc(%ebp),%eax
  10072a:	8b 55 08             	mov    0x8(%ebp),%edx
  10072d:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  100730:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100733:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  100736:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100739:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  10073c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10073f:	8b 40 08             	mov    0x8(%eax),%eax
  100742:	83 ec 08             	sub    $0x8,%esp
  100745:	6a 3a                	push   $0x3a
  100747:	50                   	push   %eax
  100748:	e8 8e 23 00 00       	call   102adb <strfind>
  10074d:	83 c4 10             	add    $0x10,%esp
  100750:	89 c2                	mov    %eax,%edx
  100752:	8b 45 0c             	mov    0xc(%ebp),%eax
  100755:	8b 40 08             	mov    0x8(%eax),%eax
  100758:	29 c2                	sub    %eax,%edx
  10075a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10075d:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  100760:	83 ec 0c             	sub    $0xc,%esp
  100763:	ff 75 08             	pushl  0x8(%ebp)
  100766:	6a 44                	push   $0x44
  100768:	8d 45 d0             	lea    -0x30(%ebp),%eax
  10076b:	50                   	push   %eax
  10076c:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  10076f:	50                   	push   %eax
  100770:	ff 75 f4             	pushl  -0xc(%ebp)
  100773:	e8 ea fc ff ff       	call   100462 <stab_binsearch>
  100778:	83 c4 20             	add    $0x20,%esp
    if (lline <= rline) {
  10077b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10077e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100781:	39 c2                	cmp    %eax,%edx
  100783:	7f 24                	jg     1007a9 <debuginfo_eip+0x1f0>
        info->eip_line = stabs[rline].n_desc;
  100785:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100788:	89 c2                	mov    %eax,%edx
  10078a:	89 d0                	mov    %edx,%eax
  10078c:	01 c0                	add    %eax,%eax
  10078e:	01 d0                	add    %edx,%eax
  100790:	c1 e0 02             	shl    $0x2,%eax
  100793:	89 c2                	mov    %eax,%edx
  100795:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100798:	01 d0                	add    %edx,%eax
  10079a:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  10079e:	0f b7 d0             	movzwl %ax,%edx
  1007a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007a4:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  1007a7:	eb 13                	jmp    1007bc <debuginfo_eip+0x203>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
  1007a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1007ae:	e9 12 01 00 00       	jmp    1008c5 <debuginfo_eip+0x30c>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  1007b3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007b6:	83 e8 01             	sub    $0x1,%eax
  1007b9:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  1007bc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007c2:	39 c2                	cmp    %eax,%edx
  1007c4:	7c 56                	jl     10081c <debuginfo_eip+0x263>
           && stabs[lline].n_type != N_SOL
  1007c6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007c9:	89 c2                	mov    %eax,%edx
  1007cb:	89 d0                	mov    %edx,%eax
  1007cd:	01 c0                	add    %eax,%eax
  1007cf:	01 d0                	add    %edx,%eax
  1007d1:	c1 e0 02             	shl    $0x2,%eax
  1007d4:	89 c2                	mov    %eax,%edx
  1007d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007d9:	01 d0                	add    %edx,%eax
  1007db:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1007df:	3c 84                	cmp    $0x84,%al
  1007e1:	74 39                	je     10081c <debuginfo_eip+0x263>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  1007e3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007e6:	89 c2                	mov    %eax,%edx
  1007e8:	89 d0                	mov    %edx,%eax
  1007ea:	01 c0                	add    %eax,%eax
  1007ec:	01 d0                	add    %edx,%eax
  1007ee:	c1 e0 02             	shl    $0x2,%eax
  1007f1:	89 c2                	mov    %eax,%edx
  1007f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007f6:	01 d0                	add    %edx,%eax
  1007f8:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1007fc:	3c 64                	cmp    $0x64,%al
  1007fe:	75 b3                	jne    1007b3 <debuginfo_eip+0x1fa>
  100800:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100803:	89 c2                	mov    %eax,%edx
  100805:	89 d0                	mov    %edx,%eax
  100807:	01 c0                	add    %eax,%eax
  100809:	01 d0                	add    %edx,%eax
  10080b:	c1 e0 02             	shl    $0x2,%eax
  10080e:	89 c2                	mov    %eax,%edx
  100810:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100813:	01 d0                	add    %edx,%eax
  100815:	8b 40 08             	mov    0x8(%eax),%eax
  100818:	85 c0                	test   %eax,%eax
  10081a:	74 97                	je     1007b3 <debuginfo_eip+0x1fa>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  10081c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10081f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100822:	39 c2                	cmp    %eax,%edx
  100824:	7c 46                	jl     10086c <debuginfo_eip+0x2b3>
  100826:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100829:	89 c2                	mov    %eax,%edx
  10082b:	89 d0                	mov    %edx,%eax
  10082d:	01 c0                	add    %eax,%eax
  10082f:	01 d0                	add    %edx,%eax
  100831:	c1 e0 02             	shl    $0x2,%eax
  100834:	89 c2                	mov    %eax,%edx
  100836:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100839:	01 d0                	add    %edx,%eax
  10083b:	8b 00                	mov    (%eax),%eax
  10083d:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  100840:	8b 55 ec             	mov    -0x14(%ebp),%edx
  100843:	29 d1                	sub    %edx,%ecx
  100845:	89 ca                	mov    %ecx,%edx
  100847:	39 d0                	cmp    %edx,%eax
  100849:	73 21                	jae    10086c <debuginfo_eip+0x2b3>
        info->eip_file = stabstr + stabs[lline].n_strx;
  10084b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10084e:	89 c2                	mov    %eax,%edx
  100850:	89 d0                	mov    %edx,%eax
  100852:	01 c0                	add    %eax,%eax
  100854:	01 d0                	add    %edx,%eax
  100856:	c1 e0 02             	shl    $0x2,%eax
  100859:	89 c2                	mov    %eax,%edx
  10085b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10085e:	01 d0                	add    %edx,%eax
  100860:	8b 10                	mov    (%eax),%edx
  100862:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100865:	01 c2                	add    %eax,%edx
  100867:	8b 45 0c             	mov    0xc(%ebp),%eax
  10086a:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  10086c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10086f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100872:	39 c2                	cmp    %eax,%edx
  100874:	7d 4a                	jge    1008c0 <debuginfo_eip+0x307>
        for (lline = lfun + 1;
  100876:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100879:	83 c0 01             	add    $0x1,%eax
  10087c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  10087f:	eb 18                	jmp    100899 <debuginfo_eip+0x2e0>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  100881:	8b 45 0c             	mov    0xc(%ebp),%eax
  100884:	8b 40 14             	mov    0x14(%eax),%eax
  100887:	8d 50 01             	lea    0x1(%eax),%edx
  10088a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10088d:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
  100890:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100893:	83 c0 01             	add    $0x1,%eax
  100896:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100899:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10089c:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
  10089f:	39 c2                	cmp    %eax,%edx
  1008a1:	7d 1d                	jge    1008c0 <debuginfo_eip+0x307>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  1008a3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008a6:	89 c2                	mov    %eax,%edx
  1008a8:	89 d0                	mov    %edx,%eax
  1008aa:	01 c0                	add    %eax,%eax
  1008ac:	01 d0                	add    %edx,%eax
  1008ae:	c1 e0 02             	shl    $0x2,%eax
  1008b1:	89 c2                	mov    %eax,%edx
  1008b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008b6:	01 d0                	add    %edx,%eax
  1008b8:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1008bc:	3c a0                	cmp    $0xa0,%al
  1008be:	74 c1                	je     100881 <debuginfo_eip+0x2c8>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
  1008c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1008c5:	c9                   	leave  
  1008c6:	c3                   	ret    

001008c7 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  1008c7:	55                   	push   %ebp
  1008c8:	89 e5                	mov    %esp,%ebp
  1008ca:	83 ec 08             	sub    $0x8,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  1008cd:	83 ec 0c             	sub    $0xc,%esp
  1008d0:	68 f2 34 10 00       	push   $0x1034f2
  1008d5:	e8 63 f9 ff ff       	call   10023d <cprintf>
  1008da:	83 c4 10             	add    $0x10,%esp
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  1008dd:	83 ec 08             	sub    $0x8,%esp
  1008e0:	68 00 00 10 00       	push   $0x100000
  1008e5:	68 0b 35 10 00       	push   $0x10350b
  1008ea:	e8 4e f9 ff ff       	call   10023d <cprintf>
  1008ef:	83 c4 10             	add    $0x10,%esp
    cprintf("  etext  0x%08x (phys)\n", etext);
  1008f2:	83 ec 08             	sub    $0x8,%esp
  1008f5:	68 fe 33 10 00       	push   $0x1033fe
  1008fa:	68 23 35 10 00       	push   $0x103523
  1008ff:	e8 39 f9 ff ff       	call   10023d <cprintf>
  100904:	83 c4 10             	add    $0x10,%esp
    cprintf("  edata  0x%08x (phys)\n", edata);
  100907:	83 ec 08             	sub    $0x8,%esp
  10090a:	68 16 ea 10 00       	push   $0x10ea16
  10090f:	68 3b 35 10 00       	push   $0x10353b
  100914:	e8 24 f9 ff ff       	call   10023d <cprintf>
  100919:	83 c4 10             	add    $0x10,%esp
    cprintf("  end    0x%08x (phys)\n", end);
  10091c:	83 ec 08             	sub    $0x8,%esp
  10091f:	68 20 fd 10 00       	push   $0x10fd20
  100924:	68 53 35 10 00       	push   $0x103553
  100929:	e8 0f f9 ff ff       	call   10023d <cprintf>
  10092e:	83 c4 10             	add    $0x10,%esp
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  100931:	b8 20 fd 10 00       	mov    $0x10fd20,%eax
  100936:	05 ff 03 00 00       	add    $0x3ff,%eax
  10093b:	ba 00 00 10 00       	mov    $0x100000,%edx
  100940:	29 d0                	sub    %edx,%eax
  100942:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  100948:	85 c0                	test   %eax,%eax
  10094a:	0f 48 c2             	cmovs  %edx,%eax
  10094d:	c1 f8 0a             	sar    $0xa,%eax
  100950:	83 ec 08             	sub    $0x8,%esp
  100953:	50                   	push   %eax
  100954:	68 6c 35 10 00       	push   $0x10356c
  100959:	e8 df f8 ff ff       	call   10023d <cprintf>
  10095e:	83 c4 10             	add    $0x10,%esp
}
  100961:	90                   	nop
  100962:	c9                   	leave  
  100963:	c3                   	ret    

00100964 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  100964:	55                   	push   %ebp
  100965:	89 e5                	mov    %esp,%ebp
  100967:	81 ec 28 01 00 00    	sub    $0x128,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  10096d:	83 ec 08             	sub    $0x8,%esp
  100970:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100973:	50                   	push   %eax
  100974:	ff 75 08             	pushl  0x8(%ebp)
  100977:	e8 3d fc ff ff       	call   1005b9 <debuginfo_eip>
  10097c:	83 c4 10             	add    $0x10,%esp
  10097f:	85 c0                	test   %eax,%eax
  100981:	74 15                	je     100998 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  100983:	83 ec 08             	sub    $0x8,%esp
  100986:	ff 75 08             	pushl  0x8(%ebp)
  100989:	68 96 35 10 00       	push   $0x103596
  10098e:	e8 aa f8 ff ff       	call   10023d <cprintf>
  100993:	83 c4 10             	add    $0x10,%esp
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
  100996:	eb 65                	jmp    1009fd <print_debuginfo+0x99>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100998:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  10099f:	eb 1c                	jmp    1009bd <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  1009a1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1009a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009a7:	01 d0                	add    %edx,%eax
  1009a9:	0f b6 00             	movzbl (%eax),%eax
  1009ac:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  1009b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1009b5:	01 ca                	add    %ecx,%edx
  1009b7:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  1009b9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1009bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1009c0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1009c3:	7f dc                	jg     1009a1 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
  1009c5:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  1009cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009ce:	01 d0                	add    %edx,%eax
  1009d0:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  1009d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  1009d6:	8b 55 08             	mov    0x8(%ebp),%edx
  1009d9:	89 d1                	mov    %edx,%ecx
  1009db:	29 c1                	sub    %eax,%ecx
  1009dd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1009e0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1009e3:	83 ec 0c             	sub    $0xc,%esp
  1009e6:	51                   	push   %ecx
  1009e7:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  1009ed:	51                   	push   %ecx
  1009ee:	52                   	push   %edx
  1009ef:	50                   	push   %eax
  1009f0:	68 b2 35 10 00       	push   $0x1035b2
  1009f5:	e8 43 f8 ff ff       	call   10023d <cprintf>
  1009fa:	83 c4 20             	add    $0x20,%esp
                fnname, eip - info.eip_fn_addr);
    }
}
  1009fd:	90                   	nop
  1009fe:	c9                   	leave  
  1009ff:	c3                   	ret    

00100a00 <read_eip>:

static __noinline uint32_t
read_eip(void) {
  100a00:	55                   	push   %ebp
  100a01:	89 e5                	mov    %esp,%ebp
  100a03:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100a06:	8b 45 04             	mov    0x4(%ebp),%eax
  100a09:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100a0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100a0f:	c9                   	leave  
  100a10:	c3                   	ret    

00100a11 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100a11:	55                   	push   %ebp
  100a12:	89 e5                	mov    %esp,%ebp
  100a14:	83 ec 28             	sub    $0x28,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100a17:	89 e8                	mov    %ebp,%eax
  100a19:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
  100a1c:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
      uint32_t ebp = read_ebp();
  100a1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
      uint32_t eip = read_eip();
  100a22:	e8 d9 ff ff ff       	call   100a00 <read_eip>
  100a27:	89 45 f0             	mov    %eax,-0x10(%ebp)
      int i, j;
      for(i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i++)
  100a2a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  100a31:	eb 7d                	jmp    100ab0 <print_stackframe+0x9f>
      {
              cprintf("ebp : 0x%08x, eip : 0x%08x  args:", ebp, eip);
  100a33:	83 ec 04             	sub    $0x4,%esp
  100a36:	ff 75 f0             	pushl  -0x10(%ebp)
  100a39:	ff 75 f4             	pushl  -0xc(%ebp)
  100a3c:	68 c4 35 10 00       	push   $0x1035c4
  100a41:	e8 f7 f7 ff ff       	call   10023d <cprintf>
  100a46:	83 c4 10             	add    $0x10,%esp
              uint32_t *args = (uint32_t *)ebp + 2;
  100a49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a4c:	83 c0 08             	add    $0x8,%eax
  100a4f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
              for(j = 0; j < 4; j++)
  100a52:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  100a59:	eb 26                	jmp    100a81 <print_stackframe+0x70>
                      cprintf("0x%08x ", args[j]);
  100a5b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a5e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100a65:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100a68:	01 d0                	add    %edx,%eax
  100a6a:	8b 00                	mov    (%eax),%eax
  100a6c:	83 ec 08             	sub    $0x8,%esp
  100a6f:	50                   	push   %eax
  100a70:	68 e6 35 10 00       	push   $0x1035e6
  100a75:	e8 c3 f7 ff ff       	call   10023d <cprintf>
  100a7a:	83 c4 10             	add    $0x10,%esp
      int i, j;
      for(i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i++)
      {
              cprintf("ebp : 0x%08x, eip : 0x%08x  args:", ebp, eip);
              uint32_t *args = (uint32_t *)ebp + 2;
              for(j = 0; j < 4; j++)
  100a7d:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  100a81:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100a85:	7e d4                	jle    100a5b <print_stackframe+0x4a>
                      cprintf("0x%08x ", args[j]);

              print_debuginfo(eip - 1);
  100a87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a8a:	83 e8 01             	sub    $0x1,%eax
  100a8d:	83 ec 0c             	sub    $0xc,%esp
  100a90:	50                   	push   %eax
  100a91:	e8 ce fe ff ff       	call   100964 <print_debuginfo>
  100a96:	83 c4 10             	add    $0x10,%esp
              eip = ((uint32_t *)ebp)[1];
  100a99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a9c:	83 c0 04             	add    $0x4,%eax
  100a9f:	8b 00                	mov    (%eax),%eax
  100aa1:	89 45 f0             	mov    %eax,-0x10(%ebp)
              ebp = ((uint32_t *)ebp)[0];
  100aa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100aa7:	8b 00                	mov    (%eax),%eax
  100aa9:	89 45 f4             	mov    %eax,-0xc(%ebp)
      *                   the calling funciton's ebp = ss:[ebp]
      */
      uint32_t ebp = read_ebp();
      uint32_t eip = read_eip();
      int i, j;
      for(i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i++)
  100aac:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100ab0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100ab4:	74 0a                	je     100ac0 <print_stackframe+0xaf>
  100ab6:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100aba:	0f 8e 73 ff ff ff    	jle    100a33 <print_stackframe+0x22>
              eip = ((uint32_t *)ebp)[1];
              ebp = ((uint32_t *)ebp)[0];

      }

}
  100ac0:	90                   	nop
  100ac1:	c9                   	leave  
  100ac2:	c3                   	ret    

00100ac3 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100ac3:	55                   	push   %ebp
  100ac4:	89 e5                	mov    %esp,%ebp
  100ac6:	83 ec 18             	sub    $0x18,%esp
    int argc = 0;
  100ac9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100ad0:	eb 0c                	jmp    100ade <parse+0x1b>
            *buf ++ = '\0';
  100ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  100ad5:	8d 50 01             	lea    0x1(%eax),%edx
  100ad8:	89 55 08             	mov    %edx,0x8(%ebp)
  100adb:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100ade:	8b 45 08             	mov    0x8(%ebp),%eax
  100ae1:	0f b6 00             	movzbl (%eax),%eax
  100ae4:	84 c0                	test   %al,%al
  100ae6:	74 1e                	je     100b06 <parse+0x43>
  100ae8:	8b 45 08             	mov    0x8(%ebp),%eax
  100aeb:	0f b6 00             	movzbl (%eax),%eax
  100aee:	0f be c0             	movsbl %al,%eax
  100af1:	83 ec 08             	sub    $0x8,%esp
  100af4:	50                   	push   %eax
  100af5:	68 70 36 10 00       	push   $0x103670
  100afa:	e8 a9 1f 00 00       	call   102aa8 <strchr>
  100aff:	83 c4 10             	add    $0x10,%esp
  100b02:	85 c0                	test   %eax,%eax
  100b04:	75 cc                	jne    100ad2 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100b06:	8b 45 08             	mov    0x8(%ebp),%eax
  100b09:	0f b6 00             	movzbl (%eax),%eax
  100b0c:	84 c0                	test   %al,%al
  100b0e:	74 69                	je     100b79 <parse+0xb6>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100b10:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100b14:	75 12                	jne    100b28 <parse+0x65>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100b16:	83 ec 08             	sub    $0x8,%esp
  100b19:	6a 10                	push   $0x10
  100b1b:	68 75 36 10 00       	push   $0x103675
  100b20:	e8 18 f7 ff ff       	call   10023d <cprintf>
  100b25:	83 c4 10             	add    $0x10,%esp
        }
        argv[argc ++] = buf;
  100b28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b2b:	8d 50 01             	lea    0x1(%eax),%edx
  100b2e:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100b31:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100b38:	8b 45 0c             	mov    0xc(%ebp),%eax
  100b3b:	01 c2                	add    %eax,%edx
  100b3d:	8b 45 08             	mov    0x8(%ebp),%eax
  100b40:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b42:	eb 04                	jmp    100b48 <parse+0x85>
            buf ++;
  100b44:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b48:	8b 45 08             	mov    0x8(%ebp),%eax
  100b4b:	0f b6 00             	movzbl (%eax),%eax
  100b4e:	84 c0                	test   %al,%al
  100b50:	0f 84 7a ff ff ff    	je     100ad0 <parse+0xd>
  100b56:	8b 45 08             	mov    0x8(%ebp),%eax
  100b59:	0f b6 00             	movzbl (%eax),%eax
  100b5c:	0f be c0             	movsbl %al,%eax
  100b5f:	83 ec 08             	sub    $0x8,%esp
  100b62:	50                   	push   %eax
  100b63:	68 70 36 10 00       	push   $0x103670
  100b68:	e8 3b 1f 00 00       	call   102aa8 <strchr>
  100b6d:	83 c4 10             	add    $0x10,%esp
  100b70:	85 c0                	test   %eax,%eax
  100b72:	74 d0                	je     100b44 <parse+0x81>
            buf ++;
        }
    }
  100b74:	e9 57 ff ff ff       	jmp    100ad0 <parse+0xd>
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
            break;
  100b79:	90                   	nop
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100b7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100b7d:	c9                   	leave  
  100b7e:	c3                   	ret    

00100b7f <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100b7f:	55                   	push   %ebp
  100b80:	89 e5                	mov    %esp,%ebp
  100b82:	83 ec 58             	sub    $0x58,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100b85:	83 ec 08             	sub    $0x8,%esp
  100b88:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b8b:	50                   	push   %eax
  100b8c:	ff 75 08             	pushl  0x8(%ebp)
  100b8f:	e8 2f ff ff ff       	call   100ac3 <parse>
  100b94:	83 c4 10             	add    $0x10,%esp
  100b97:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100b9a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100b9e:	75 0a                	jne    100baa <runcmd+0x2b>
        return 0;
  100ba0:	b8 00 00 00 00       	mov    $0x0,%eax
  100ba5:	e9 83 00 00 00       	jmp    100c2d <runcmd+0xae>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100baa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100bb1:	eb 59                	jmp    100c0c <runcmd+0x8d>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100bb3:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100bb6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100bb9:	89 d0                	mov    %edx,%eax
  100bbb:	01 c0                	add    %eax,%eax
  100bbd:	01 d0                	add    %edx,%eax
  100bbf:	c1 e0 02             	shl    $0x2,%eax
  100bc2:	05 00 e0 10 00       	add    $0x10e000,%eax
  100bc7:	8b 00                	mov    (%eax),%eax
  100bc9:	83 ec 08             	sub    $0x8,%esp
  100bcc:	51                   	push   %ecx
  100bcd:	50                   	push   %eax
  100bce:	e8 35 1e 00 00       	call   102a08 <strcmp>
  100bd3:	83 c4 10             	add    $0x10,%esp
  100bd6:	85 c0                	test   %eax,%eax
  100bd8:	75 2e                	jne    100c08 <runcmd+0x89>
            return commands[i].func(argc - 1, argv + 1, tf);
  100bda:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100bdd:	89 d0                	mov    %edx,%eax
  100bdf:	01 c0                	add    %eax,%eax
  100be1:	01 d0                	add    %edx,%eax
  100be3:	c1 e0 02             	shl    $0x2,%eax
  100be6:	05 08 e0 10 00       	add    $0x10e008,%eax
  100beb:	8b 10                	mov    (%eax),%edx
  100bed:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100bf0:	83 c0 04             	add    $0x4,%eax
  100bf3:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100bf6:	83 e9 01             	sub    $0x1,%ecx
  100bf9:	83 ec 04             	sub    $0x4,%esp
  100bfc:	ff 75 0c             	pushl  0xc(%ebp)
  100bff:	50                   	push   %eax
  100c00:	51                   	push   %ecx
  100c01:	ff d2                	call   *%edx
  100c03:	83 c4 10             	add    $0x10,%esp
  100c06:	eb 25                	jmp    100c2d <runcmd+0xae>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c08:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c0f:	83 f8 02             	cmp    $0x2,%eax
  100c12:	76 9f                	jbe    100bb3 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100c14:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100c17:	83 ec 08             	sub    $0x8,%esp
  100c1a:	50                   	push   %eax
  100c1b:	68 93 36 10 00       	push   $0x103693
  100c20:	e8 18 f6 ff ff       	call   10023d <cprintf>
  100c25:	83 c4 10             	add    $0x10,%esp
    return 0;
  100c28:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c2d:	c9                   	leave  
  100c2e:	c3                   	ret    

00100c2f <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100c2f:	55                   	push   %ebp
  100c30:	89 e5                	mov    %esp,%ebp
  100c32:	83 ec 18             	sub    $0x18,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100c35:	83 ec 0c             	sub    $0xc,%esp
  100c38:	68 ac 36 10 00       	push   $0x1036ac
  100c3d:	e8 fb f5 ff ff       	call   10023d <cprintf>
  100c42:	83 c4 10             	add    $0x10,%esp
    cprintf("Type 'help' for a list of commands.\n");
  100c45:	83 ec 0c             	sub    $0xc,%esp
  100c48:	68 d4 36 10 00       	push   $0x1036d4
  100c4d:	e8 eb f5 ff ff       	call   10023d <cprintf>
  100c52:	83 c4 10             	add    $0x10,%esp

    if (tf != NULL) {
  100c55:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100c59:	74 0e                	je     100c69 <kmonitor+0x3a>
        print_trapframe(tf);
  100c5b:	83 ec 0c             	sub    $0xc,%esp
  100c5e:	ff 75 08             	pushl  0x8(%ebp)
  100c61:	e8 32 0d 00 00       	call   101998 <print_trapframe>
  100c66:	83 c4 10             	add    $0x10,%esp
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100c69:	83 ec 0c             	sub    $0xc,%esp
  100c6c:	68 f9 36 10 00       	push   $0x1036f9
  100c71:	e8 6b f6 ff ff       	call   1002e1 <readline>
  100c76:	83 c4 10             	add    $0x10,%esp
  100c79:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100c7c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100c80:	74 e7                	je     100c69 <kmonitor+0x3a>
            if (runcmd(buf, tf) < 0) {
  100c82:	83 ec 08             	sub    $0x8,%esp
  100c85:	ff 75 08             	pushl  0x8(%ebp)
  100c88:	ff 75 f4             	pushl  -0xc(%ebp)
  100c8b:	e8 ef fe ff ff       	call   100b7f <runcmd>
  100c90:	83 c4 10             	add    $0x10,%esp
  100c93:	85 c0                	test   %eax,%eax
  100c95:	78 02                	js     100c99 <kmonitor+0x6a>
                break;
            }
        }
    }
  100c97:	eb d0                	jmp    100c69 <kmonitor+0x3a>

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
            if (runcmd(buf, tf) < 0) {
                break;
  100c99:	90                   	nop
            }
        }
    }
}
  100c9a:	90                   	nop
  100c9b:	c9                   	leave  
  100c9c:	c3                   	ret    

00100c9d <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100c9d:	55                   	push   %ebp
  100c9e:	89 e5                	mov    %esp,%ebp
  100ca0:	83 ec 18             	sub    $0x18,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100ca3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100caa:	eb 3c                	jmp    100ce8 <mon_help+0x4b>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100cac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100caf:	89 d0                	mov    %edx,%eax
  100cb1:	01 c0                	add    %eax,%eax
  100cb3:	01 d0                	add    %edx,%eax
  100cb5:	c1 e0 02             	shl    $0x2,%eax
  100cb8:	05 04 e0 10 00       	add    $0x10e004,%eax
  100cbd:	8b 08                	mov    (%eax),%ecx
  100cbf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100cc2:	89 d0                	mov    %edx,%eax
  100cc4:	01 c0                	add    %eax,%eax
  100cc6:	01 d0                	add    %edx,%eax
  100cc8:	c1 e0 02             	shl    $0x2,%eax
  100ccb:	05 00 e0 10 00       	add    $0x10e000,%eax
  100cd0:	8b 00                	mov    (%eax),%eax
  100cd2:	83 ec 04             	sub    $0x4,%esp
  100cd5:	51                   	push   %ecx
  100cd6:	50                   	push   %eax
  100cd7:	68 fd 36 10 00       	push   $0x1036fd
  100cdc:	e8 5c f5 ff ff       	call   10023d <cprintf>
  100ce1:	83 c4 10             	add    $0x10,%esp

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100ce4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100ce8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ceb:	83 f8 02             	cmp    $0x2,%eax
  100cee:	76 bc                	jbe    100cac <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100cf0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cf5:	c9                   	leave  
  100cf6:	c3                   	ret    

00100cf7 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100cf7:	55                   	push   %ebp
  100cf8:	89 e5                	mov    %esp,%ebp
  100cfa:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100cfd:	e8 c5 fb ff ff       	call   1008c7 <print_kerninfo>
    return 0;
  100d02:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d07:	c9                   	leave  
  100d08:	c3                   	ret    

00100d09 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100d09:	55                   	push   %ebp
  100d0a:	89 e5                	mov    %esp,%ebp
  100d0c:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100d0f:	e8 fd fc ff ff       	call   100a11 <print_stackframe>
    return 0;
  100d14:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d19:	c9                   	leave  
  100d1a:	c3                   	ret    

00100d1b <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d1b:	55                   	push   %ebp
  100d1c:	89 e5                	mov    %esp,%ebp
  100d1e:	83 ec 18             	sub    $0x18,%esp
  100d21:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100d27:	c6 45 ef 34          	movb   $0x34,-0x11(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100d2b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
  100d2f:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100d33:	ee                   	out    %al,(%dx)
  100d34:	66 c7 45 f4 40 00    	movw   $0x40,-0xc(%ebp)
  100d3a:	c6 45 f0 9c          	movb   $0x9c,-0x10(%ebp)
  100d3e:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
  100d42:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
  100d46:	ee                   	out    %al,(%dx)
  100d47:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100d4d:	c6 45 f1 2e          	movb   $0x2e,-0xf(%ebp)
  100d51:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100d55:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100d59:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100d5a:	c7 05 08 f9 10 00 00 	movl   $0x0,0x10f908
  100d61:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100d64:	83 ec 0c             	sub    $0xc,%esp
  100d67:	68 06 37 10 00       	push   $0x103706
  100d6c:	e8 cc f4 ff ff       	call   10023d <cprintf>
  100d71:	83 c4 10             	add    $0x10,%esp
    pic_enable(IRQ_TIMER);
  100d74:	83 ec 0c             	sub    $0xc,%esp
  100d77:	6a 00                	push   $0x0
  100d79:	e8 ce 08 00 00       	call   10164c <pic_enable>
  100d7e:	83 c4 10             	add    $0x10,%esp
}
  100d81:	90                   	nop
  100d82:	c9                   	leave  
  100d83:	c3                   	ret    

00100d84 <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100d84:	55                   	push   %ebp
  100d85:	89 e5                	mov    %esp,%ebp
  100d87:	83 ec 10             	sub    $0x10,%esp
  100d8a:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100d90:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100d94:	89 c2                	mov    %eax,%edx
  100d96:	ec                   	in     (%dx),%al
  100d97:	88 45 f4             	mov    %al,-0xc(%ebp)
  100d9a:	66 c7 45 fc 84 00    	movw   $0x84,-0x4(%ebp)
  100da0:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
  100da4:	89 c2                	mov    %eax,%edx
  100da6:	ec                   	in     (%dx),%al
  100da7:	88 45 f5             	mov    %al,-0xb(%ebp)
  100daa:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100db0:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100db4:	89 c2                	mov    %eax,%edx
  100db6:	ec                   	in     (%dx),%al
  100db7:	88 45 f6             	mov    %al,-0xa(%ebp)
  100dba:	66 c7 45 f8 84 00    	movw   $0x84,-0x8(%ebp)
  100dc0:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
  100dc4:	89 c2                	mov    %eax,%edx
  100dc6:	ec                   	in     (%dx),%al
  100dc7:	88 45 f7             	mov    %al,-0x9(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100dca:	90                   	nop
  100dcb:	c9                   	leave  
  100dcc:	c3                   	ret    

00100dcd <cga_init>:
//    -- 数据寄存器 映射 到 端口 0x3D5或0x3B5 
//    -- 索引寄存器 0x3D4或0x3B4,决定在数据寄存器中的数据表示什么。

/* TEXT-mode CGA/VGA display output */
static void
cga_init(void) {
  100dcd:	55                   	push   %ebp
  100dce:	89 e5                	mov    %esp,%ebp
  100dd0:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;   //CGA_BUF: 0xB8000 (彩色显示的显存物理基址)
  100dd3:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;                                            //保存当前显存0xB8000处的值
  100dda:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ddd:	0f b7 00             	movzwl (%eax),%eax
  100de0:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;                                   // 给这个地址随便写个值，看看能否再读出同样的值
  100de4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100de7:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {                                            // 如果读不出来，说明没有这块显存，即是单显配置
  100dec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100def:	0f b7 00             	movzwl (%eax),%eax
  100df2:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100df6:	74 12                	je     100e0a <cga_init+0x3d>
        cp = (uint16_t*)MONO_BUF;                         //设置为单显的显存基址 MONO_BUF： 0xB0000
  100df8:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;                           //设置为单显控制的IO地址，MONO_BASE: 0x3B4
  100dff:	66 c7 05 66 ee 10 00 	movw   $0x3b4,0x10ee66
  100e06:	b4 03 
  100e08:	eb 13                	jmp    100e1d <cga_init+0x50>
    } else {                                                                // 如果读出来了，有这块显存，即是彩显配置
        *cp = was;                                                      //还原原来显存位置的值
  100e0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e0d:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100e11:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;                               // 设置为彩显控制的IO地址，CGA_BASE: 0x3D4 
  100e14:	66 c7 05 66 ee 10 00 	movw   $0x3d4,0x10ee66
  100e1b:	d4 03 
    // Extract cursor location
    // 6845索引寄存器的index 0x0E（及十进制的14）== 光标位置(高位)
    // 6845索引寄存器的index 0x0F（及十进制的15）== 光标位置(低位)
    // 6845 reg 15 : Cursor Address (Low Byte)
    uint32_t pos;
    outb(addr_6845, 14);                                        
  100e1d:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e24:	0f b7 c0             	movzwl %ax,%eax
  100e27:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
  100e2b:	c6 45 ea 0e          	movb   $0xe,-0x16(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e2f:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
  100e33:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  100e37:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;                       //读出了光标位置(高位)
  100e38:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e3f:	83 c0 01             	add    $0x1,%eax
  100e42:	0f b7 c0             	movzwl %ax,%eax
  100e45:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100e49:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e4d:	89 c2                	mov    %eax,%edx
  100e4f:	ec                   	in     (%dx),%al
  100e50:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  100e53:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
  100e57:	0f b6 c0             	movzbl %al,%eax
  100e5a:	c1 e0 08             	shl    $0x8,%eax
  100e5d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100e60:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e67:	0f b7 c0             	movzwl %ax,%eax
  100e6a:	66 89 45 f0          	mov    %ax,-0x10(%ebp)
  100e6e:	c6 45 ec 0f          	movb   $0xf,-0x14(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e72:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
  100e76:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  100e7a:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);                             //读出了光标位置(低位)
  100e7b:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e82:	83 c0 01             	add    $0x1,%eax
  100e85:	0f b7 c0             	movzwl %ax,%eax
  100e88:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100e8c:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100e90:	89 c2                	mov    %eax,%edx
  100e92:	ec                   	in     (%dx),%al
  100e93:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100e96:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100e9a:	0f b6 c0             	movzbl %al,%eax
  100e9d:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;                                  //crt_buf是CGA显存起始地址
  100ea0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ea3:	a3 60 ee 10 00       	mov    %eax,0x10ee60
    crt_pos = pos;                                                  //crt_pos是CGA当前光标位置
  100ea8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100eab:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
}
  100eb1:	90                   	nop
  100eb2:	c9                   	leave  
  100eb3:	c3                   	ret    

00100eb4 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100eb4:	55                   	push   %ebp
  100eb5:	89 e5                	mov    %esp,%ebp
  100eb7:	83 ec 28             	sub    $0x28,%esp
  100eba:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100ec0:	c6 45 da 00          	movb   $0x0,-0x26(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100ec4:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
  100ec8:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100ecc:	ee                   	out    %al,(%dx)
  100ecd:	66 c7 45 f4 fb 03    	movw   $0x3fb,-0xc(%ebp)
  100ed3:	c6 45 db 80          	movb   $0x80,-0x25(%ebp)
  100ed7:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
  100edb:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
  100edf:	ee                   	out    %al,(%dx)
  100ee0:	66 c7 45 f2 f8 03    	movw   $0x3f8,-0xe(%ebp)
  100ee6:	c6 45 dc 0c          	movb   $0xc,-0x24(%ebp)
  100eea:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
  100eee:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100ef2:	ee                   	out    %al,(%dx)
  100ef3:	66 c7 45 f0 f9 03    	movw   $0x3f9,-0x10(%ebp)
  100ef9:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
  100efd:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100f01:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  100f05:	ee                   	out    %al,(%dx)
  100f06:	66 c7 45 ee fb 03    	movw   $0x3fb,-0x12(%ebp)
  100f0c:	c6 45 de 03          	movb   $0x3,-0x22(%ebp)
  100f10:	0f b6 45 de          	movzbl -0x22(%ebp),%eax
  100f14:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f18:	ee                   	out    %al,(%dx)
  100f19:	66 c7 45 ec fc 03    	movw   $0x3fc,-0x14(%ebp)
  100f1f:	c6 45 df 00          	movb   $0x0,-0x21(%ebp)
  100f23:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
  100f27:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
  100f2b:	ee                   	out    %al,(%dx)
  100f2c:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100f32:	c6 45 e0 01          	movb   $0x1,-0x20(%ebp)
  100f36:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
  100f3a:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f3e:	ee                   	out    %al,(%dx)
  100f3f:	66 c7 45 e8 fd 03    	movw   $0x3fd,-0x18(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f45:	0f b7 45 e8          	movzwl -0x18(%ebp),%eax
  100f49:	89 c2                	mov    %eax,%edx
  100f4b:	ec                   	in     (%dx),%al
  100f4c:	88 45 e1             	mov    %al,-0x1f(%ebp)
    return data;
  100f4f:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100f53:	3c ff                	cmp    $0xff,%al
  100f55:	0f 95 c0             	setne  %al
  100f58:	0f b6 c0             	movzbl %al,%eax
  100f5b:	a3 68 ee 10 00       	mov    %eax,0x10ee68
  100f60:	66 c7 45 e6 fa 03    	movw   $0x3fa,-0x1a(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f66:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100f6a:	89 c2                	mov    %eax,%edx
  100f6c:	ec                   	in     (%dx),%al
  100f6d:	88 45 e2             	mov    %al,-0x1e(%ebp)
  100f70:	66 c7 45 e4 f8 03    	movw   $0x3f8,-0x1c(%ebp)
  100f76:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
  100f7a:	89 c2                	mov    %eax,%edx
  100f7c:	ec                   	in     (%dx),%al
  100f7d:	88 45 e3             	mov    %al,-0x1d(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  100f80:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  100f85:	85 c0                	test   %eax,%eax
  100f87:	74 0d                	je     100f96 <serial_init+0xe2>
        pic_enable(IRQ_COM1);
  100f89:	83 ec 0c             	sub    $0xc,%esp
  100f8c:	6a 04                	push   $0x4
  100f8e:	e8 b9 06 00 00       	call   10164c <pic_enable>
  100f93:	83 c4 10             	add    $0x10,%esp
    }
}
  100f96:	90                   	nop
  100f97:	c9                   	leave  
  100f98:	c3                   	ret    

00100f99 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  100f99:	55                   	push   %ebp
  100f9a:	89 e5                	mov    %esp,%ebp
  100f9c:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100f9f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100fa6:	eb 09                	jmp    100fb1 <lpt_putc_sub+0x18>
        delay();
  100fa8:	e8 d7 fd ff ff       	call   100d84 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100fad:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  100fb1:	66 c7 45 f4 79 03    	movw   $0x379,-0xc(%ebp)
  100fb7:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100fbb:	89 c2                	mov    %eax,%edx
  100fbd:	ec                   	in     (%dx),%al
  100fbe:	88 45 f3             	mov    %al,-0xd(%ebp)
    return data;
  100fc1:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  100fc5:	84 c0                	test   %al,%al
  100fc7:	78 09                	js     100fd2 <lpt_putc_sub+0x39>
  100fc9:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  100fd0:	7e d6                	jle    100fa8 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  100fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  100fd5:	0f b6 c0             	movzbl %al,%eax
  100fd8:	66 c7 45 f8 78 03    	movw   $0x378,-0x8(%ebp)
  100fde:	88 45 f0             	mov    %al,-0x10(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100fe1:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
  100fe5:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  100fe9:	ee                   	out    %al,(%dx)
  100fea:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  100ff0:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  100ff4:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100ff8:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100ffc:	ee                   	out    %al,(%dx)
  100ffd:	66 c7 45 fa 7a 03    	movw   $0x37a,-0x6(%ebp)
  101003:	c6 45 f2 08          	movb   $0x8,-0xe(%ebp)
  101007:	0f b6 45 f2          	movzbl -0xe(%ebp),%eax
  10100b:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10100f:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  101010:	90                   	nop
  101011:	c9                   	leave  
  101012:	c3                   	ret    

00101013 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  101013:	55                   	push   %ebp
  101014:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
  101016:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  10101a:	74 0d                	je     101029 <lpt_putc+0x16>
        lpt_putc_sub(c);
  10101c:	ff 75 08             	pushl  0x8(%ebp)
  10101f:	e8 75 ff ff ff       	call   100f99 <lpt_putc_sub>
  101024:	83 c4 04             	add    $0x4,%esp
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  101027:	eb 1e                	jmp    101047 <lpt_putc+0x34>
lpt_putc(int c) {
    if (c != '\b') {
        lpt_putc_sub(c);
    }
    else {
        lpt_putc_sub('\b');
  101029:	6a 08                	push   $0x8
  10102b:	e8 69 ff ff ff       	call   100f99 <lpt_putc_sub>
  101030:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub(' ');
  101033:	6a 20                	push   $0x20
  101035:	e8 5f ff ff ff       	call   100f99 <lpt_putc_sub>
  10103a:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub('\b');
  10103d:	6a 08                	push   $0x8
  10103f:	e8 55 ff ff ff       	call   100f99 <lpt_putc_sub>
  101044:	83 c4 04             	add    $0x4,%esp
    }
}
  101047:	90                   	nop
  101048:	c9                   	leave  
  101049:	c3                   	ret    

0010104a <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  10104a:	55                   	push   %ebp
  10104b:	89 e5                	mov    %esp,%ebp
  10104d:	53                   	push   %ebx
  10104e:	83 ec 14             	sub    $0x14,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  101051:	8b 45 08             	mov    0x8(%ebp),%eax
  101054:	b0 00                	mov    $0x0,%al
  101056:	85 c0                	test   %eax,%eax
  101058:	75 07                	jne    101061 <cga_putc+0x17>
        c |= 0x0700;
  10105a:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  101061:	8b 45 08             	mov    0x8(%ebp),%eax
  101064:	0f b6 c0             	movzbl %al,%eax
  101067:	83 f8 0a             	cmp    $0xa,%eax
  10106a:	74 4e                	je     1010ba <cga_putc+0x70>
  10106c:	83 f8 0d             	cmp    $0xd,%eax
  10106f:	74 59                	je     1010ca <cga_putc+0x80>
  101071:	83 f8 08             	cmp    $0x8,%eax
  101074:	0f 85 8a 00 00 00    	jne    101104 <cga_putc+0xba>
    case '\b':
        if (crt_pos > 0) {
  10107a:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101081:	66 85 c0             	test   %ax,%ax
  101084:	0f 84 a0 00 00 00    	je     10112a <cga_putc+0xe0>
            crt_pos --;
  10108a:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101091:	83 e8 01             	sub    $0x1,%eax
  101094:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  10109a:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  10109f:	0f b7 15 64 ee 10 00 	movzwl 0x10ee64,%edx
  1010a6:	0f b7 d2             	movzwl %dx,%edx
  1010a9:	01 d2                	add    %edx,%edx
  1010ab:	01 d0                	add    %edx,%eax
  1010ad:	8b 55 08             	mov    0x8(%ebp),%edx
  1010b0:	b2 00                	mov    $0x0,%dl
  1010b2:	83 ca 20             	or     $0x20,%edx
  1010b5:	66 89 10             	mov    %dx,(%eax)
        }
        break;
  1010b8:	eb 70                	jmp    10112a <cga_putc+0xe0>
    case '\n':
        crt_pos += CRT_COLS;
  1010ba:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010c1:	83 c0 50             	add    $0x50,%eax
  1010c4:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  1010ca:	0f b7 1d 64 ee 10 00 	movzwl 0x10ee64,%ebx
  1010d1:	0f b7 0d 64 ee 10 00 	movzwl 0x10ee64,%ecx
  1010d8:	0f b7 c1             	movzwl %cx,%eax
  1010db:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  1010e1:	c1 e8 10             	shr    $0x10,%eax
  1010e4:	89 c2                	mov    %eax,%edx
  1010e6:	66 c1 ea 06          	shr    $0x6,%dx
  1010ea:	89 d0                	mov    %edx,%eax
  1010ec:	c1 e0 02             	shl    $0x2,%eax
  1010ef:	01 d0                	add    %edx,%eax
  1010f1:	c1 e0 04             	shl    $0x4,%eax
  1010f4:	29 c1                	sub    %eax,%ecx
  1010f6:	89 ca                	mov    %ecx,%edx
  1010f8:	89 d8                	mov    %ebx,%eax
  1010fa:	29 d0                	sub    %edx,%eax
  1010fc:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
        break;
  101102:	eb 27                	jmp    10112b <cga_putc+0xe1>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  101104:	8b 0d 60 ee 10 00    	mov    0x10ee60,%ecx
  10110a:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101111:	8d 50 01             	lea    0x1(%eax),%edx
  101114:	66 89 15 64 ee 10 00 	mov    %dx,0x10ee64
  10111b:	0f b7 c0             	movzwl %ax,%eax
  10111e:	01 c0                	add    %eax,%eax
  101120:	01 c8                	add    %ecx,%eax
  101122:	8b 55 08             	mov    0x8(%ebp),%edx
  101125:	66 89 10             	mov    %dx,(%eax)
        break;
  101128:	eb 01                	jmp    10112b <cga_putc+0xe1>
    case '\b':
        if (crt_pos > 0) {
            crt_pos --;
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
        }
        break;
  10112a:	90                   	nop
        crt_buf[crt_pos ++] = c;     // write the character
        break;
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  10112b:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101132:	66 3d cf 07          	cmp    $0x7cf,%ax
  101136:	76 59                	jbe    101191 <cga_putc+0x147>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  101138:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  10113d:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  101143:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  101148:	83 ec 04             	sub    $0x4,%esp
  10114b:	68 00 0f 00 00       	push   $0xf00
  101150:	52                   	push   %edx
  101151:	50                   	push   %eax
  101152:	e8 50 1b 00 00       	call   102ca7 <memmove>
  101157:	83 c4 10             	add    $0x10,%esp
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  10115a:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  101161:	eb 15                	jmp    101178 <cga_putc+0x12e>
            crt_buf[i] = 0x0700 | ' ';
  101163:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  101168:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10116b:	01 d2                	add    %edx,%edx
  10116d:	01 d0                	add    %edx,%eax
  10116f:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101174:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101178:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  10117f:	7e e2                	jle    101163 <cga_putc+0x119>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  101181:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101188:	83 e8 50             	sub    $0x50,%eax
  10118b:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  101191:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  101198:	0f b7 c0             	movzwl %ax,%eax
  10119b:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  10119f:	c6 45 e8 0e          	movb   $0xe,-0x18(%ebp)
  1011a3:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
  1011a7:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1011ab:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  1011ac:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011b3:	66 c1 e8 08          	shr    $0x8,%ax
  1011b7:	0f b6 c0             	movzbl %al,%eax
  1011ba:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  1011c1:	83 c2 01             	add    $0x1,%edx
  1011c4:	0f b7 d2             	movzwl %dx,%edx
  1011c7:	66 89 55 f0          	mov    %dx,-0x10(%ebp)
  1011cb:	88 45 e9             	mov    %al,-0x17(%ebp)
  1011ce:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1011d2:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  1011d6:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  1011d7:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  1011de:	0f b7 c0             	movzwl %ax,%eax
  1011e1:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  1011e5:	c6 45 ea 0f          	movb   $0xf,-0x16(%ebp)
  1011e9:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
  1011ed:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1011f1:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  1011f2:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011f9:	0f b6 c0             	movzbl %al,%eax
  1011fc:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  101203:	83 c2 01             	add    $0x1,%edx
  101206:	0f b7 d2             	movzwl %dx,%edx
  101209:	66 89 55 ec          	mov    %dx,-0x14(%ebp)
  10120d:	88 45 eb             	mov    %al,-0x15(%ebp)
  101210:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
  101214:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
  101218:	ee                   	out    %al,(%dx)
}
  101219:	90                   	nop
  10121a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  10121d:	c9                   	leave  
  10121e:	c3                   	ret    

0010121f <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  10121f:	55                   	push   %ebp
  101220:	89 e5                	mov    %esp,%ebp
  101222:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101225:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10122c:	eb 09                	jmp    101237 <serial_putc_sub+0x18>
        delay();
  10122e:	e8 51 fb ff ff       	call   100d84 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101233:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101237:	66 c7 45 f8 fd 03    	movw   $0x3fd,-0x8(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10123d:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
  101241:	89 c2                	mov    %eax,%edx
  101243:	ec                   	in     (%dx),%al
  101244:	88 45 f7             	mov    %al,-0x9(%ebp)
    return data;
  101247:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  10124b:	0f b6 c0             	movzbl %al,%eax
  10124e:	83 e0 20             	and    $0x20,%eax
  101251:	85 c0                	test   %eax,%eax
  101253:	75 09                	jne    10125e <serial_putc_sub+0x3f>
  101255:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  10125c:	7e d0                	jle    10122e <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  10125e:	8b 45 08             	mov    0x8(%ebp),%eax
  101261:	0f b6 c0             	movzbl %al,%eax
  101264:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
  10126a:	88 45 f6             	mov    %al,-0xa(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10126d:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
  101271:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101275:	ee                   	out    %al,(%dx)
}
  101276:	90                   	nop
  101277:	c9                   	leave  
  101278:	c3                   	ret    

00101279 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  101279:	55                   	push   %ebp
  10127a:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
  10127c:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101280:	74 0d                	je     10128f <serial_putc+0x16>
        serial_putc_sub(c);
  101282:	ff 75 08             	pushl  0x8(%ebp)
  101285:	e8 95 ff ff ff       	call   10121f <serial_putc_sub>
  10128a:	83 c4 04             	add    $0x4,%esp
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  10128d:	eb 1e                	jmp    1012ad <serial_putc+0x34>
serial_putc(int c) {
    if (c != '\b') {
        serial_putc_sub(c);
    }
    else {
        serial_putc_sub('\b');
  10128f:	6a 08                	push   $0x8
  101291:	e8 89 ff ff ff       	call   10121f <serial_putc_sub>
  101296:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub(' ');
  101299:	6a 20                	push   $0x20
  10129b:	e8 7f ff ff ff       	call   10121f <serial_putc_sub>
  1012a0:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub('\b');
  1012a3:	6a 08                	push   $0x8
  1012a5:	e8 75 ff ff ff       	call   10121f <serial_putc_sub>
  1012aa:	83 c4 04             	add    $0x4,%esp
    }
}
  1012ad:	90                   	nop
  1012ae:	c9                   	leave  
  1012af:	c3                   	ret    

001012b0 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  1012b0:	55                   	push   %ebp
  1012b1:	89 e5                	mov    %esp,%ebp
  1012b3:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  1012b6:	eb 33                	jmp    1012eb <cons_intr+0x3b>
        if (c != 0) {
  1012b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1012bc:	74 2d                	je     1012eb <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  1012be:	a1 84 f0 10 00       	mov    0x10f084,%eax
  1012c3:	8d 50 01             	lea    0x1(%eax),%edx
  1012c6:	89 15 84 f0 10 00    	mov    %edx,0x10f084
  1012cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1012cf:	88 90 80 ee 10 00    	mov    %dl,0x10ee80(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  1012d5:	a1 84 f0 10 00       	mov    0x10f084,%eax
  1012da:	3d 00 02 00 00       	cmp    $0x200,%eax
  1012df:	75 0a                	jne    1012eb <cons_intr+0x3b>
                cons.wpos = 0;
  1012e1:	c7 05 84 f0 10 00 00 	movl   $0x0,0x10f084
  1012e8:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  1012eb:	8b 45 08             	mov    0x8(%ebp),%eax
  1012ee:	ff d0                	call   *%eax
  1012f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1012f3:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  1012f7:	75 bf                	jne    1012b8 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  1012f9:	90                   	nop
  1012fa:	c9                   	leave  
  1012fb:	c3                   	ret    

001012fc <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  1012fc:	55                   	push   %ebp
  1012fd:	89 e5                	mov    %esp,%ebp
  1012ff:	83 ec 10             	sub    $0x10,%esp
  101302:	66 c7 45 f8 fd 03    	movw   $0x3fd,-0x8(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101308:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
  10130c:	89 c2                	mov    %eax,%edx
  10130e:	ec                   	in     (%dx),%al
  10130f:	88 45 f7             	mov    %al,-0x9(%ebp)
    return data;
  101312:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  101316:	0f b6 c0             	movzbl %al,%eax
  101319:	83 e0 01             	and    $0x1,%eax
  10131c:	85 c0                	test   %eax,%eax
  10131e:	75 07                	jne    101327 <serial_proc_data+0x2b>
        return -1;
  101320:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101325:	eb 2a                	jmp    101351 <serial_proc_data+0x55>
  101327:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10132d:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101331:	89 c2                	mov    %eax,%edx
  101333:	ec                   	in     (%dx),%al
  101334:	88 45 f6             	mov    %al,-0xa(%ebp)
    return data;
  101337:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  10133b:	0f b6 c0             	movzbl %al,%eax
  10133e:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  101341:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  101345:	75 07                	jne    10134e <serial_proc_data+0x52>
        c = '\b';
  101347:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  10134e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  101351:	c9                   	leave  
  101352:	c3                   	ret    

00101353 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  101353:	55                   	push   %ebp
  101354:	89 e5                	mov    %esp,%ebp
  101356:	83 ec 08             	sub    $0x8,%esp
    if (serial_exists) {
  101359:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  10135e:	85 c0                	test   %eax,%eax
  101360:	74 10                	je     101372 <serial_intr+0x1f>
        cons_intr(serial_proc_data);
  101362:	83 ec 0c             	sub    $0xc,%esp
  101365:	68 fc 12 10 00       	push   $0x1012fc
  10136a:	e8 41 ff ff ff       	call   1012b0 <cons_intr>
  10136f:	83 c4 10             	add    $0x10,%esp
    }
}
  101372:	90                   	nop
  101373:	c9                   	leave  
  101374:	c3                   	ret    

00101375 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  101375:	55                   	push   %ebp
  101376:	89 e5                	mov    %esp,%ebp
  101378:	83 ec 18             	sub    $0x18,%esp
  10137b:	66 c7 45 ec 64 00    	movw   $0x64,-0x14(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101381:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101385:	89 c2                	mov    %eax,%edx
  101387:	ec                   	in     (%dx),%al
  101388:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  10138b:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  10138f:	0f b6 c0             	movzbl %al,%eax
  101392:	83 e0 01             	and    $0x1,%eax
  101395:	85 c0                	test   %eax,%eax
  101397:	75 0a                	jne    1013a3 <kbd_proc_data+0x2e>
        return -1;
  101399:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10139e:	e9 5d 01 00 00       	jmp    101500 <kbd_proc_data+0x18b>
  1013a3:	66 c7 45 f0 60 00    	movw   $0x60,-0x10(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013a9:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1013ad:	89 c2                	mov    %eax,%edx
  1013af:	ec                   	in     (%dx),%al
  1013b0:	88 45 ea             	mov    %al,-0x16(%ebp)
    return data;
  1013b3:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
    }

    data = inb(KBDATAP);
  1013b7:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  1013ba:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  1013be:	75 17                	jne    1013d7 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  1013c0:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1013c5:	83 c8 40             	or     $0x40,%eax
  1013c8:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  1013cd:	b8 00 00 00 00       	mov    $0x0,%eax
  1013d2:	e9 29 01 00 00       	jmp    101500 <kbd_proc_data+0x18b>
    } else if (data & 0x80) {
  1013d7:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1013db:	84 c0                	test   %al,%al
  1013dd:	79 47                	jns    101426 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  1013df:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1013e4:	83 e0 40             	and    $0x40,%eax
  1013e7:	85 c0                	test   %eax,%eax
  1013e9:	75 09                	jne    1013f4 <kbd_proc_data+0x7f>
  1013eb:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1013ef:	83 e0 7f             	and    $0x7f,%eax
  1013f2:	eb 04                	jmp    1013f8 <kbd_proc_data+0x83>
  1013f4:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1013f8:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  1013fb:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1013ff:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  101406:	83 c8 40             	or     $0x40,%eax
  101409:	0f b6 c0             	movzbl %al,%eax
  10140c:	f7 d0                	not    %eax
  10140e:	89 c2                	mov    %eax,%edx
  101410:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101415:	21 d0                	and    %edx,%eax
  101417:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  10141c:	b8 00 00 00 00       	mov    $0x0,%eax
  101421:	e9 da 00 00 00       	jmp    101500 <kbd_proc_data+0x18b>
    } else if (shift & E0ESC) {
  101426:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10142b:	83 e0 40             	and    $0x40,%eax
  10142e:	85 c0                	test   %eax,%eax
  101430:	74 11                	je     101443 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  101432:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  101436:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10143b:	83 e0 bf             	and    $0xffffffbf,%eax
  10143e:	a3 88 f0 10 00       	mov    %eax,0x10f088
    }

    shift |= shiftcode[data];
  101443:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101447:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  10144e:	0f b6 d0             	movzbl %al,%edx
  101451:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101456:	09 d0                	or     %edx,%eax
  101458:	a3 88 f0 10 00       	mov    %eax,0x10f088
    shift ^= togglecode[data];
  10145d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101461:	0f b6 80 40 e1 10 00 	movzbl 0x10e140(%eax),%eax
  101468:	0f b6 d0             	movzbl %al,%edx
  10146b:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101470:	31 d0                	xor    %edx,%eax
  101472:	a3 88 f0 10 00       	mov    %eax,0x10f088

    c = charcode[shift & (CTL | SHIFT)][data];
  101477:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10147c:	83 e0 03             	and    $0x3,%eax
  10147f:	8b 14 85 40 e5 10 00 	mov    0x10e540(,%eax,4),%edx
  101486:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10148a:	01 d0                	add    %edx,%eax
  10148c:	0f b6 00             	movzbl (%eax),%eax
  10148f:	0f b6 c0             	movzbl %al,%eax
  101492:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  101495:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10149a:	83 e0 08             	and    $0x8,%eax
  10149d:	85 c0                	test   %eax,%eax
  10149f:	74 22                	je     1014c3 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  1014a1:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  1014a5:	7e 0c                	jle    1014b3 <kbd_proc_data+0x13e>
  1014a7:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  1014ab:	7f 06                	jg     1014b3 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  1014ad:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  1014b1:	eb 10                	jmp    1014c3 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  1014b3:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  1014b7:	7e 0a                	jle    1014c3 <kbd_proc_data+0x14e>
  1014b9:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  1014bd:	7f 04                	jg     1014c3 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  1014bf:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  1014c3:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014c8:	f7 d0                	not    %eax
  1014ca:	83 e0 06             	and    $0x6,%eax
  1014cd:	85 c0                	test   %eax,%eax
  1014cf:	75 2c                	jne    1014fd <kbd_proc_data+0x188>
  1014d1:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  1014d8:	75 23                	jne    1014fd <kbd_proc_data+0x188>
        cprintf("Rebooting!\n");
  1014da:	83 ec 0c             	sub    $0xc,%esp
  1014dd:	68 21 37 10 00       	push   $0x103721
  1014e2:	e8 56 ed ff ff       	call   10023d <cprintf>
  1014e7:	83 c4 10             	add    $0x10,%esp
  1014ea:	66 c7 45 ee 92 00    	movw   $0x92,-0x12(%ebp)
  1014f0:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1014f4:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1014f8:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1014fc:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  1014fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101500:	c9                   	leave  
  101501:	c3                   	ret    

00101502 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  101502:	55                   	push   %ebp
  101503:	89 e5                	mov    %esp,%ebp
  101505:	83 ec 08             	sub    $0x8,%esp
    cons_intr(kbd_proc_data);
  101508:	83 ec 0c             	sub    $0xc,%esp
  10150b:	68 75 13 10 00       	push   $0x101375
  101510:	e8 9b fd ff ff       	call   1012b0 <cons_intr>
  101515:	83 c4 10             	add    $0x10,%esp
}
  101518:	90                   	nop
  101519:	c9                   	leave  
  10151a:	c3                   	ret    

0010151b <kbd_init>:

static void
kbd_init(void) {
  10151b:	55                   	push   %ebp
  10151c:	89 e5                	mov    %esp,%ebp
  10151e:	83 ec 08             	sub    $0x8,%esp
    // drain the kbd buffer
    kbd_intr();
  101521:	e8 dc ff ff ff       	call   101502 <kbd_intr>
    pic_enable(IRQ_KBD);
  101526:	83 ec 0c             	sub    $0xc,%esp
  101529:	6a 01                	push   $0x1
  10152b:	e8 1c 01 00 00       	call   10164c <pic_enable>
  101530:	83 c4 10             	add    $0x10,%esp
}
  101533:	90                   	nop
  101534:	c9                   	leave  
  101535:	c3                   	ret    

00101536 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  101536:	55                   	push   %ebp
  101537:	89 e5                	mov    %esp,%ebp
  101539:	83 ec 08             	sub    $0x8,%esp
    cga_init();
  10153c:	e8 8c f8 ff ff       	call   100dcd <cga_init>
    serial_init();
  101541:	e8 6e f9 ff ff       	call   100eb4 <serial_init>
    kbd_init();
  101546:	e8 d0 ff ff ff       	call   10151b <kbd_init>
    if (!serial_exists) {
  10154b:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  101550:	85 c0                	test   %eax,%eax
  101552:	75 10                	jne    101564 <cons_init+0x2e>
        cprintf("serial port does not exist!!\n");
  101554:	83 ec 0c             	sub    $0xc,%esp
  101557:	68 2d 37 10 00       	push   $0x10372d
  10155c:	e8 dc ec ff ff       	call   10023d <cprintf>
  101561:	83 c4 10             	add    $0x10,%esp
    }
}
  101564:	90                   	nop
  101565:	c9                   	leave  
  101566:	c3                   	ret    

00101567 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  101567:	55                   	push   %ebp
  101568:	89 e5                	mov    %esp,%ebp
  10156a:	83 ec 08             	sub    $0x8,%esp
    lpt_putc(c);
  10156d:	ff 75 08             	pushl  0x8(%ebp)
  101570:	e8 9e fa ff ff       	call   101013 <lpt_putc>
  101575:	83 c4 04             	add    $0x4,%esp
    cga_putc(c);
  101578:	83 ec 0c             	sub    $0xc,%esp
  10157b:	ff 75 08             	pushl  0x8(%ebp)
  10157e:	e8 c7 fa ff ff       	call   10104a <cga_putc>
  101583:	83 c4 10             	add    $0x10,%esp
    serial_putc(c);
  101586:	83 ec 0c             	sub    $0xc,%esp
  101589:	ff 75 08             	pushl  0x8(%ebp)
  10158c:	e8 e8 fc ff ff       	call   101279 <serial_putc>
  101591:	83 c4 10             	add    $0x10,%esp
}
  101594:	90                   	nop
  101595:	c9                   	leave  
  101596:	c3                   	ret    

00101597 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  101597:	55                   	push   %ebp
  101598:	89 e5                	mov    %esp,%ebp
  10159a:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  10159d:	e8 b1 fd ff ff       	call   101353 <serial_intr>
    kbd_intr();
  1015a2:	e8 5b ff ff ff       	call   101502 <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  1015a7:	8b 15 80 f0 10 00    	mov    0x10f080,%edx
  1015ad:	a1 84 f0 10 00       	mov    0x10f084,%eax
  1015b2:	39 c2                	cmp    %eax,%edx
  1015b4:	74 36                	je     1015ec <cons_getc+0x55>
        c = cons.buf[cons.rpos ++];
  1015b6:	a1 80 f0 10 00       	mov    0x10f080,%eax
  1015bb:	8d 50 01             	lea    0x1(%eax),%edx
  1015be:	89 15 80 f0 10 00    	mov    %edx,0x10f080
  1015c4:	0f b6 80 80 ee 10 00 	movzbl 0x10ee80(%eax),%eax
  1015cb:	0f b6 c0             	movzbl %al,%eax
  1015ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  1015d1:	a1 80 f0 10 00       	mov    0x10f080,%eax
  1015d6:	3d 00 02 00 00       	cmp    $0x200,%eax
  1015db:	75 0a                	jne    1015e7 <cons_getc+0x50>
            cons.rpos = 0;
  1015dd:	c7 05 80 f0 10 00 00 	movl   $0x0,0x10f080
  1015e4:	00 00 00 
        }
        return c;
  1015e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1015ea:	eb 05                	jmp    1015f1 <cons_getc+0x5a>
    }
    return 0;
  1015ec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1015f1:	c9                   	leave  
  1015f2:	c3                   	ret    

001015f3 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  1015f3:	55                   	push   %ebp
  1015f4:	89 e5                	mov    %esp,%ebp
  1015f6:	83 ec 14             	sub    $0x14,%esp
  1015f9:	8b 45 08             	mov    0x8(%ebp),%eax
  1015fc:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  101600:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101604:	66 a3 50 e5 10 00    	mov    %ax,0x10e550
    if (did_init) {
  10160a:	a1 8c f0 10 00       	mov    0x10f08c,%eax
  10160f:	85 c0                	test   %eax,%eax
  101611:	74 36                	je     101649 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  101613:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101617:	0f b6 c0             	movzbl %al,%eax
  10161a:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  101620:	88 45 fa             	mov    %al,-0x6(%ebp)
  101623:	0f b6 45 fa          	movzbl -0x6(%ebp),%eax
  101627:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  10162b:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  10162c:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101630:	66 c1 e8 08          	shr    $0x8,%ax
  101634:	0f b6 c0             	movzbl %al,%eax
  101637:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
  10163d:	88 45 fb             	mov    %al,-0x5(%ebp)
  101640:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
  101644:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
  101648:	ee                   	out    %al,(%dx)
    }
}
  101649:	90                   	nop
  10164a:	c9                   	leave  
  10164b:	c3                   	ret    

0010164c <pic_enable>:

void
pic_enable(unsigned int irq) {
  10164c:	55                   	push   %ebp
  10164d:	89 e5                	mov    %esp,%ebp
    pic_setmask(irq_mask & ~(1 << irq));
  10164f:	8b 45 08             	mov    0x8(%ebp),%eax
  101652:	ba 01 00 00 00       	mov    $0x1,%edx
  101657:	89 c1                	mov    %eax,%ecx
  101659:	d3 e2                	shl    %cl,%edx
  10165b:	89 d0                	mov    %edx,%eax
  10165d:	f7 d0                	not    %eax
  10165f:	89 c2                	mov    %eax,%edx
  101661:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  101668:	21 d0                	and    %edx,%eax
  10166a:	0f b7 c0             	movzwl %ax,%eax
  10166d:	50                   	push   %eax
  10166e:	e8 80 ff ff ff       	call   1015f3 <pic_setmask>
  101673:	83 c4 04             	add    $0x4,%esp
}
  101676:	90                   	nop
  101677:	c9                   	leave  
  101678:	c3                   	ret    

00101679 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  101679:	55                   	push   %ebp
  10167a:	89 e5                	mov    %esp,%ebp
  10167c:	83 ec 30             	sub    $0x30,%esp
    did_init = 1;
  10167f:	c7 05 8c f0 10 00 01 	movl   $0x1,0x10f08c
  101686:	00 00 00 
  101689:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  10168f:	c6 45 d6 ff          	movb   $0xff,-0x2a(%ebp)
  101693:	0f b6 45 d6          	movzbl -0x2a(%ebp),%eax
  101697:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  10169b:	ee                   	out    %al,(%dx)
  10169c:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
  1016a2:	c6 45 d7 ff          	movb   $0xff,-0x29(%ebp)
  1016a6:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
  1016aa:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
  1016ae:	ee                   	out    %al,(%dx)
  1016af:	66 c7 45 fa 20 00    	movw   $0x20,-0x6(%ebp)
  1016b5:	c6 45 d8 11          	movb   $0x11,-0x28(%ebp)
  1016b9:	0f b6 45 d8          	movzbl -0x28(%ebp),%eax
  1016bd:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1016c1:	ee                   	out    %al,(%dx)
  1016c2:	66 c7 45 f8 21 00    	movw   $0x21,-0x8(%ebp)
  1016c8:	c6 45 d9 20          	movb   $0x20,-0x27(%ebp)
  1016cc:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  1016d0:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  1016d4:	ee                   	out    %al,(%dx)
  1016d5:	66 c7 45 f6 21 00    	movw   $0x21,-0xa(%ebp)
  1016db:	c6 45 da 04          	movb   $0x4,-0x26(%ebp)
  1016df:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
  1016e3:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1016e7:	ee                   	out    %al,(%dx)
  1016e8:	66 c7 45 f4 21 00    	movw   $0x21,-0xc(%ebp)
  1016ee:	c6 45 db 03          	movb   $0x3,-0x25(%ebp)
  1016f2:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
  1016f6:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
  1016fa:	ee                   	out    %al,(%dx)
  1016fb:	66 c7 45 f2 a0 00    	movw   $0xa0,-0xe(%ebp)
  101701:	c6 45 dc 11          	movb   $0x11,-0x24(%ebp)
  101705:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
  101709:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10170d:	ee                   	out    %al,(%dx)
  10170e:	66 c7 45 f0 a1 00    	movw   $0xa1,-0x10(%ebp)
  101714:	c6 45 dd 28          	movb   $0x28,-0x23(%ebp)
  101718:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  10171c:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  101720:	ee                   	out    %al,(%dx)
  101721:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  101727:	c6 45 de 02          	movb   $0x2,-0x22(%ebp)
  10172b:	0f b6 45 de          	movzbl -0x22(%ebp),%eax
  10172f:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101733:	ee                   	out    %al,(%dx)
  101734:	66 c7 45 ec a1 00    	movw   $0xa1,-0x14(%ebp)
  10173a:	c6 45 df 03          	movb   $0x3,-0x21(%ebp)
  10173e:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
  101742:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
  101746:	ee                   	out    %al,(%dx)
  101747:	66 c7 45 ea 20 00    	movw   $0x20,-0x16(%ebp)
  10174d:	c6 45 e0 68          	movb   $0x68,-0x20(%ebp)
  101751:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
  101755:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101759:	ee                   	out    %al,(%dx)
  10175a:	66 c7 45 e8 20 00    	movw   $0x20,-0x18(%ebp)
  101760:	c6 45 e1 0a          	movb   $0xa,-0x1f(%ebp)
  101764:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  101768:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  10176c:	ee                   	out    %al,(%dx)
  10176d:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  101773:	c6 45 e2 68          	movb   $0x68,-0x1e(%ebp)
  101777:	0f b6 45 e2          	movzbl -0x1e(%ebp),%eax
  10177b:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  10177f:	ee                   	out    %al,(%dx)
  101780:	66 c7 45 e4 a0 00    	movw   $0xa0,-0x1c(%ebp)
  101786:	c6 45 e3 0a          	movb   $0xa,-0x1d(%ebp)
  10178a:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
  10178e:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
  101792:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  101793:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  10179a:	66 83 f8 ff          	cmp    $0xffff,%ax
  10179e:	74 13                	je     1017b3 <pic_init+0x13a>
        pic_setmask(irq_mask);
  1017a0:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017a7:	0f b7 c0             	movzwl %ax,%eax
  1017aa:	50                   	push   %eax
  1017ab:	e8 43 fe ff ff       	call   1015f3 <pic_setmask>
  1017b0:	83 c4 04             	add    $0x4,%esp
    }
}
  1017b3:	90                   	nop
  1017b4:	c9                   	leave  
  1017b5:	c3                   	ret    

001017b6 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  1017b6:	55                   	push   %ebp
  1017b7:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  1017b9:	fb                   	sti    
    sti();
}
  1017ba:	90                   	nop
  1017bb:	5d                   	pop    %ebp
  1017bc:	c3                   	ret    

001017bd <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  1017bd:	55                   	push   %ebp
  1017be:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli");
  1017c0:	fa                   	cli    
    cli();
}
  1017c1:	90                   	nop
  1017c2:	5d                   	pop    %ebp
  1017c3:	c3                   	ret    

001017c4 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  1017c4:	55                   	push   %ebp
  1017c5:	89 e5                	mov    %esp,%ebp
  1017c7:	83 ec 08             	sub    $0x8,%esp
    cprintf("%d ticks\n",TICK_NUM);
  1017ca:	83 ec 08             	sub    $0x8,%esp
  1017cd:	6a 64                	push   $0x64
  1017cf:	68 60 37 10 00       	push   $0x103760
  1017d4:	e8 64 ea ff ff       	call   10023d <cprintf>
  1017d9:	83 c4 10             	add    $0x10,%esp
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  1017dc:	90                   	nop
  1017dd:	c9                   	leave  
  1017de:	c3                   	ret    

001017df <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  1017df:	55                   	push   %ebp
  1017e0:	89 e5                	mov    %esp,%ebp
  1017e2:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
        extern uintptr_t __vectors[];
        int i;
        for(i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++){
  1017e5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1017ec:	e9 c3 00 00 00       	jmp    1018b4 <idt_init+0xd5>
                SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  1017f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1017f4:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  1017fb:	89 c2                	mov    %eax,%edx
  1017fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101800:	66 89 14 c5 a0 f0 10 	mov    %dx,0x10f0a0(,%eax,8)
  101807:	00 
  101808:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10180b:	66 c7 04 c5 a2 f0 10 	movw   $0x8,0x10f0a2(,%eax,8)
  101812:	00 08 00 
  101815:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101818:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  10181f:	00 
  101820:	83 e2 e0             	and    $0xffffffe0,%edx
  101823:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  10182a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10182d:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  101834:	00 
  101835:	83 e2 1f             	and    $0x1f,%edx
  101838:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  10183f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101842:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  101849:	00 
  10184a:	83 e2 f0             	and    $0xfffffff0,%edx
  10184d:	83 ca 0e             	or     $0xe,%edx
  101850:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  101857:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10185a:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  101861:	00 
  101862:	83 e2 ef             	and    $0xffffffef,%edx
  101865:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  10186c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10186f:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  101876:	00 
  101877:	83 e2 9f             	and    $0xffffff9f,%edx
  10187a:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  101881:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101884:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  10188b:	00 
  10188c:	83 ca 80             	or     $0xffffff80,%edx
  10188f:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  101896:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101899:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  1018a0:	c1 e8 10             	shr    $0x10,%eax
  1018a3:	89 c2                	mov    %eax,%edx
  1018a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018a8:	66 89 14 c5 a6 f0 10 	mov    %dx,0x10f0a6(,%eax,8)
  1018af:	00 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
        extern uintptr_t __vectors[];
        int i;
        for(i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++){
  1018b0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1018b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018b7:	3d ff 00 00 00       	cmp    $0xff,%eax
  1018bc:	0f 86 2f ff ff ff    	jbe    1017f1 <idt_init+0x12>
                SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
        }
        
        // set for switch from user to kernel
        SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
  1018c2:	a1 c4 e7 10 00       	mov    0x10e7c4,%eax
  1018c7:	66 a3 68 f4 10 00    	mov    %ax,0x10f468
  1018cd:	66 c7 05 6a f4 10 00 	movw   $0x8,0x10f46a
  1018d4:	08 00 
  1018d6:	0f b6 05 6c f4 10 00 	movzbl 0x10f46c,%eax
  1018dd:	83 e0 e0             	and    $0xffffffe0,%eax
  1018e0:	a2 6c f4 10 00       	mov    %al,0x10f46c
  1018e5:	0f b6 05 6c f4 10 00 	movzbl 0x10f46c,%eax
  1018ec:	83 e0 1f             	and    $0x1f,%eax
  1018ef:	a2 6c f4 10 00       	mov    %al,0x10f46c
  1018f4:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  1018fb:	83 e0 f0             	and    $0xfffffff0,%eax
  1018fe:	83 c8 0e             	or     $0xe,%eax
  101901:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101906:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  10190d:	83 e0 ef             	and    $0xffffffef,%eax
  101910:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101915:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  10191c:	83 c8 60             	or     $0x60,%eax
  10191f:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101924:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  10192b:	83 c8 80             	or     $0xffffff80,%eax
  10192e:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101933:	a1 c4 e7 10 00       	mov    0x10e7c4,%eax
  101938:	c1 e8 10             	shr    $0x10,%eax
  10193b:	66 a3 6e f4 10 00    	mov    %ax,0x10f46e
  101941:	c7 45 f8 60 e5 10 00 	movl   $0x10e560,-0x8(%ebp)
    return ebp;
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd));
  101948:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10194b:	0f 01 18             	lidtl  (%eax)

        //load the IDT
        lidt(&idt_pd);
}
  10194e:	90                   	nop
  10194f:	c9                   	leave  
  101950:	c3                   	ret    

00101951 <trapname>:

static const char *
trapname(int trapno) {
  101951:	55                   	push   %ebp
  101952:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101954:	8b 45 08             	mov    0x8(%ebp),%eax
  101957:	83 f8 13             	cmp    $0x13,%eax
  10195a:	77 0c                	ja     101968 <trapname+0x17>
        return excnames[trapno];
  10195c:	8b 45 08             	mov    0x8(%ebp),%eax
  10195f:	8b 04 85 c0 3a 10 00 	mov    0x103ac0(,%eax,4),%eax
  101966:	eb 18                	jmp    101980 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101968:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  10196c:	7e 0d                	jle    10197b <trapname+0x2a>
  10196e:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101972:	7f 07                	jg     10197b <trapname+0x2a>
        return "Hardware Interrupt";
  101974:	b8 6a 37 10 00       	mov    $0x10376a,%eax
  101979:	eb 05                	jmp    101980 <trapname+0x2f>
    }
    return "(unknown trap)";
  10197b:	b8 7d 37 10 00       	mov    $0x10377d,%eax
}
  101980:	5d                   	pop    %ebp
  101981:	c3                   	ret    

00101982 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101982:	55                   	push   %ebp
  101983:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101985:	8b 45 08             	mov    0x8(%ebp),%eax
  101988:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  10198c:	66 83 f8 08          	cmp    $0x8,%ax
  101990:	0f 94 c0             	sete   %al
  101993:	0f b6 c0             	movzbl %al,%eax
}
  101996:	5d                   	pop    %ebp
  101997:	c3                   	ret    

00101998 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101998:	55                   	push   %ebp
  101999:	89 e5                	mov    %esp,%ebp
  10199b:	83 ec 18             	sub    $0x18,%esp
    cprintf("trapframe at %p\n", tf);
  10199e:	83 ec 08             	sub    $0x8,%esp
  1019a1:	ff 75 08             	pushl  0x8(%ebp)
  1019a4:	68 be 37 10 00       	push   $0x1037be
  1019a9:	e8 8f e8 ff ff       	call   10023d <cprintf>
  1019ae:	83 c4 10             	add    $0x10,%esp
    print_regs(&tf->tf_regs);
  1019b1:	8b 45 08             	mov    0x8(%ebp),%eax
  1019b4:	83 ec 0c             	sub    $0xc,%esp
  1019b7:	50                   	push   %eax
  1019b8:	e8 b8 01 00 00       	call   101b75 <print_regs>
  1019bd:	83 c4 10             	add    $0x10,%esp
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  1019c0:	8b 45 08             	mov    0x8(%ebp),%eax
  1019c3:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  1019c7:	0f b7 c0             	movzwl %ax,%eax
  1019ca:	83 ec 08             	sub    $0x8,%esp
  1019cd:	50                   	push   %eax
  1019ce:	68 cf 37 10 00       	push   $0x1037cf
  1019d3:	e8 65 e8 ff ff       	call   10023d <cprintf>
  1019d8:	83 c4 10             	add    $0x10,%esp
    cprintf("  es   0x----%04x\n", tf->tf_es);
  1019db:	8b 45 08             	mov    0x8(%ebp),%eax
  1019de:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  1019e2:	0f b7 c0             	movzwl %ax,%eax
  1019e5:	83 ec 08             	sub    $0x8,%esp
  1019e8:	50                   	push   %eax
  1019e9:	68 e2 37 10 00       	push   $0x1037e2
  1019ee:	e8 4a e8 ff ff       	call   10023d <cprintf>
  1019f3:	83 c4 10             	add    $0x10,%esp
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  1019f6:	8b 45 08             	mov    0x8(%ebp),%eax
  1019f9:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  1019fd:	0f b7 c0             	movzwl %ax,%eax
  101a00:	83 ec 08             	sub    $0x8,%esp
  101a03:	50                   	push   %eax
  101a04:	68 f5 37 10 00       	push   $0x1037f5
  101a09:	e8 2f e8 ff ff       	call   10023d <cprintf>
  101a0e:	83 c4 10             	add    $0x10,%esp
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101a11:	8b 45 08             	mov    0x8(%ebp),%eax
  101a14:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101a18:	0f b7 c0             	movzwl %ax,%eax
  101a1b:	83 ec 08             	sub    $0x8,%esp
  101a1e:	50                   	push   %eax
  101a1f:	68 08 38 10 00       	push   $0x103808
  101a24:	e8 14 e8 ff ff       	call   10023d <cprintf>
  101a29:	83 c4 10             	add    $0x10,%esp
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  101a2f:	8b 40 30             	mov    0x30(%eax),%eax
  101a32:	83 ec 0c             	sub    $0xc,%esp
  101a35:	50                   	push   %eax
  101a36:	e8 16 ff ff ff       	call   101951 <trapname>
  101a3b:	83 c4 10             	add    $0x10,%esp
  101a3e:	89 c2                	mov    %eax,%edx
  101a40:	8b 45 08             	mov    0x8(%ebp),%eax
  101a43:	8b 40 30             	mov    0x30(%eax),%eax
  101a46:	83 ec 04             	sub    $0x4,%esp
  101a49:	52                   	push   %edx
  101a4a:	50                   	push   %eax
  101a4b:	68 1b 38 10 00       	push   $0x10381b
  101a50:	e8 e8 e7 ff ff       	call   10023d <cprintf>
  101a55:	83 c4 10             	add    $0x10,%esp
    cprintf("  err  0x%08x\n", tf->tf_err);
  101a58:	8b 45 08             	mov    0x8(%ebp),%eax
  101a5b:	8b 40 34             	mov    0x34(%eax),%eax
  101a5e:	83 ec 08             	sub    $0x8,%esp
  101a61:	50                   	push   %eax
  101a62:	68 2d 38 10 00       	push   $0x10382d
  101a67:	e8 d1 e7 ff ff       	call   10023d <cprintf>
  101a6c:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  101a72:	8b 40 38             	mov    0x38(%eax),%eax
  101a75:	83 ec 08             	sub    $0x8,%esp
  101a78:	50                   	push   %eax
  101a79:	68 3c 38 10 00       	push   $0x10383c
  101a7e:	e8 ba e7 ff ff       	call   10023d <cprintf>
  101a83:	83 c4 10             	add    $0x10,%esp
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101a86:	8b 45 08             	mov    0x8(%ebp),%eax
  101a89:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101a8d:	0f b7 c0             	movzwl %ax,%eax
  101a90:	83 ec 08             	sub    $0x8,%esp
  101a93:	50                   	push   %eax
  101a94:	68 4b 38 10 00       	push   $0x10384b
  101a99:	e8 9f e7 ff ff       	call   10023d <cprintf>
  101a9e:	83 c4 10             	add    $0x10,%esp
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101aa1:	8b 45 08             	mov    0x8(%ebp),%eax
  101aa4:	8b 40 40             	mov    0x40(%eax),%eax
  101aa7:	83 ec 08             	sub    $0x8,%esp
  101aaa:	50                   	push   %eax
  101aab:	68 5e 38 10 00       	push   $0x10385e
  101ab0:	e8 88 e7 ff ff       	call   10023d <cprintf>
  101ab5:	83 c4 10             	add    $0x10,%esp

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101ab8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101abf:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101ac6:	eb 3f                	jmp    101b07 <print_trapframe+0x16f>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  101acb:	8b 50 40             	mov    0x40(%eax),%edx
  101ace:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101ad1:	21 d0                	and    %edx,%eax
  101ad3:	85 c0                	test   %eax,%eax
  101ad5:	74 29                	je     101b00 <print_trapframe+0x168>
  101ad7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101ada:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101ae1:	85 c0                	test   %eax,%eax
  101ae3:	74 1b                	je     101b00 <print_trapframe+0x168>
            cprintf("%s,", IA32flags[i]);
  101ae5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101ae8:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101aef:	83 ec 08             	sub    $0x8,%esp
  101af2:	50                   	push   %eax
  101af3:	68 6d 38 10 00       	push   $0x10386d
  101af8:	e8 40 e7 ff ff       	call   10023d <cprintf>
  101afd:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b00:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101b04:	d1 65 f0             	shll   -0x10(%ebp)
  101b07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b0a:	83 f8 17             	cmp    $0x17,%eax
  101b0d:	76 b9                	jbe    101ac8 <print_trapframe+0x130>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  101b12:	8b 40 40             	mov    0x40(%eax),%eax
  101b15:	25 00 30 00 00       	and    $0x3000,%eax
  101b1a:	c1 e8 0c             	shr    $0xc,%eax
  101b1d:	83 ec 08             	sub    $0x8,%esp
  101b20:	50                   	push   %eax
  101b21:	68 71 38 10 00       	push   $0x103871
  101b26:	e8 12 e7 ff ff       	call   10023d <cprintf>
  101b2b:	83 c4 10             	add    $0x10,%esp

    if (!trap_in_kernel(tf)) {
  101b2e:	83 ec 0c             	sub    $0xc,%esp
  101b31:	ff 75 08             	pushl  0x8(%ebp)
  101b34:	e8 49 fe ff ff       	call   101982 <trap_in_kernel>
  101b39:	83 c4 10             	add    $0x10,%esp
  101b3c:	85 c0                	test   %eax,%eax
  101b3e:	75 32                	jne    101b72 <print_trapframe+0x1da>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101b40:	8b 45 08             	mov    0x8(%ebp),%eax
  101b43:	8b 40 44             	mov    0x44(%eax),%eax
  101b46:	83 ec 08             	sub    $0x8,%esp
  101b49:	50                   	push   %eax
  101b4a:	68 7a 38 10 00       	push   $0x10387a
  101b4f:	e8 e9 e6 ff ff       	call   10023d <cprintf>
  101b54:	83 c4 10             	add    $0x10,%esp
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101b57:	8b 45 08             	mov    0x8(%ebp),%eax
  101b5a:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101b5e:	0f b7 c0             	movzwl %ax,%eax
  101b61:	83 ec 08             	sub    $0x8,%esp
  101b64:	50                   	push   %eax
  101b65:	68 89 38 10 00       	push   $0x103889
  101b6a:	e8 ce e6 ff ff       	call   10023d <cprintf>
  101b6f:	83 c4 10             	add    $0x10,%esp
    }
}
  101b72:	90                   	nop
  101b73:	c9                   	leave  
  101b74:	c3                   	ret    

00101b75 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101b75:	55                   	push   %ebp
  101b76:	89 e5                	mov    %esp,%ebp
  101b78:	83 ec 08             	sub    $0x8,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101b7b:	8b 45 08             	mov    0x8(%ebp),%eax
  101b7e:	8b 00                	mov    (%eax),%eax
  101b80:	83 ec 08             	sub    $0x8,%esp
  101b83:	50                   	push   %eax
  101b84:	68 9c 38 10 00       	push   $0x10389c
  101b89:	e8 af e6 ff ff       	call   10023d <cprintf>
  101b8e:	83 c4 10             	add    $0x10,%esp
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101b91:	8b 45 08             	mov    0x8(%ebp),%eax
  101b94:	8b 40 04             	mov    0x4(%eax),%eax
  101b97:	83 ec 08             	sub    $0x8,%esp
  101b9a:	50                   	push   %eax
  101b9b:	68 ab 38 10 00       	push   $0x1038ab
  101ba0:	e8 98 e6 ff ff       	call   10023d <cprintf>
  101ba5:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101ba8:	8b 45 08             	mov    0x8(%ebp),%eax
  101bab:	8b 40 08             	mov    0x8(%eax),%eax
  101bae:	83 ec 08             	sub    $0x8,%esp
  101bb1:	50                   	push   %eax
  101bb2:	68 ba 38 10 00       	push   $0x1038ba
  101bb7:	e8 81 e6 ff ff       	call   10023d <cprintf>
  101bbc:	83 c4 10             	add    $0x10,%esp
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  101bc2:	8b 40 0c             	mov    0xc(%eax),%eax
  101bc5:	83 ec 08             	sub    $0x8,%esp
  101bc8:	50                   	push   %eax
  101bc9:	68 c9 38 10 00       	push   $0x1038c9
  101bce:	e8 6a e6 ff ff       	call   10023d <cprintf>
  101bd3:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  101bd9:	8b 40 10             	mov    0x10(%eax),%eax
  101bdc:	83 ec 08             	sub    $0x8,%esp
  101bdf:	50                   	push   %eax
  101be0:	68 d8 38 10 00       	push   $0x1038d8
  101be5:	e8 53 e6 ff ff       	call   10023d <cprintf>
  101bea:	83 c4 10             	add    $0x10,%esp
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101bed:	8b 45 08             	mov    0x8(%ebp),%eax
  101bf0:	8b 40 14             	mov    0x14(%eax),%eax
  101bf3:	83 ec 08             	sub    $0x8,%esp
  101bf6:	50                   	push   %eax
  101bf7:	68 e7 38 10 00       	push   $0x1038e7
  101bfc:	e8 3c e6 ff ff       	call   10023d <cprintf>
  101c01:	83 c4 10             	add    $0x10,%esp
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101c04:	8b 45 08             	mov    0x8(%ebp),%eax
  101c07:	8b 40 18             	mov    0x18(%eax),%eax
  101c0a:	83 ec 08             	sub    $0x8,%esp
  101c0d:	50                   	push   %eax
  101c0e:	68 f6 38 10 00       	push   $0x1038f6
  101c13:	e8 25 e6 ff ff       	call   10023d <cprintf>
  101c18:	83 c4 10             	add    $0x10,%esp
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  101c1e:	8b 40 1c             	mov    0x1c(%eax),%eax
  101c21:	83 ec 08             	sub    $0x8,%esp
  101c24:	50                   	push   %eax
  101c25:	68 05 39 10 00       	push   $0x103905
  101c2a:	e8 0e e6 ff ff       	call   10023d <cprintf>
  101c2f:	83 c4 10             	add    $0x10,%esp
}
  101c32:	90                   	nop
  101c33:	c9                   	leave  
  101c34:	c3                   	ret    

00101c35 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101c35:	55                   	push   %ebp
  101c36:	89 e5                	mov    %esp,%ebp
  101c38:	83 ec 18             	sub    $0x18,%esp
    char c;

    switch (tf->tf_trapno) {
  101c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  101c3e:	8b 40 30             	mov    0x30(%eax),%eax
  101c41:	83 f8 2f             	cmp    $0x2f,%eax
  101c44:	77 1d                	ja     101c63 <trap_dispatch+0x2e>
  101c46:	83 f8 2e             	cmp    $0x2e,%eax
  101c49:	0f 83 f4 00 00 00    	jae    101d43 <trap_dispatch+0x10e>
  101c4f:	83 f8 21             	cmp    $0x21,%eax
  101c52:	74 7e                	je     101cd2 <trap_dispatch+0x9d>
  101c54:	83 f8 24             	cmp    $0x24,%eax
  101c57:	74 55                	je     101cae <trap_dispatch+0x79>
  101c59:	83 f8 20             	cmp    $0x20,%eax
  101c5c:	74 16                	je     101c74 <trap_dispatch+0x3f>
  101c5e:	e9 aa 00 00 00       	jmp    101d0d <trap_dispatch+0xd8>
  101c63:	83 e8 78             	sub    $0x78,%eax
  101c66:	83 f8 01             	cmp    $0x1,%eax
  101c69:	0f 87 9e 00 00 00    	ja     101d0d <trap_dispatch+0xd8>
  101c6f:	e9 82 00 00 00       	jmp    101cf6 <trap_dispatch+0xc1>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
  101c74:	a1 08 f9 10 00       	mov    0x10f908,%eax
  101c79:	83 c0 01             	add    $0x1,%eax
  101c7c:	a3 08 f9 10 00       	mov    %eax,0x10f908
        if(ticks % TICK_NUM == 0)
  101c81:	8b 0d 08 f9 10 00    	mov    0x10f908,%ecx
  101c87:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101c8c:	89 c8                	mov    %ecx,%eax
  101c8e:	f7 e2                	mul    %edx
  101c90:	89 d0                	mov    %edx,%eax
  101c92:	c1 e8 05             	shr    $0x5,%eax
  101c95:	6b c0 64             	imul   $0x64,%eax,%eax
  101c98:	29 c1                	sub    %eax,%ecx
  101c9a:	89 c8                	mov    %ecx,%eax
  101c9c:	85 c0                	test   %eax,%eax
  101c9e:	0f 85 a2 00 00 00    	jne    101d46 <trap_dispatch+0x111>
                print_ticks();
  101ca4:	e8 1b fb ff ff       	call   1017c4 <print_ticks>
        break;
  101ca9:	e9 98 00 00 00       	jmp    101d46 <trap_dispatch+0x111>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101cae:	e8 e4 f8 ff ff       	call   101597 <cons_getc>
  101cb3:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101cb6:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101cba:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101cbe:	83 ec 04             	sub    $0x4,%esp
  101cc1:	52                   	push   %edx
  101cc2:	50                   	push   %eax
  101cc3:	68 14 39 10 00       	push   $0x103914
  101cc8:	e8 70 e5 ff ff       	call   10023d <cprintf>
  101ccd:	83 c4 10             	add    $0x10,%esp
        break;
  101cd0:	eb 75                	jmp    101d47 <trap_dispatch+0x112>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101cd2:	e8 c0 f8 ff ff       	call   101597 <cons_getc>
  101cd7:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101cda:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101cde:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101ce2:	83 ec 04             	sub    $0x4,%esp
  101ce5:	52                   	push   %edx
  101ce6:	50                   	push   %eax
  101ce7:	68 26 39 10 00       	push   $0x103926
  101cec:	e8 4c e5 ff ff       	call   10023d <cprintf>
  101cf1:	83 c4 10             	add    $0x10,%esp
        break;
  101cf4:	eb 51                	jmp    101d47 <trap_dispatch+0x112>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101cf6:	83 ec 04             	sub    $0x4,%esp
  101cf9:	68 35 39 10 00       	push   $0x103935
  101cfe:	68 b0 00 00 00       	push   $0xb0
  101d03:	68 45 39 10 00       	push   $0x103945
  101d08:	e8 96 e6 ff ff       	call   1003a3 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  101d10:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101d14:	0f b7 c0             	movzwl %ax,%eax
  101d17:	83 e0 03             	and    $0x3,%eax
  101d1a:	85 c0                	test   %eax,%eax
  101d1c:	75 29                	jne    101d47 <trap_dispatch+0x112>
            print_trapframe(tf);
  101d1e:	83 ec 0c             	sub    $0xc,%esp
  101d21:	ff 75 08             	pushl  0x8(%ebp)
  101d24:	e8 6f fc ff ff       	call   101998 <print_trapframe>
  101d29:	83 c4 10             	add    $0x10,%esp
            panic("unexpected trap in kernel.\n");
  101d2c:	83 ec 04             	sub    $0x4,%esp
  101d2f:	68 56 39 10 00       	push   $0x103956
  101d34:	68 ba 00 00 00       	push   $0xba
  101d39:	68 45 39 10 00       	push   $0x103945
  101d3e:	e8 60 e6 ff ff       	call   1003a3 <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101d43:	90                   	nop
  101d44:	eb 01                	jmp    101d47 <trap_dispatch+0x112>
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
        if(ticks % TICK_NUM == 0)
                print_ticks();
        break;
  101d46:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101d47:	90                   	nop
  101d48:	c9                   	leave  
  101d49:	c3                   	ret    

00101d4a <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101d4a:	55                   	push   %ebp
  101d4b:	89 e5                	mov    %esp,%ebp
  101d4d:	83 ec 08             	sub    $0x8,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101d50:	83 ec 0c             	sub    $0xc,%esp
  101d53:	ff 75 08             	pushl  0x8(%ebp)
  101d56:	e8 da fe ff ff       	call   101c35 <trap_dispatch>
  101d5b:	83 c4 10             	add    $0x10,%esp
}
  101d5e:	90                   	nop
  101d5f:	c9                   	leave  
  101d60:	c3                   	ret    

00101d61 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101d61:	6a 00                	push   $0x0
  pushl $0
  101d63:	6a 00                	push   $0x0
  jmp __alltraps
  101d65:	e9 67 0a 00 00       	jmp    1027d1 <__alltraps>

00101d6a <vector1>:
.globl vector1
vector1:
  pushl $0
  101d6a:	6a 00                	push   $0x0
  pushl $1
  101d6c:	6a 01                	push   $0x1
  jmp __alltraps
  101d6e:	e9 5e 0a 00 00       	jmp    1027d1 <__alltraps>

00101d73 <vector2>:
.globl vector2
vector2:
  pushl $0
  101d73:	6a 00                	push   $0x0
  pushl $2
  101d75:	6a 02                	push   $0x2
  jmp __alltraps
  101d77:	e9 55 0a 00 00       	jmp    1027d1 <__alltraps>

00101d7c <vector3>:
.globl vector3
vector3:
  pushl $0
  101d7c:	6a 00                	push   $0x0
  pushl $3
  101d7e:	6a 03                	push   $0x3
  jmp __alltraps
  101d80:	e9 4c 0a 00 00       	jmp    1027d1 <__alltraps>

00101d85 <vector4>:
.globl vector4
vector4:
  pushl $0
  101d85:	6a 00                	push   $0x0
  pushl $4
  101d87:	6a 04                	push   $0x4
  jmp __alltraps
  101d89:	e9 43 0a 00 00       	jmp    1027d1 <__alltraps>

00101d8e <vector5>:
.globl vector5
vector5:
  pushl $0
  101d8e:	6a 00                	push   $0x0
  pushl $5
  101d90:	6a 05                	push   $0x5
  jmp __alltraps
  101d92:	e9 3a 0a 00 00       	jmp    1027d1 <__alltraps>

00101d97 <vector6>:
.globl vector6
vector6:
  pushl $0
  101d97:	6a 00                	push   $0x0
  pushl $6
  101d99:	6a 06                	push   $0x6
  jmp __alltraps
  101d9b:	e9 31 0a 00 00       	jmp    1027d1 <__alltraps>

00101da0 <vector7>:
.globl vector7
vector7:
  pushl $0
  101da0:	6a 00                	push   $0x0
  pushl $7
  101da2:	6a 07                	push   $0x7
  jmp __alltraps
  101da4:	e9 28 0a 00 00       	jmp    1027d1 <__alltraps>

00101da9 <vector8>:
.globl vector8
vector8:
  pushl $8
  101da9:	6a 08                	push   $0x8
  jmp __alltraps
  101dab:	e9 21 0a 00 00       	jmp    1027d1 <__alltraps>

00101db0 <vector9>:
.globl vector9
vector9:
  pushl $9
  101db0:	6a 09                	push   $0x9
  jmp __alltraps
  101db2:	e9 1a 0a 00 00       	jmp    1027d1 <__alltraps>

00101db7 <vector10>:
.globl vector10
vector10:
  pushl $10
  101db7:	6a 0a                	push   $0xa
  jmp __alltraps
  101db9:	e9 13 0a 00 00       	jmp    1027d1 <__alltraps>

00101dbe <vector11>:
.globl vector11
vector11:
  pushl $11
  101dbe:	6a 0b                	push   $0xb
  jmp __alltraps
  101dc0:	e9 0c 0a 00 00       	jmp    1027d1 <__alltraps>

00101dc5 <vector12>:
.globl vector12
vector12:
  pushl $12
  101dc5:	6a 0c                	push   $0xc
  jmp __alltraps
  101dc7:	e9 05 0a 00 00       	jmp    1027d1 <__alltraps>

00101dcc <vector13>:
.globl vector13
vector13:
  pushl $13
  101dcc:	6a 0d                	push   $0xd
  jmp __alltraps
  101dce:	e9 fe 09 00 00       	jmp    1027d1 <__alltraps>

00101dd3 <vector14>:
.globl vector14
vector14:
  pushl $14
  101dd3:	6a 0e                	push   $0xe
  jmp __alltraps
  101dd5:	e9 f7 09 00 00       	jmp    1027d1 <__alltraps>

00101dda <vector15>:
.globl vector15
vector15:
  pushl $0
  101dda:	6a 00                	push   $0x0
  pushl $15
  101ddc:	6a 0f                	push   $0xf
  jmp __alltraps
  101dde:	e9 ee 09 00 00       	jmp    1027d1 <__alltraps>

00101de3 <vector16>:
.globl vector16
vector16:
  pushl $0
  101de3:	6a 00                	push   $0x0
  pushl $16
  101de5:	6a 10                	push   $0x10
  jmp __alltraps
  101de7:	e9 e5 09 00 00       	jmp    1027d1 <__alltraps>

00101dec <vector17>:
.globl vector17
vector17:
  pushl $17
  101dec:	6a 11                	push   $0x11
  jmp __alltraps
  101dee:	e9 de 09 00 00       	jmp    1027d1 <__alltraps>

00101df3 <vector18>:
.globl vector18
vector18:
  pushl $0
  101df3:	6a 00                	push   $0x0
  pushl $18
  101df5:	6a 12                	push   $0x12
  jmp __alltraps
  101df7:	e9 d5 09 00 00       	jmp    1027d1 <__alltraps>

00101dfc <vector19>:
.globl vector19
vector19:
  pushl $0
  101dfc:	6a 00                	push   $0x0
  pushl $19
  101dfe:	6a 13                	push   $0x13
  jmp __alltraps
  101e00:	e9 cc 09 00 00       	jmp    1027d1 <__alltraps>

00101e05 <vector20>:
.globl vector20
vector20:
  pushl $0
  101e05:	6a 00                	push   $0x0
  pushl $20
  101e07:	6a 14                	push   $0x14
  jmp __alltraps
  101e09:	e9 c3 09 00 00       	jmp    1027d1 <__alltraps>

00101e0e <vector21>:
.globl vector21
vector21:
  pushl $0
  101e0e:	6a 00                	push   $0x0
  pushl $21
  101e10:	6a 15                	push   $0x15
  jmp __alltraps
  101e12:	e9 ba 09 00 00       	jmp    1027d1 <__alltraps>

00101e17 <vector22>:
.globl vector22
vector22:
  pushl $0
  101e17:	6a 00                	push   $0x0
  pushl $22
  101e19:	6a 16                	push   $0x16
  jmp __alltraps
  101e1b:	e9 b1 09 00 00       	jmp    1027d1 <__alltraps>

00101e20 <vector23>:
.globl vector23
vector23:
  pushl $0
  101e20:	6a 00                	push   $0x0
  pushl $23
  101e22:	6a 17                	push   $0x17
  jmp __alltraps
  101e24:	e9 a8 09 00 00       	jmp    1027d1 <__alltraps>

00101e29 <vector24>:
.globl vector24
vector24:
  pushl $0
  101e29:	6a 00                	push   $0x0
  pushl $24
  101e2b:	6a 18                	push   $0x18
  jmp __alltraps
  101e2d:	e9 9f 09 00 00       	jmp    1027d1 <__alltraps>

00101e32 <vector25>:
.globl vector25
vector25:
  pushl $0
  101e32:	6a 00                	push   $0x0
  pushl $25
  101e34:	6a 19                	push   $0x19
  jmp __alltraps
  101e36:	e9 96 09 00 00       	jmp    1027d1 <__alltraps>

00101e3b <vector26>:
.globl vector26
vector26:
  pushl $0
  101e3b:	6a 00                	push   $0x0
  pushl $26
  101e3d:	6a 1a                	push   $0x1a
  jmp __alltraps
  101e3f:	e9 8d 09 00 00       	jmp    1027d1 <__alltraps>

00101e44 <vector27>:
.globl vector27
vector27:
  pushl $0
  101e44:	6a 00                	push   $0x0
  pushl $27
  101e46:	6a 1b                	push   $0x1b
  jmp __alltraps
  101e48:	e9 84 09 00 00       	jmp    1027d1 <__alltraps>

00101e4d <vector28>:
.globl vector28
vector28:
  pushl $0
  101e4d:	6a 00                	push   $0x0
  pushl $28
  101e4f:	6a 1c                	push   $0x1c
  jmp __alltraps
  101e51:	e9 7b 09 00 00       	jmp    1027d1 <__alltraps>

00101e56 <vector29>:
.globl vector29
vector29:
  pushl $0
  101e56:	6a 00                	push   $0x0
  pushl $29
  101e58:	6a 1d                	push   $0x1d
  jmp __alltraps
  101e5a:	e9 72 09 00 00       	jmp    1027d1 <__alltraps>

00101e5f <vector30>:
.globl vector30
vector30:
  pushl $0
  101e5f:	6a 00                	push   $0x0
  pushl $30
  101e61:	6a 1e                	push   $0x1e
  jmp __alltraps
  101e63:	e9 69 09 00 00       	jmp    1027d1 <__alltraps>

00101e68 <vector31>:
.globl vector31
vector31:
  pushl $0
  101e68:	6a 00                	push   $0x0
  pushl $31
  101e6a:	6a 1f                	push   $0x1f
  jmp __alltraps
  101e6c:	e9 60 09 00 00       	jmp    1027d1 <__alltraps>

00101e71 <vector32>:
.globl vector32
vector32:
  pushl $0
  101e71:	6a 00                	push   $0x0
  pushl $32
  101e73:	6a 20                	push   $0x20
  jmp __alltraps
  101e75:	e9 57 09 00 00       	jmp    1027d1 <__alltraps>

00101e7a <vector33>:
.globl vector33
vector33:
  pushl $0
  101e7a:	6a 00                	push   $0x0
  pushl $33
  101e7c:	6a 21                	push   $0x21
  jmp __alltraps
  101e7e:	e9 4e 09 00 00       	jmp    1027d1 <__alltraps>

00101e83 <vector34>:
.globl vector34
vector34:
  pushl $0
  101e83:	6a 00                	push   $0x0
  pushl $34
  101e85:	6a 22                	push   $0x22
  jmp __alltraps
  101e87:	e9 45 09 00 00       	jmp    1027d1 <__alltraps>

00101e8c <vector35>:
.globl vector35
vector35:
  pushl $0
  101e8c:	6a 00                	push   $0x0
  pushl $35
  101e8e:	6a 23                	push   $0x23
  jmp __alltraps
  101e90:	e9 3c 09 00 00       	jmp    1027d1 <__alltraps>

00101e95 <vector36>:
.globl vector36
vector36:
  pushl $0
  101e95:	6a 00                	push   $0x0
  pushl $36
  101e97:	6a 24                	push   $0x24
  jmp __alltraps
  101e99:	e9 33 09 00 00       	jmp    1027d1 <__alltraps>

00101e9e <vector37>:
.globl vector37
vector37:
  pushl $0
  101e9e:	6a 00                	push   $0x0
  pushl $37
  101ea0:	6a 25                	push   $0x25
  jmp __alltraps
  101ea2:	e9 2a 09 00 00       	jmp    1027d1 <__alltraps>

00101ea7 <vector38>:
.globl vector38
vector38:
  pushl $0
  101ea7:	6a 00                	push   $0x0
  pushl $38
  101ea9:	6a 26                	push   $0x26
  jmp __alltraps
  101eab:	e9 21 09 00 00       	jmp    1027d1 <__alltraps>

00101eb0 <vector39>:
.globl vector39
vector39:
  pushl $0
  101eb0:	6a 00                	push   $0x0
  pushl $39
  101eb2:	6a 27                	push   $0x27
  jmp __alltraps
  101eb4:	e9 18 09 00 00       	jmp    1027d1 <__alltraps>

00101eb9 <vector40>:
.globl vector40
vector40:
  pushl $0
  101eb9:	6a 00                	push   $0x0
  pushl $40
  101ebb:	6a 28                	push   $0x28
  jmp __alltraps
  101ebd:	e9 0f 09 00 00       	jmp    1027d1 <__alltraps>

00101ec2 <vector41>:
.globl vector41
vector41:
  pushl $0
  101ec2:	6a 00                	push   $0x0
  pushl $41
  101ec4:	6a 29                	push   $0x29
  jmp __alltraps
  101ec6:	e9 06 09 00 00       	jmp    1027d1 <__alltraps>

00101ecb <vector42>:
.globl vector42
vector42:
  pushl $0
  101ecb:	6a 00                	push   $0x0
  pushl $42
  101ecd:	6a 2a                	push   $0x2a
  jmp __alltraps
  101ecf:	e9 fd 08 00 00       	jmp    1027d1 <__alltraps>

00101ed4 <vector43>:
.globl vector43
vector43:
  pushl $0
  101ed4:	6a 00                	push   $0x0
  pushl $43
  101ed6:	6a 2b                	push   $0x2b
  jmp __alltraps
  101ed8:	e9 f4 08 00 00       	jmp    1027d1 <__alltraps>

00101edd <vector44>:
.globl vector44
vector44:
  pushl $0
  101edd:	6a 00                	push   $0x0
  pushl $44
  101edf:	6a 2c                	push   $0x2c
  jmp __alltraps
  101ee1:	e9 eb 08 00 00       	jmp    1027d1 <__alltraps>

00101ee6 <vector45>:
.globl vector45
vector45:
  pushl $0
  101ee6:	6a 00                	push   $0x0
  pushl $45
  101ee8:	6a 2d                	push   $0x2d
  jmp __alltraps
  101eea:	e9 e2 08 00 00       	jmp    1027d1 <__alltraps>

00101eef <vector46>:
.globl vector46
vector46:
  pushl $0
  101eef:	6a 00                	push   $0x0
  pushl $46
  101ef1:	6a 2e                	push   $0x2e
  jmp __alltraps
  101ef3:	e9 d9 08 00 00       	jmp    1027d1 <__alltraps>

00101ef8 <vector47>:
.globl vector47
vector47:
  pushl $0
  101ef8:	6a 00                	push   $0x0
  pushl $47
  101efa:	6a 2f                	push   $0x2f
  jmp __alltraps
  101efc:	e9 d0 08 00 00       	jmp    1027d1 <__alltraps>

00101f01 <vector48>:
.globl vector48
vector48:
  pushl $0
  101f01:	6a 00                	push   $0x0
  pushl $48
  101f03:	6a 30                	push   $0x30
  jmp __alltraps
  101f05:	e9 c7 08 00 00       	jmp    1027d1 <__alltraps>

00101f0a <vector49>:
.globl vector49
vector49:
  pushl $0
  101f0a:	6a 00                	push   $0x0
  pushl $49
  101f0c:	6a 31                	push   $0x31
  jmp __alltraps
  101f0e:	e9 be 08 00 00       	jmp    1027d1 <__alltraps>

00101f13 <vector50>:
.globl vector50
vector50:
  pushl $0
  101f13:	6a 00                	push   $0x0
  pushl $50
  101f15:	6a 32                	push   $0x32
  jmp __alltraps
  101f17:	e9 b5 08 00 00       	jmp    1027d1 <__alltraps>

00101f1c <vector51>:
.globl vector51
vector51:
  pushl $0
  101f1c:	6a 00                	push   $0x0
  pushl $51
  101f1e:	6a 33                	push   $0x33
  jmp __alltraps
  101f20:	e9 ac 08 00 00       	jmp    1027d1 <__alltraps>

00101f25 <vector52>:
.globl vector52
vector52:
  pushl $0
  101f25:	6a 00                	push   $0x0
  pushl $52
  101f27:	6a 34                	push   $0x34
  jmp __alltraps
  101f29:	e9 a3 08 00 00       	jmp    1027d1 <__alltraps>

00101f2e <vector53>:
.globl vector53
vector53:
  pushl $0
  101f2e:	6a 00                	push   $0x0
  pushl $53
  101f30:	6a 35                	push   $0x35
  jmp __alltraps
  101f32:	e9 9a 08 00 00       	jmp    1027d1 <__alltraps>

00101f37 <vector54>:
.globl vector54
vector54:
  pushl $0
  101f37:	6a 00                	push   $0x0
  pushl $54
  101f39:	6a 36                	push   $0x36
  jmp __alltraps
  101f3b:	e9 91 08 00 00       	jmp    1027d1 <__alltraps>

00101f40 <vector55>:
.globl vector55
vector55:
  pushl $0
  101f40:	6a 00                	push   $0x0
  pushl $55
  101f42:	6a 37                	push   $0x37
  jmp __alltraps
  101f44:	e9 88 08 00 00       	jmp    1027d1 <__alltraps>

00101f49 <vector56>:
.globl vector56
vector56:
  pushl $0
  101f49:	6a 00                	push   $0x0
  pushl $56
  101f4b:	6a 38                	push   $0x38
  jmp __alltraps
  101f4d:	e9 7f 08 00 00       	jmp    1027d1 <__alltraps>

00101f52 <vector57>:
.globl vector57
vector57:
  pushl $0
  101f52:	6a 00                	push   $0x0
  pushl $57
  101f54:	6a 39                	push   $0x39
  jmp __alltraps
  101f56:	e9 76 08 00 00       	jmp    1027d1 <__alltraps>

00101f5b <vector58>:
.globl vector58
vector58:
  pushl $0
  101f5b:	6a 00                	push   $0x0
  pushl $58
  101f5d:	6a 3a                	push   $0x3a
  jmp __alltraps
  101f5f:	e9 6d 08 00 00       	jmp    1027d1 <__alltraps>

00101f64 <vector59>:
.globl vector59
vector59:
  pushl $0
  101f64:	6a 00                	push   $0x0
  pushl $59
  101f66:	6a 3b                	push   $0x3b
  jmp __alltraps
  101f68:	e9 64 08 00 00       	jmp    1027d1 <__alltraps>

00101f6d <vector60>:
.globl vector60
vector60:
  pushl $0
  101f6d:	6a 00                	push   $0x0
  pushl $60
  101f6f:	6a 3c                	push   $0x3c
  jmp __alltraps
  101f71:	e9 5b 08 00 00       	jmp    1027d1 <__alltraps>

00101f76 <vector61>:
.globl vector61
vector61:
  pushl $0
  101f76:	6a 00                	push   $0x0
  pushl $61
  101f78:	6a 3d                	push   $0x3d
  jmp __alltraps
  101f7a:	e9 52 08 00 00       	jmp    1027d1 <__alltraps>

00101f7f <vector62>:
.globl vector62
vector62:
  pushl $0
  101f7f:	6a 00                	push   $0x0
  pushl $62
  101f81:	6a 3e                	push   $0x3e
  jmp __alltraps
  101f83:	e9 49 08 00 00       	jmp    1027d1 <__alltraps>

00101f88 <vector63>:
.globl vector63
vector63:
  pushl $0
  101f88:	6a 00                	push   $0x0
  pushl $63
  101f8a:	6a 3f                	push   $0x3f
  jmp __alltraps
  101f8c:	e9 40 08 00 00       	jmp    1027d1 <__alltraps>

00101f91 <vector64>:
.globl vector64
vector64:
  pushl $0
  101f91:	6a 00                	push   $0x0
  pushl $64
  101f93:	6a 40                	push   $0x40
  jmp __alltraps
  101f95:	e9 37 08 00 00       	jmp    1027d1 <__alltraps>

00101f9a <vector65>:
.globl vector65
vector65:
  pushl $0
  101f9a:	6a 00                	push   $0x0
  pushl $65
  101f9c:	6a 41                	push   $0x41
  jmp __alltraps
  101f9e:	e9 2e 08 00 00       	jmp    1027d1 <__alltraps>

00101fa3 <vector66>:
.globl vector66
vector66:
  pushl $0
  101fa3:	6a 00                	push   $0x0
  pushl $66
  101fa5:	6a 42                	push   $0x42
  jmp __alltraps
  101fa7:	e9 25 08 00 00       	jmp    1027d1 <__alltraps>

00101fac <vector67>:
.globl vector67
vector67:
  pushl $0
  101fac:	6a 00                	push   $0x0
  pushl $67
  101fae:	6a 43                	push   $0x43
  jmp __alltraps
  101fb0:	e9 1c 08 00 00       	jmp    1027d1 <__alltraps>

00101fb5 <vector68>:
.globl vector68
vector68:
  pushl $0
  101fb5:	6a 00                	push   $0x0
  pushl $68
  101fb7:	6a 44                	push   $0x44
  jmp __alltraps
  101fb9:	e9 13 08 00 00       	jmp    1027d1 <__alltraps>

00101fbe <vector69>:
.globl vector69
vector69:
  pushl $0
  101fbe:	6a 00                	push   $0x0
  pushl $69
  101fc0:	6a 45                	push   $0x45
  jmp __alltraps
  101fc2:	e9 0a 08 00 00       	jmp    1027d1 <__alltraps>

00101fc7 <vector70>:
.globl vector70
vector70:
  pushl $0
  101fc7:	6a 00                	push   $0x0
  pushl $70
  101fc9:	6a 46                	push   $0x46
  jmp __alltraps
  101fcb:	e9 01 08 00 00       	jmp    1027d1 <__alltraps>

00101fd0 <vector71>:
.globl vector71
vector71:
  pushl $0
  101fd0:	6a 00                	push   $0x0
  pushl $71
  101fd2:	6a 47                	push   $0x47
  jmp __alltraps
  101fd4:	e9 f8 07 00 00       	jmp    1027d1 <__alltraps>

00101fd9 <vector72>:
.globl vector72
vector72:
  pushl $0
  101fd9:	6a 00                	push   $0x0
  pushl $72
  101fdb:	6a 48                	push   $0x48
  jmp __alltraps
  101fdd:	e9 ef 07 00 00       	jmp    1027d1 <__alltraps>

00101fe2 <vector73>:
.globl vector73
vector73:
  pushl $0
  101fe2:	6a 00                	push   $0x0
  pushl $73
  101fe4:	6a 49                	push   $0x49
  jmp __alltraps
  101fe6:	e9 e6 07 00 00       	jmp    1027d1 <__alltraps>

00101feb <vector74>:
.globl vector74
vector74:
  pushl $0
  101feb:	6a 00                	push   $0x0
  pushl $74
  101fed:	6a 4a                	push   $0x4a
  jmp __alltraps
  101fef:	e9 dd 07 00 00       	jmp    1027d1 <__alltraps>

00101ff4 <vector75>:
.globl vector75
vector75:
  pushl $0
  101ff4:	6a 00                	push   $0x0
  pushl $75
  101ff6:	6a 4b                	push   $0x4b
  jmp __alltraps
  101ff8:	e9 d4 07 00 00       	jmp    1027d1 <__alltraps>

00101ffd <vector76>:
.globl vector76
vector76:
  pushl $0
  101ffd:	6a 00                	push   $0x0
  pushl $76
  101fff:	6a 4c                	push   $0x4c
  jmp __alltraps
  102001:	e9 cb 07 00 00       	jmp    1027d1 <__alltraps>

00102006 <vector77>:
.globl vector77
vector77:
  pushl $0
  102006:	6a 00                	push   $0x0
  pushl $77
  102008:	6a 4d                	push   $0x4d
  jmp __alltraps
  10200a:	e9 c2 07 00 00       	jmp    1027d1 <__alltraps>

0010200f <vector78>:
.globl vector78
vector78:
  pushl $0
  10200f:	6a 00                	push   $0x0
  pushl $78
  102011:	6a 4e                	push   $0x4e
  jmp __alltraps
  102013:	e9 b9 07 00 00       	jmp    1027d1 <__alltraps>

00102018 <vector79>:
.globl vector79
vector79:
  pushl $0
  102018:	6a 00                	push   $0x0
  pushl $79
  10201a:	6a 4f                	push   $0x4f
  jmp __alltraps
  10201c:	e9 b0 07 00 00       	jmp    1027d1 <__alltraps>

00102021 <vector80>:
.globl vector80
vector80:
  pushl $0
  102021:	6a 00                	push   $0x0
  pushl $80
  102023:	6a 50                	push   $0x50
  jmp __alltraps
  102025:	e9 a7 07 00 00       	jmp    1027d1 <__alltraps>

0010202a <vector81>:
.globl vector81
vector81:
  pushl $0
  10202a:	6a 00                	push   $0x0
  pushl $81
  10202c:	6a 51                	push   $0x51
  jmp __alltraps
  10202e:	e9 9e 07 00 00       	jmp    1027d1 <__alltraps>

00102033 <vector82>:
.globl vector82
vector82:
  pushl $0
  102033:	6a 00                	push   $0x0
  pushl $82
  102035:	6a 52                	push   $0x52
  jmp __alltraps
  102037:	e9 95 07 00 00       	jmp    1027d1 <__alltraps>

0010203c <vector83>:
.globl vector83
vector83:
  pushl $0
  10203c:	6a 00                	push   $0x0
  pushl $83
  10203e:	6a 53                	push   $0x53
  jmp __alltraps
  102040:	e9 8c 07 00 00       	jmp    1027d1 <__alltraps>

00102045 <vector84>:
.globl vector84
vector84:
  pushl $0
  102045:	6a 00                	push   $0x0
  pushl $84
  102047:	6a 54                	push   $0x54
  jmp __alltraps
  102049:	e9 83 07 00 00       	jmp    1027d1 <__alltraps>

0010204e <vector85>:
.globl vector85
vector85:
  pushl $0
  10204e:	6a 00                	push   $0x0
  pushl $85
  102050:	6a 55                	push   $0x55
  jmp __alltraps
  102052:	e9 7a 07 00 00       	jmp    1027d1 <__alltraps>

00102057 <vector86>:
.globl vector86
vector86:
  pushl $0
  102057:	6a 00                	push   $0x0
  pushl $86
  102059:	6a 56                	push   $0x56
  jmp __alltraps
  10205b:	e9 71 07 00 00       	jmp    1027d1 <__alltraps>

00102060 <vector87>:
.globl vector87
vector87:
  pushl $0
  102060:	6a 00                	push   $0x0
  pushl $87
  102062:	6a 57                	push   $0x57
  jmp __alltraps
  102064:	e9 68 07 00 00       	jmp    1027d1 <__alltraps>

00102069 <vector88>:
.globl vector88
vector88:
  pushl $0
  102069:	6a 00                	push   $0x0
  pushl $88
  10206b:	6a 58                	push   $0x58
  jmp __alltraps
  10206d:	e9 5f 07 00 00       	jmp    1027d1 <__alltraps>

00102072 <vector89>:
.globl vector89
vector89:
  pushl $0
  102072:	6a 00                	push   $0x0
  pushl $89
  102074:	6a 59                	push   $0x59
  jmp __alltraps
  102076:	e9 56 07 00 00       	jmp    1027d1 <__alltraps>

0010207b <vector90>:
.globl vector90
vector90:
  pushl $0
  10207b:	6a 00                	push   $0x0
  pushl $90
  10207d:	6a 5a                	push   $0x5a
  jmp __alltraps
  10207f:	e9 4d 07 00 00       	jmp    1027d1 <__alltraps>

00102084 <vector91>:
.globl vector91
vector91:
  pushl $0
  102084:	6a 00                	push   $0x0
  pushl $91
  102086:	6a 5b                	push   $0x5b
  jmp __alltraps
  102088:	e9 44 07 00 00       	jmp    1027d1 <__alltraps>

0010208d <vector92>:
.globl vector92
vector92:
  pushl $0
  10208d:	6a 00                	push   $0x0
  pushl $92
  10208f:	6a 5c                	push   $0x5c
  jmp __alltraps
  102091:	e9 3b 07 00 00       	jmp    1027d1 <__alltraps>

00102096 <vector93>:
.globl vector93
vector93:
  pushl $0
  102096:	6a 00                	push   $0x0
  pushl $93
  102098:	6a 5d                	push   $0x5d
  jmp __alltraps
  10209a:	e9 32 07 00 00       	jmp    1027d1 <__alltraps>

0010209f <vector94>:
.globl vector94
vector94:
  pushl $0
  10209f:	6a 00                	push   $0x0
  pushl $94
  1020a1:	6a 5e                	push   $0x5e
  jmp __alltraps
  1020a3:	e9 29 07 00 00       	jmp    1027d1 <__alltraps>

001020a8 <vector95>:
.globl vector95
vector95:
  pushl $0
  1020a8:	6a 00                	push   $0x0
  pushl $95
  1020aa:	6a 5f                	push   $0x5f
  jmp __alltraps
  1020ac:	e9 20 07 00 00       	jmp    1027d1 <__alltraps>

001020b1 <vector96>:
.globl vector96
vector96:
  pushl $0
  1020b1:	6a 00                	push   $0x0
  pushl $96
  1020b3:	6a 60                	push   $0x60
  jmp __alltraps
  1020b5:	e9 17 07 00 00       	jmp    1027d1 <__alltraps>

001020ba <vector97>:
.globl vector97
vector97:
  pushl $0
  1020ba:	6a 00                	push   $0x0
  pushl $97
  1020bc:	6a 61                	push   $0x61
  jmp __alltraps
  1020be:	e9 0e 07 00 00       	jmp    1027d1 <__alltraps>

001020c3 <vector98>:
.globl vector98
vector98:
  pushl $0
  1020c3:	6a 00                	push   $0x0
  pushl $98
  1020c5:	6a 62                	push   $0x62
  jmp __alltraps
  1020c7:	e9 05 07 00 00       	jmp    1027d1 <__alltraps>

001020cc <vector99>:
.globl vector99
vector99:
  pushl $0
  1020cc:	6a 00                	push   $0x0
  pushl $99
  1020ce:	6a 63                	push   $0x63
  jmp __alltraps
  1020d0:	e9 fc 06 00 00       	jmp    1027d1 <__alltraps>

001020d5 <vector100>:
.globl vector100
vector100:
  pushl $0
  1020d5:	6a 00                	push   $0x0
  pushl $100
  1020d7:	6a 64                	push   $0x64
  jmp __alltraps
  1020d9:	e9 f3 06 00 00       	jmp    1027d1 <__alltraps>

001020de <vector101>:
.globl vector101
vector101:
  pushl $0
  1020de:	6a 00                	push   $0x0
  pushl $101
  1020e0:	6a 65                	push   $0x65
  jmp __alltraps
  1020e2:	e9 ea 06 00 00       	jmp    1027d1 <__alltraps>

001020e7 <vector102>:
.globl vector102
vector102:
  pushl $0
  1020e7:	6a 00                	push   $0x0
  pushl $102
  1020e9:	6a 66                	push   $0x66
  jmp __alltraps
  1020eb:	e9 e1 06 00 00       	jmp    1027d1 <__alltraps>

001020f0 <vector103>:
.globl vector103
vector103:
  pushl $0
  1020f0:	6a 00                	push   $0x0
  pushl $103
  1020f2:	6a 67                	push   $0x67
  jmp __alltraps
  1020f4:	e9 d8 06 00 00       	jmp    1027d1 <__alltraps>

001020f9 <vector104>:
.globl vector104
vector104:
  pushl $0
  1020f9:	6a 00                	push   $0x0
  pushl $104
  1020fb:	6a 68                	push   $0x68
  jmp __alltraps
  1020fd:	e9 cf 06 00 00       	jmp    1027d1 <__alltraps>

00102102 <vector105>:
.globl vector105
vector105:
  pushl $0
  102102:	6a 00                	push   $0x0
  pushl $105
  102104:	6a 69                	push   $0x69
  jmp __alltraps
  102106:	e9 c6 06 00 00       	jmp    1027d1 <__alltraps>

0010210b <vector106>:
.globl vector106
vector106:
  pushl $0
  10210b:	6a 00                	push   $0x0
  pushl $106
  10210d:	6a 6a                	push   $0x6a
  jmp __alltraps
  10210f:	e9 bd 06 00 00       	jmp    1027d1 <__alltraps>

00102114 <vector107>:
.globl vector107
vector107:
  pushl $0
  102114:	6a 00                	push   $0x0
  pushl $107
  102116:	6a 6b                	push   $0x6b
  jmp __alltraps
  102118:	e9 b4 06 00 00       	jmp    1027d1 <__alltraps>

0010211d <vector108>:
.globl vector108
vector108:
  pushl $0
  10211d:	6a 00                	push   $0x0
  pushl $108
  10211f:	6a 6c                	push   $0x6c
  jmp __alltraps
  102121:	e9 ab 06 00 00       	jmp    1027d1 <__alltraps>

00102126 <vector109>:
.globl vector109
vector109:
  pushl $0
  102126:	6a 00                	push   $0x0
  pushl $109
  102128:	6a 6d                	push   $0x6d
  jmp __alltraps
  10212a:	e9 a2 06 00 00       	jmp    1027d1 <__alltraps>

0010212f <vector110>:
.globl vector110
vector110:
  pushl $0
  10212f:	6a 00                	push   $0x0
  pushl $110
  102131:	6a 6e                	push   $0x6e
  jmp __alltraps
  102133:	e9 99 06 00 00       	jmp    1027d1 <__alltraps>

00102138 <vector111>:
.globl vector111
vector111:
  pushl $0
  102138:	6a 00                	push   $0x0
  pushl $111
  10213a:	6a 6f                	push   $0x6f
  jmp __alltraps
  10213c:	e9 90 06 00 00       	jmp    1027d1 <__alltraps>

00102141 <vector112>:
.globl vector112
vector112:
  pushl $0
  102141:	6a 00                	push   $0x0
  pushl $112
  102143:	6a 70                	push   $0x70
  jmp __alltraps
  102145:	e9 87 06 00 00       	jmp    1027d1 <__alltraps>

0010214a <vector113>:
.globl vector113
vector113:
  pushl $0
  10214a:	6a 00                	push   $0x0
  pushl $113
  10214c:	6a 71                	push   $0x71
  jmp __alltraps
  10214e:	e9 7e 06 00 00       	jmp    1027d1 <__alltraps>

00102153 <vector114>:
.globl vector114
vector114:
  pushl $0
  102153:	6a 00                	push   $0x0
  pushl $114
  102155:	6a 72                	push   $0x72
  jmp __alltraps
  102157:	e9 75 06 00 00       	jmp    1027d1 <__alltraps>

0010215c <vector115>:
.globl vector115
vector115:
  pushl $0
  10215c:	6a 00                	push   $0x0
  pushl $115
  10215e:	6a 73                	push   $0x73
  jmp __alltraps
  102160:	e9 6c 06 00 00       	jmp    1027d1 <__alltraps>

00102165 <vector116>:
.globl vector116
vector116:
  pushl $0
  102165:	6a 00                	push   $0x0
  pushl $116
  102167:	6a 74                	push   $0x74
  jmp __alltraps
  102169:	e9 63 06 00 00       	jmp    1027d1 <__alltraps>

0010216e <vector117>:
.globl vector117
vector117:
  pushl $0
  10216e:	6a 00                	push   $0x0
  pushl $117
  102170:	6a 75                	push   $0x75
  jmp __alltraps
  102172:	e9 5a 06 00 00       	jmp    1027d1 <__alltraps>

00102177 <vector118>:
.globl vector118
vector118:
  pushl $0
  102177:	6a 00                	push   $0x0
  pushl $118
  102179:	6a 76                	push   $0x76
  jmp __alltraps
  10217b:	e9 51 06 00 00       	jmp    1027d1 <__alltraps>

00102180 <vector119>:
.globl vector119
vector119:
  pushl $0
  102180:	6a 00                	push   $0x0
  pushl $119
  102182:	6a 77                	push   $0x77
  jmp __alltraps
  102184:	e9 48 06 00 00       	jmp    1027d1 <__alltraps>

00102189 <vector120>:
.globl vector120
vector120:
  pushl $0
  102189:	6a 00                	push   $0x0
  pushl $120
  10218b:	6a 78                	push   $0x78
  jmp __alltraps
  10218d:	e9 3f 06 00 00       	jmp    1027d1 <__alltraps>

00102192 <vector121>:
.globl vector121
vector121:
  pushl $0
  102192:	6a 00                	push   $0x0
  pushl $121
  102194:	6a 79                	push   $0x79
  jmp __alltraps
  102196:	e9 36 06 00 00       	jmp    1027d1 <__alltraps>

0010219b <vector122>:
.globl vector122
vector122:
  pushl $0
  10219b:	6a 00                	push   $0x0
  pushl $122
  10219d:	6a 7a                	push   $0x7a
  jmp __alltraps
  10219f:	e9 2d 06 00 00       	jmp    1027d1 <__alltraps>

001021a4 <vector123>:
.globl vector123
vector123:
  pushl $0
  1021a4:	6a 00                	push   $0x0
  pushl $123
  1021a6:	6a 7b                	push   $0x7b
  jmp __alltraps
  1021a8:	e9 24 06 00 00       	jmp    1027d1 <__alltraps>

001021ad <vector124>:
.globl vector124
vector124:
  pushl $0
  1021ad:	6a 00                	push   $0x0
  pushl $124
  1021af:	6a 7c                	push   $0x7c
  jmp __alltraps
  1021b1:	e9 1b 06 00 00       	jmp    1027d1 <__alltraps>

001021b6 <vector125>:
.globl vector125
vector125:
  pushl $0
  1021b6:	6a 00                	push   $0x0
  pushl $125
  1021b8:	6a 7d                	push   $0x7d
  jmp __alltraps
  1021ba:	e9 12 06 00 00       	jmp    1027d1 <__alltraps>

001021bf <vector126>:
.globl vector126
vector126:
  pushl $0
  1021bf:	6a 00                	push   $0x0
  pushl $126
  1021c1:	6a 7e                	push   $0x7e
  jmp __alltraps
  1021c3:	e9 09 06 00 00       	jmp    1027d1 <__alltraps>

001021c8 <vector127>:
.globl vector127
vector127:
  pushl $0
  1021c8:	6a 00                	push   $0x0
  pushl $127
  1021ca:	6a 7f                	push   $0x7f
  jmp __alltraps
  1021cc:	e9 00 06 00 00       	jmp    1027d1 <__alltraps>

001021d1 <vector128>:
.globl vector128
vector128:
  pushl $0
  1021d1:	6a 00                	push   $0x0
  pushl $128
  1021d3:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  1021d8:	e9 f4 05 00 00       	jmp    1027d1 <__alltraps>

001021dd <vector129>:
.globl vector129
vector129:
  pushl $0
  1021dd:	6a 00                	push   $0x0
  pushl $129
  1021df:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  1021e4:	e9 e8 05 00 00       	jmp    1027d1 <__alltraps>

001021e9 <vector130>:
.globl vector130
vector130:
  pushl $0
  1021e9:	6a 00                	push   $0x0
  pushl $130
  1021eb:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  1021f0:	e9 dc 05 00 00       	jmp    1027d1 <__alltraps>

001021f5 <vector131>:
.globl vector131
vector131:
  pushl $0
  1021f5:	6a 00                	push   $0x0
  pushl $131
  1021f7:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  1021fc:	e9 d0 05 00 00       	jmp    1027d1 <__alltraps>

00102201 <vector132>:
.globl vector132
vector132:
  pushl $0
  102201:	6a 00                	push   $0x0
  pushl $132
  102203:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  102208:	e9 c4 05 00 00       	jmp    1027d1 <__alltraps>

0010220d <vector133>:
.globl vector133
vector133:
  pushl $0
  10220d:	6a 00                	push   $0x0
  pushl $133
  10220f:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  102214:	e9 b8 05 00 00       	jmp    1027d1 <__alltraps>

00102219 <vector134>:
.globl vector134
vector134:
  pushl $0
  102219:	6a 00                	push   $0x0
  pushl $134
  10221b:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  102220:	e9 ac 05 00 00       	jmp    1027d1 <__alltraps>

00102225 <vector135>:
.globl vector135
vector135:
  pushl $0
  102225:	6a 00                	push   $0x0
  pushl $135
  102227:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  10222c:	e9 a0 05 00 00       	jmp    1027d1 <__alltraps>

00102231 <vector136>:
.globl vector136
vector136:
  pushl $0
  102231:	6a 00                	push   $0x0
  pushl $136
  102233:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  102238:	e9 94 05 00 00       	jmp    1027d1 <__alltraps>

0010223d <vector137>:
.globl vector137
vector137:
  pushl $0
  10223d:	6a 00                	push   $0x0
  pushl $137
  10223f:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  102244:	e9 88 05 00 00       	jmp    1027d1 <__alltraps>

00102249 <vector138>:
.globl vector138
vector138:
  pushl $0
  102249:	6a 00                	push   $0x0
  pushl $138
  10224b:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  102250:	e9 7c 05 00 00       	jmp    1027d1 <__alltraps>

00102255 <vector139>:
.globl vector139
vector139:
  pushl $0
  102255:	6a 00                	push   $0x0
  pushl $139
  102257:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  10225c:	e9 70 05 00 00       	jmp    1027d1 <__alltraps>

00102261 <vector140>:
.globl vector140
vector140:
  pushl $0
  102261:	6a 00                	push   $0x0
  pushl $140
  102263:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  102268:	e9 64 05 00 00       	jmp    1027d1 <__alltraps>

0010226d <vector141>:
.globl vector141
vector141:
  pushl $0
  10226d:	6a 00                	push   $0x0
  pushl $141
  10226f:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  102274:	e9 58 05 00 00       	jmp    1027d1 <__alltraps>

00102279 <vector142>:
.globl vector142
vector142:
  pushl $0
  102279:	6a 00                	push   $0x0
  pushl $142
  10227b:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  102280:	e9 4c 05 00 00       	jmp    1027d1 <__alltraps>

00102285 <vector143>:
.globl vector143
vector143:
  pushl $0
  102285:	6a 00                	push   $0x0
  pushl $143
  102287:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  10228c:	e9 40 05 00 00       	jmp    1027d1 <__alltraps>

00102291 <vector144>:
.globl vector144
vector144:
  pushl $0
  102291:	6a 00                	push   $0x0
  pushl $144
  102293:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  102298:	e9 34 05 00 00       	jmp    1027d1 <__alltraps>

0010229d <vector145>:
.globl vector145
vector145:
  pushl $0
  10229d:	6a 00                	push   $0x0
  pushl $145
  10229f:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  1022a4:	e9 28 05 00 00       	jmp    1027d1 <__alltraps>

001022a9 <vector146>:
.globl vector146
vector146:
  pushl $0
  1022a9:	6a 00                	push   $0x0
  pushl $146
  1022ab:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  1022b0:	e9 1c 05 00 00       	jmp    1027d1 <__alltraps>

001022b5 <vector147>:
.globl vector147
vector147:
  pushl $0
  1022b5:	6a 00                	push   $0x0
  pushl $147
  1022b7:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  1022bc:	e9 10 05 00 00       	jmp    1027d1 <__alltraps>

001022c1 <vector148>:
.globl vector148
vector148:
  pushl $0
  1022c1:	6a 00                	push   $0x0
  pushl $148
  1022c3:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  1022c8:	e9 04 05 00 00       	jmp    1027d1 <__alltraps>

001022cd <vector149>:
.globl vector149
vector149:
  pushl $0
  1022cd:	6a 00                	push   $0x0
  pushl $149
  1022cf:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  1022d4:	e9 f8 04 00 00       	jmp    1027d1 <__alltraps>

001022d9 <vector150>:
.globl vector150
vector150:
  pushl $0
  1022d9:	6a 00                	push   $0x0
  pushl $150
  1022db:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  1022e0:	e9 ec 04 00 00       	jmp    1027d1 <__alltraps>

001022e5 <vector151>:
.globl vector151
vector151:
  pushl $0
  1022e5:	6a 00                	push   $0x0
  pushl $151
  1022e7:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  1022ec:	e9 e0 04 00 00       	jmp    1027d1 <__alltraps>

001022f1 <vector152>:
.globl vector152
vector152:
  pushl $0
  1022f1:	6a 00                	push   $0x0
  pushl $152
  1022f3:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  1022f8:	e9 d4 04 00 00       	jmp    1027d1 <__alltraps>

001022fd <vector153>:
.globl vector153
vector153:
  pushl $0
  1022fd:	6a 00                	push   $0x0
  pushl $153
  1022ff:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  102304:	e9 c8 04 00 00       	jmp    1027d1 <__alltraps>

00102309 <vector154>:
.globl vector154
vector154:
  pushl $0
  102309:	6a 00                	push   $0x0
  pushl $154
  10230b:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  102310:	e9 bc 04 00 00       	jmp    1027d1 <__alltraps>

00102315 <vector155>:
.globl vector155
vector155:
  pushl $0
  102315:	6a 00                	push   $0x0
  pushl $155
  102317:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  10231c:	e9 b0 04 00 00       	jmp    1027d1 <__alltraps>

00102321 <vector156>:
.globl vector156
vector156:
  pushl $0
  102321:	6a 00                	push   $0x0
  pushl $156
  102323:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  102328:	e9 a4 04 00 00       	jmp    1027d1 <__alltraps>

0010232d <vector157>:
.globl vector157
vector157:
  pushl $0
  10232d:	6a 00                	push   $0x0
  pushl $157
  10232f:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  102334:	e9 98 04 00 00       	jmp    1027d1 <__alltraps>

00102339 <vector158>:
.globl vector158
vector158:
  pushl $0
  102339:	6a 00                	push   $0x0
  pushl $158
  10233b:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  102340:	e9 8c 04 00 00       	jmp    1027d1 <__alltraps>

00102345 <vector159>:
.globl vector159
vector159:
  pushl $0
  102345:	6a 00                	push   $0x0
  pushl $159
  102347:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  10234c:	e9 80 04 00 00       	jmp    1027d1 <__alltraps>

00102351 <vector160>:
.globl vector160
vector160:
  pushl $0
  102351:	6a 00                	push   $0x0
  pushl $160
  102353:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  102358:	e9 74 04 00 00       	jmp    1027d1 <__alltraps>

0010235d <vector161>:
.globl vector161
vector161:
  pushl $0
  10235d:	6a 00                	push   $0x0
  pushl $161
  10235f:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  102364:	e9 68 04 00 00       	jmp    1027d1 <__alltraps>

00102369 <vector162>:
.globl vector162
vector162:
  pushl $0
  102369:	6a 00                	push   $0x0
  pushl $162
  10236b:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  102370:	e9 5c 04 00 00       	jmp    1027d1 <__alltraps>

00102375 <vector163>:
.globl vector163
vector163:
  pushl $0
  102375:	6a 00                	push   $0x0
  pushl $163
  102377:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  10237c:	e9 50 04 00 00       	jmp    1027d1 <__alltraps>

00102381 <vector164>:
.globl vector164
vector164:
  pushl $0
  102381:	6a 00                	push   $0x0
  pushl $164
  102383:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  102388:	e9 44 04 00 00       	jmp    1027d1 <__alltraps>

0010238d <vector165>:
.globl vector165
vector165:
  pushl $0
  10238d:	6a 00                	push   $0x0
  pushl $165
  10238f:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  102394:	e9 38 04 00 00       	jmp    1027d1 <__alltraps>

00102399 <vector166>:
.globl vector166
vector166:
  pushl $0
  102399:	6a 00                	push   $0x0
  pushl $166
  10239b:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  1023a0:	e9 2c 04 00 00       	jmp    1027d1 <__alltraps>

001023a5 <vector167>:
.globl vector167
vector167:
  pushl $0
  1023a5:	6a 00                	push   $0x0
  pushl $167
  1023a7:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  1023ac:	e9 20 04 00 00       	jmp    1027d1 <__alltraps>

001023b1 <vector168>:
.globl vector168
vector168:
  pushl $0
  1023b1:	6a 00                	push   $0x0
  pushl $168
  1023b3:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  1023b8:	e9 14 04 00 00       	jmp    1027d1 <__alltraps>

001023bd <vector169>:
.globl vector169
vector169:
  pushl $0
  1023bd:	6a 00                	push   $0x0
  pushl $169
  1023bf:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  1023c4:	e9 08 04 00 00       	jmp    1027d1 <__alltraps>

001023c9 <vector170>:
.globl vector170
vector170:
  pushl $0
  1023c9:	6a 00                	push   $0x0
  pushl $170
  1023cb:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  1023d0:	e9 fc 03 00 00       	jmp    1027d1 <__alltraps>

001023d5 <vector171>:
.globl vector171
vector171:
  pushl $0
  1023d5:	6a 00                	push   $0x0
  pushl $171
  1023d7:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  1023dc:	e9 f0 03 00 00       	jmp    1027d1 <__alltraps>

001023e1 <vector172>:
.globl vector172
vector172:
  pushl $0
  1023e1:	6a 00                	push   $0x0
  pushl $172
  1023e3:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  1023e8:	e9 e4 03 00 00       	jmp    1027d1 <__alltraps>

001023ed <vector173>:
.globl vector173
vector173:
  pushl $0
  1023ed:	6a 00                	push   $0x0
  pushl $173
  1023ef:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  1023f4:	e9 d8 03 00 00       	jmp    1027d1 <__alltraps>

001023f9 <vector174>:
.globl vector174
vector174:
  pushl $0
  1023f9:	6a 00                	push   $0x0
  pushl $174
  1023fb:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  102400:	e9 cc 03 00 00       	jmp    1027d1 <__alltraps>

00102405 <vector175>:
.globl vector175
vector175:
  pushl $0
  102405:	6a 00                	push   $0x0
  pushl $175
  102407:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  10240c:	e9 c0 03 00 00       	jmp    1027d1 <__alltraps>

00102411 <vector176>:
.globl vector176
vector176:
  pushl $0
  102411:	6a 00                	push   $0x0
  pushl $176
  102413:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  102418:	e9 b4 03 00 00       	jmp    1027d1 <__alltraps>

0010241d <vector177>:
.globl vector177
vector177:
  pushl $0
  10241d:	6a 00                	push   $0x0
  pushl $177
  10241f:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  102424:	e9 a8 03 00 00       	jmp    1027d1 <__alltraps>

00102429 <vector178>:
.globl vector178
vector178:
  pushl $0
  102429:	6a 00                	push   $0x0
  pushl $178
  10242b:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  102430:	e9 9c 03 00 00       	jmp    1027d1 <__alltraps>

00102435 <vector179>:
.globl vector179
vector179:
  pushl $0
  102435:	6a 00                	push   $0x0
  pushl $179
  102437:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  10243c:	e9 90 03 00 00       	jmp    1027d1 <__alltraps>

00102441 <vector180>:
.globl vector180
vector180:
  pushl $0
  102441:	6a 00                	push   $0x0
  pushl $180
  102443:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  102448:	e9 84 03 00 00       	jmp    1027d1 <__alltraps>

0010244d <vector181>:
.globl vector181
vector181:
  pushl $0
  10244d:	6a 00                	push   $0x0
  pushl $181
  10244f:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  102454:	e9 78 03 00 00       	jmp    1027d1 <__alltraps>

00102459 <vector182>:
.globl vector182
vector182:
  pushl $0
  102459:	6a 00                	push   $0x0
  pushl $182
  10245b:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  102460:	e9 6c 03 00 00       	jmp    1027d1 <__alltraps>

00102465 <vector183>:
.globl vector183
vector183:
  pushl $0
  102465:	6a 00                	push   $0x0
  pushl $183
  102467:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  10246c:	e9 60 03 00 00       	jmp    1027d1 <__alltraps>

00102471 <vector184>:
.globl vector184
vector184:
  pushl $0
  102471:	6a 00                	push   $0x0
  pushl $184
  102473:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  102478:	e9 54 03 00 00       	jmp    1027d1 <__alltraps>

0010247d <vector185>:
.globl vector185
vector185:
  pushl $0
  10247d:	6a 00                	push   $0x0
  pushl $185
  10247f:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  102484:	e9 48 03 00 00       	jmp    1027d1 <__alltraps>

00102489 <vector186>:
.globl vector186
vector186:
  pushl $0
  102489:	6a 00                	push   $0x0
  pushl $186
  10248b:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  102490:	e9 3c 03 00 00       	jmp    1027d1 <__alltraps>

00102495 <vector187>:
.globl vector187
vector187:
  pushl $0
  102495:	6a 00                	push   $0x0
  pushl $187
  102497:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  10249c:	e9 30 03 00 00       	jmp    1027d1 <__alltraps>

001024a1 <vector188>:
.globl vector188
vector188:
  pushl $0
  1024a1:	6a 00                	push   $0x0
  pushl $188
  1024a3:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  1024a8:	e9 24 03 00 00       	jmp    1027d1 <__alltraps>

001024ad <vector189>:
.globl vector189
vector189:
  pushl $0
  1024ad:	6a 00                	push   $0x0
  pushl $189
  1024af:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  1024b4:	e9 18 03 00 00       	jmp    1027d1 <__alltraps>

001024b9 <vector190>:
.globl vector190
vector190:
  pushl $0
  1024b9:	6a 00                	push   $0x0
  pushl $190
  1024bb:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  1024c0:	e9 0c 03 00 00       	jmp    1027d1 <__alltraps>

001024c5 <vector191>:
.globl vector191
vector191:
  pushl $0
  1024c5:	6a 00                	push   $0x0
  pushl $191
  1024c7:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  1024cc:	e9 00 03 00 00       	jmp    1027d1 <__alltraps>

001024d1 <vector192>:
.globl vector192
vector192:
  pushl $0
  1024d1:	6a 00                	push   $0x0
  pushl $192
  1024d3:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  1024d8:	e9 f4 02 00 00       	jmp    1027d1 <__alltraps>

001024dd <vector193>:
.globl vector193
vector193:
  pushl $0
  1024dd:	6a 00                	push   $0x0
  pushl $193
  1024df:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  1024e4:	e9 e8 02 00 00       	jmp    1027d1 <__alltraps>

001024e9 <vector194>:
.globl vector194
vector194:
  pushl $0
  1024e9:	6a 00                	push   $0x0
  pushl $194
  1024eb:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  1024f0:	e9 dc 02 00 00       	jmp    1027d1 <__alltraps>

001024f5 <vector195>:
.globl vector195
vector195:
  pushl $0
  1024f5:	6a 00                	push   $0x0
  pushl $195
  1024f7:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  1024fc:	e9 d0 02 00 00       	jmp    1027d1 <__alltraps>

00102501 <vector196>:
.globl vector196
vector196:
  pushl $0
  102501:	6a 00                	push   $0x0
  pushl $196
  102503:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  102508:	e9 c4 02 00 00       	jmp    1027d1 <__alltraps>

0010250d <vector197>:
.globl vector197
vector197:
  pushl $0
  10250d:	6a 00                	push   $0x0
  pushl $197
  10250f:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102514:	e9 b8 02 00 00       	jmp    1027d1 <__alltraps>

00102519 <vector198>:
.globl vector198
vector198:
  pushl $0
  102519:	6a 00                	push   $0x0
  pushl $198
  10251b:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  102520:	e9 ac 02 00 00       	jmp    1027d1 <__alltraps>

00102525 <vector199>:
.globl vector199
vector199:
  pushl $0
  102525:	6a 00                	push   $0x0
  pushl $199
  102527:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  10252c:	e9 a0 02 00 00       	jmp    1027d1 <__alltraps>

00102531 <vector200>:
.globl vector200
vector200:
  pushl $0
  102531:	6a 00                	push   $0x0
  pushl $200
  102533:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  102538:	e9 94 02 00 00       	jmp    1027d1 <__alltraps>

0010253d <vector201>:
.globl vector201
vector201:
  pushl $0
  10253d:	6a 00                	push   $0x0
  pushl $201
  10253f:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  102544:	e9 88 02 00 00       	jmp    1027d1 <__alltraps>

00102549 <vector202>:
.globl vector202
vector202:
  pushl $0
  102549:	6a 00                	push   $0x0
  pushl $202
  10254b:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  102550:	e9 7c 02 00 00       	jmp    1027d1 <__alltraps>

00102555 <vector203>:
.globl vector203
vector203:
  pushl $0
  102555:	6a 00                	push   $0x0
  pushl $203
  102557:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  10255c:	e9 70 02 00 00       	jmp    1027d1 <__alltraps>

00102561 <vector204>:
.globl vector204
vector204:
  pushl $0
  102561:	6a 00                	push   $0x0
  pushl $204
  102563:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  102568:	e9 64 02 00 00       	jmp    1027d1 <__alltraps>

0010256d <vector205>:
.globl vector205
vector205:
  pushl $0
  10256d:	6a 00                	push   $0x0
  pushl $205
  10256f:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  102574:	e9 58 02 00 00       	jmp    1027d1 <__alltraps>

00102579 <vector206>:
.globl vector206
vector206:
  pushl $0
  102579:	6a 00                	push   $0x0
  pushl $206
  10257b:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  102580:	e9 4c 02 00 00       	jmp    1027d1 <__alltraps>

00102585 <vector207>:
.globl vector207
vector207:
  pushl $0
  102585:	6a 00                	push   $0x0
  pushl $207
  102587:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  10258c:	e9 40 02 00 00       	jmp    1027d1 <__alltraps>

00102591 <vector208>:
.globl vector208
vector208:
  pushl $0
  102591:	6a 00                	push   $0x0
  pushl $208
  102593:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  102598:	e9 34 02 00 00       	jmp    1027d1 <__alltraps>

0010259d <vector209>:
.globl vector209
vector209:
  pushl $0
  10259d:	6a 00                	push   $0x0
  pushl $209
  10259f:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  1025a4:	e9 28 02 00 00       	jmp    1027d1 <__alltraps>

001025a9 <vector210>:
.globl vector210
vector210:
  pushl $0
  1025a9:	6a 00                	push   $0x0
  pushl $210
  1025ab:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  1025b0:	e9 1c 02 00 00       	jmp    1027d1 <__alltraps>

001025b5 <vector211>:
.globl vector211
vector211:
  pushl $0
  1025b5:	6a 00                	push   $0x0
  pushl $211
  1025b7:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  1025bc:	e9 10 02 00 00       	jmp    1027d1 <__alltraps>

001025c1 <vector212>:
.globl vector212
vector212:
  pushl $0
  1025c1:	6a 00                	push   $0x0
  pushl $212
  1025c3:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  1025c8:	e9 04 02 00 00       	jmp    1027d1 <__alltraps>

001025cd <vector213>:
.globl vector213
vector213:
  pushl $0
  1025cd:	6a 00                	push   $0x0
  pushl $213
  1025cf:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  1025d4:	e9 f8 01 00 00       	jmp    1027d1 <__alltraps>

001025d9 <vector214>:
.globl vector214
vector214:
  pushl $0
  1025d9:	6a 00                	push   $0x0
  pushl $214
  1025db:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  1025e0:	e9 ec 01 00 00       	jmp    1027d1 <__alltraps>

001025e5 <vector215>:
.globl vector215
vector215:
  pushl $0
  1025e5:	6a 00                	push   $0x0
  pushl $215
  1025e7:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  1025ec:	e9 e0 01 00 00       	jmp    1027d1 <__alltraps>

001025f1 <vector216>:
.globl vector216
vector216:
  pushl $0
  1025f1:	6a 00                	push   $0x0
  pushl $216
  1025f3:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  1025f8:	e9 d4 01 00 00       	jmp    1027d1 <__alltraps>

001025fd <vector217>:
.globl vector217
vector217:
  pushl $0
  1025fd:	6a 00                	push   $0x0
  pushl $217
  1025ff:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102604:	e9 c8 01 00 00       	jmp    1027d1 <__alltraps>

00102609 <vector218>:
.globl vector218
vector218:
  pushl $0
  102609:	6a 00                	push   $0x0
  pushl $218
  10260b:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  102610:	e9 bc 01 00 00       	jmp    1027d1 <__alltraps>

00102615 <vector219>:
.globl vector219
vector219:
  pushl $0
  102615:	6a 00                	push   $0x0
  pushl $219
  102617:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  10261c:	e9 b0 01 00 00       	jmp    1027d1 <__alltraps>

00102621 <vector220>:
.globl vector220
vector220:
  pushl $0
  102621:	6a 00                	push   $0x0
  pushl $220
  102623:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  102628:	e9 a4 01 00 00       	jmp    1027d1 <__alltraps>

0010262d <vector221>:
.globl vector221
vector221:
  pushl $0
  10262d:	6a 00                	push   $0x0
  pushl $221
  10262f:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  102634:	e9 98 01 00 00       	jmp    1027d1 <__alltraps>

00102639 <vector222>:
.globl vector222
vector222:
  pushl $0
  102639:	6a 00                	push   $0x0
  pushl $222
  10263b:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  102640:	e9 8c 01 00 00       	jmp    1027d1 <__alltraps>

00102645 <vector223>:
.globl vector223
vector223:
  pushl $0
  102645:	6a 00                	push   $0x0
  pushl $223
  102647:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  10264c:	e9 80 01 00 00       	jmp    1027d1 <__alltraps>

00102651 <vector224>:
.globl vector224
vector224:
  pushl $0
  102651:	6a 00                	push   $0x0
  pushl $224
  102653:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  102658:	e9 74 01 00 00       	jmp    1027d1 <__alltraps>

0010265d <vector225>:
.globl vector225
vector225:
  pushl $0
  10265d:	6a 00                	push   $0x0
  pushl $225
  10265f:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  102664:	e9 68 01 00 00       	jmp    1027d1 <__alltraps>

00102669 <vector226>:
.globl vector226
vector226:
  pushl $0
  102669:	6a 00                	push   $0x0
  pushl $226
  10266b:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  102670:	e9 5c 01 00 00       	jmp    1027d1 <__alltraps>

00102675 <vector227>:
.globl vector227
vector227:
  pushl $0
  102675:	6a 00                	push   $0x0
  pushl $227
  102677:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  10267c:	e9 50 01 00 00       	jmp    1027d1 <__alltraps>

00102681 <vector228>:
.globl vector228
vector228:
  pushl $0
  102681:	6a 00                	push   $0x0
  pushl $228
  102683:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  102688:	e9 44 01 00 00       	jmp    1027d1 <__alltraps>

0010268d <vector229>:
.globl vector229
vector229:
  pushl $0
  10268d:	6a 00                	push   $0x0
  pushl $229
  10268f:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  102694:	e9 38 01 00 00       	jmp    1027d1 <__alltraps>

00102699 <vector230>:
.globl vector230
vector230:
  pushl $0
  102699:	6a 00                	push   $0x0
  pushl $230
  10269b:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  1026a0:	e9 2c 01 00 00       	jmp    1027d1 <__alltraps>

001026a5 <vector231>:
.globl vector231
vector231:
  pushl $0
  1026a5:	6a 00                	push   $0x0
  pushl $231
  1026a7:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  1026ac:	e9 20 01 00 00       	jmp    1027d1 <__alltraps>

001026b1 <vector232>:
.globl vector232
vector232:
  pushl $0
  1026b1:	6a 00                	push   $0x0
  pushl $232
  1026b3:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  1026b8:	e9 14 01 00 00       	jmp    1027d1 <__alltraps>

001026bd <vector233>:
.globl vector233
vector233:
  pushl $0
  1026bd:	6a 00                	push   $0x0
  pushl $233
  1026bf:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  1026c4:	e9 08 01 00 00       	jmp    1027d1 <__alltraps>

001026c9 <vector234>:
.globl vector234
vector234:
  pushl $0
  1026c9:	6a 00                	push   $0x0
  pushl $234
  1026cb:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  1026d0:	e9 fc 00 00 00       	jmp    1027d1 <__alltraps>

001026d5 <vector235>:
.globl vector235
vector235:
  pushl $0
  1026d5:	6a 00                	push   $0x0
  pushl $235
  1026d7:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  1026dc:	e9 f0 00 00 00       	jmp    1027d1 <__alltraps>

001026e1 <vector236>:
.globl vector236
vector236:
  pushl $0
  1026e1:	6a 00                	push   $0x0
  pushl $236
  1026e3:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  1026e8:	e9 e4 00 00 00       	jmp    1027d1 <__alltraps>

001026ed <vector237>:
.globl vector237
vector237:
  pushl $0
  1026ed:	6a 00                	push   $0x0
  pushl $237
  1026ef:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  1026f4:	e9 d8 00 00 00       	jmp    1027d1 <__alltraps>

001026f9 <vector238>:
.globl vector238
vector238:
  pushl $0
  1026f9:	6a 00                	push   $0x0
  pushl $238
  1026fb:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  102700:	e9 cc 00 00 00       	jmp    1027d1 <__alltraps>

00102705 <vector239>:
.globl vector239
vector239:
  pushl $0
  102705:	6a 00                	push   $0x0
  pushl $239
  102707:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  10270c:	e9 c0 00 00 00       	jmp    1027d1 <__alltraps>

00102711 <vector240>:
.globl vector240
vector240:
  pushl $0
  102711:	6a 00                	push   $0x0
  pushl $240
  102713:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102718:	e9 b4 00 00 00       	jmp    1027d1 <__alltraps>

0010271d <vector241>:
.globl vector241
vector241:
  pushl $0
  10271d:	6a 00                	push   $0x0
  pushl $241
  10271f:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102724:	e9 a8 00 00 00       	jmp    1027d1 <__alltraps>

00102729 <vector242>:
.globl vector242
vector242:
  pushl $0
  102729:	6a 00                	push   $0x0
  pushl $242
  10272b:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  102730:	e9 9c 00 00 00       	jmp    1027d1 <__alltraps>

00102735 <vector243>:
.globl vector243
vector243:
  pushl $0
  102735:	6a 00                	push   $0x0
  pushl $243
  102737:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  10273c:	e9 90 00 00 00       	jmp    1027d1 <__alltraps>

00102741 <vector244>:
.globl vector244
vector244:
  pushl $0
  102741:	6a 00                	push   $0x0
  pushl $244
  102743:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  102748:	e9 84 00 00 00       	jmp    1027d1 <__alltraps>

0010274d <vector245>:
.globl vector245
vector245:
  pushl $0
  10274d:	6a 00                	push   $0x0
  pushl $245
  10274f:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  102754:	e9 78 00 00 00       	jmp    1027d1 <__alltraps>

00102759 <vector246>:
.globl vector246
vector246:
  pushl $0
  102759:	6a 00                	push   $0x0
  pushl $246
  10275b:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  102760:	e9 6c 00 00 00       	jmp    1027d1 <__alltraps>

00102765 <vector247>:
.globl vector247
vector247:
  pushl $0
  102765:	6a 00                	push   $0x0
  pushl $247
  102767:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  10276c:	e9 60 00 00 00       	jmp    1027d1 <__alltraps>

00102771 <vector248>:
.globl vector248
vector248:
  pushl $0
  102771:	6a 00                	push   $0x0
  pushl $248
  102773:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  102778:	e9 54 00 00 00       	jmp    1027d1 <__alltraps>

0010277d <vector249>:
.globl vector249
vector249:
  pushl $0
  10277d:	6a 00                	push   $0x0
  pushl $249
  10277f:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102784:	e9 48 00 00 00       	jmp    1027d1 <__alltraps>

00102789 <vector250>:
.globl vector250
vector250:
  pushl $0
  102789:	6a 00                	push   $0x0
  pushl $250
  10278b:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  102790:	e9 3c 00 00 00       	jmp    1027d1 <__alltraps>

00102795 <vector251>:
.globl vector251
vector251:
  pushl $0
  102795:	6a 00                	push   $0x0
  pushl $251
  102797:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  10279c:	e9 30 00 00 00       	jmp    1027d1 <__alltraps>

001027a1 <vector252>:
.globl vector252
vector252:
  pushl $0
  1027a1:	6a 00                	push   $0x0
  pushl $252
  1027a3:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  1027a8:	e9 24 00 00 00       	jmp    1027d1 <__alltraps>

001027ad <vector253>:
.globl vector253
vector253:
  pushl $0
  1027ad:	6a 00                	push   $0x0
  pushl $253
  1027af:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  1027b4:	e9 18 00 00 00       	jmp    1027d1 <__alltraps>

001027b9 <vector254>:
.globl vector254
vector254:
  pushl $0
  1027b9:	6a 00                	push   $0x0
  pushl $254
  1027bb:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  1027c0:	e9 0c 00 00 00       	jmp    1027d1 <__alltraps>

001027c5 <vector255>:
.globl vector255
vector255:
  pushl $0
  1027c5:	6a 00                	push   $0x0
  pushl $255
  1027c7:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  1027cc:	e9 00 00 00 00       	jmp    1027d1 <__alltraps>

001027d1 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  1027d1:	1e                   	push   %ds
    pushl %es
  1027d2:	06                   	push   %es
    pushl %fs
  1027d3:	0f a0                	push   %fs
    pushl %gs
  1027d5:	0f a8                	push   %gs
    pushal
  1027d7:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  1027d8:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  1027dd:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  1027df:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  1027e1:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  1027e2:	e8 63 f5 ff ff       	call   101d4a <trap>

    # pop the pushed stack pointer
    popl %esp
  1027e7:	5c                   	pop    %esp

001027e8 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  1027e8:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  1027e9:	0f a9                	pop    %gs
    popl %fs
  1027eb:	0f a1                	pop    %fs
    popl %es
  1027ed:	07                   	pop    %es
    popl %ds
  1027ee:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  1027ef:	83 c4 08             	add    $0x8,%esp
    iret
  1027f2:	cf                   	iret   

001027f3 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  1027f3:	55                   	push   %ebp
  1027f4:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  1027f6:	8b 45 08             	mov    0x8(%ebp),%eax
  1027f9:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  1027fc:	b8 23 00 00 00       	mov    $0x23,%eax
  102801:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  102803:	b8 23 00 00 00       	mov    $0x23,%eax
  102808:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  10280a:	b8 10 00 00 00       	mov    $0x10,%eax
  10280f:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102811:	b8 10 00 00 00       	mov    $0x10,%eax
  102816:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102818:	b8 10 00 00 00       	mov    $0x10,%eax
  10281d:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  10281f:	ea 26 28 10 00 08 00 	ljmp   $0x8,$0x102826
}
  102826:	90                   	nop
  102827:	5d                   	pop    %ebp
  102828:	c3                   	ret    

00102829 <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102829:	55                   	push   %ebp
  10282a:	89 e5                	mov    %esp,%ebp
  10282c:	83 ec 10             	sub    $0x10,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  10282f:	b8 20 f9 10 00       	mov    $0x10f920,%eax
  102834:	05 00 04 00 00       	add    $0x400,%eax
  102839:	a3 a4 f8 10 00       	mov    %eax,0x10f8a4
    ts.ts_ss0 = KERNEL_DS;
  10283e:	66 c7 05 a8 f8 10 00 	movw   $0x10,0x10f8a8
  102845:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  102847:	66 c7 05 08 ea 10 00 	movw   $0x68,0x10ea08
  10284e:	68 00 
  102850:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  102855:	66 a3 0a ea 10 00    	mov    %ax,0x10ea0a
  10285b:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  102860:	c1 e8 10             	shr    $0x10,%eax
  102863:	a2 0c ea 10 00       	mov    %al,0x10ea0c
  102868:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  10286f:	83 e0 f0             	and    $0xfffffff0,%eax
  102872:	83 c8 09             	or     $0x9,%eax
  102875:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  10287a:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102881:	83 c8 10             	or     $0x10,%eax
  102884:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102889:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102890:	83 e0 9f             	and    $0xffffff9f,%eax
  102893:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102898:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  10289f:	83 c8 80             	or     $0xffffff80,%eax
  1028a2:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1028a7:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1028ae:	83 e0 f0             	and    $0xfffffff0,%eax
  1028b1:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  1028b6:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1028bd:	83 e0 ef             	and    $0xffffffef,%eax
  1028c0:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  1028c5:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1028cc:	83 e0 df             	and    $0xffffffdf,%eax
  1028cf:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  1028d4:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1028db:	83 c8 40             	or     $0x40,%eax
  1028de:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  1028e3:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1028ea:	83 e0 7f             	and    $0x7f,%eax
  1028ed:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  1028f2:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  1028f7:	c1 e8 18             	shr    $0x18,%eax
  1028fa:	a2 0f ea 10 00       	mov    %al,0x10ea0f
    gdt[SEG_TSS].sd_s = 0;
  1028ff:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102906:	83 e0 ef             	and    $0xffffffef,%eax
  102909:	a2 0d ea 10 00       	mov    %al,0x10ea0d

    // reload all segment registers
    lgdt(&gdt_pd);
  10290e:	68 10 ea 10 00       	push   $0x10ea10
  102913:	e8 db fe ff ff       	call   1027f3 <lgdt>
  102918:	83 c4 04             	add    $0x4,%esp
  10291b:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  102921:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102925:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  102928:	90                   	nop
  102929:	c9                   	leave  
  10292a:	c3                   	ret    

0010292b <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  10292b:	55                   	push   %ebp
  10292c:	89 e5                	mov    %esp,%ebp
    gdt_init();
  10292e:	e8 f6 fe ff ff       	call   102829 <gdt_init>
}
  102933:	90                   	nop
  102934:	5d                   	pop    %ebp
  102935:	c3                   	ret    

00102936 <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  102936:	55                   	push   %ebp
  102937:	89 e5                	mov    %esp,%ebp
  102939:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  10293c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  102943:	eb 04                	jmp    102949 <strlen+0x13>
        cnt ++;
  102945:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  102949:	8b 45 08             	mov    0x8(%ebp),%eax
  10294c:	8d 50 01             	lea    0x1(%eax),%edx
  10294f:	89 55 08             	mov    %edx,0x8(%ebp)
  102952:	0f b6 00             	movzbl (%eax),%eax
  102955:	84 c0                	test   %al,%al
  102957:	75 ec                	jne    102945 <strlen+0xf>
        cnt ++;
    }
    return cnt;
  102959:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10295c:	c9                   	leave  
  10295d:	c3                   	ret    

0010295e <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  10295e:	55                   	push   %ebp
  10295f:	89 e5                	mov    %esp,%ebp
  102961:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102964:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  10296b:	eb 04                	jmp    102971 <strnlen+0x13>
        cnt ++;
  10296d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  102971:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102974:	3b 45 0c             	cmp    0xc(%ebp),%eax
  102977:	73 10                	jae    102989 <strnlen+0x2b>
  102979:	8b 45 08             	mov    0x8(%ebp),%eax
  10297c:	8d 50 01             	lea    0x1(%eax),%edx
  10297f:	89 55 08             	mov    %edx,0x8(%ebp)
  102982:	0f b6 00             	movzbl (%eax),%eax
  102985:	84 c0                	test   %al,%al
  102987:	75 e4                	jne    10296d <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  102989:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10298c:	c9                   	leave  
  10298d:	c3                   	ret    

0010298e <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  10298e:	55                   	push   %ebp
  10298f:	89 e5                	mov    %esp,%ebp
  102991:	57                   	push   %edi
  102992:	56                   	push   %esi
  102993:	83 ec 20             	sub    $0x20,%esp
  102996:	8b 45 08             	mov    0x8(%ebp),%eax
  102999:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10299c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10299f:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  1029a2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1029a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029a8:	89 d1                	mov    %edx,%ecx
  1029aa:	89 c2                	mov    %eax,%edx
  1029ac:	89 ce                	mov    %ecx,%esi
  1029ae:	89 d7                	mov    %edx,%edi
  1029b0:	ac                   	lods   %ds:(%esi),%al
  1029b1:	aa                   	stos   %al,%es:(%edi)
  1029b2:	84 c0                	test   %al,%al
  1029b4:	75 fa                	jne    1029b0 <strcpy+0x22>
  1029b6:	89 fa                	mov    %edi,%edx
  1029b8:	89 f1                	mov    %esi,%ecx
  1029ba:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  1029bd:	89 55 e8             	mov    %edx,-0x18(%ebp)
  1029c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  1029c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
  1029c6:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  1029c7:	83 c4 20             	add    $0x20,%esp
  1029ca:	5e                   	pop    %esi
  1029cb:	5f                   	pop    %edi
  1029cc:	5d                   	pop    %ebp
  1029cd:	c3                   	ret    

001029ce <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  1029ce:	55                   	push   %ebp
  1029cf:	89 e5                	mov    %esp,%ebp
  1029d1:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  1029d4:	8b 45 08             	mov    0x8(%ebp),%eax
  1029d7:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  1029da:	eb 21                	jmp    1029fd <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  1029dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1029df:	0f b6 10             	movzbl (%eax),%edx
  1029e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1029e5:	88 10                	mov    %dl,(%eax)
  1029e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1029ea:	0f b6 00             	movzbl (%eax),%eax
  1029ed:	84 c0                	test   %al,%al
  1029ef:	74 04                	je     1029f5 <strncpy+0x27>
            src ++;
  1029f1:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  1029f5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1029f9:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  1029fd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102a01:	75 d9                	jne    1029dc <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  102a03:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102a06:	c9                   	leave  
  102a07:	c3                   	ret    

00102a08 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  102a08:	55                   	push   %ebp
  102a09:	89 e5                	mov    %esp,%ebp
  102a0b:	57                   	push   %edi
  102a0c:	56                   	push   %esi
  102a0d:	83 ec 20             	sub    $0x20,%esp
  102a10:	8b 45 08             	mov    0x8(%ebp),%eax
  102a13:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102a16:	8b 45 0c             	mov    0xc(%ebp),%eax
  102a19:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  102a1c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102a1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102a22:	89 d1                	mov    %edx,%ecx
  102a24:	89 c2                	mov    %eax,%edx
  102a26:	89 ce                	mov    %ecx,%esi
  102a28:	89 d7                	mov    %edx,%edi
  102a2a:	ac                   	lods   %ds:(%esi),%al
  102a2b:	ae                   	scas   %es:(%edi),%al
  102a2c:	75 08                	jne    102a36 <strcmp+0x2e>
  102a2e:	84 c0                	test   %al,%al
  102a30:	75 f8                	jne    102a2a <strcmp+0x22>
  102a32:	31 c0                	xor    %eax,%eax
  102a34:	eb 04                	jmp    102a3a <strcmp+0x32>
  102a36:	19 c0                	sbb    %eax,%eax
  102a38:	0c 01                	or     $0x1,%al
  102a3a:	89 fa                	mov    %edi,%edx
  102a3c:	89 f1                	mov    %esi,%ecx
  102a3e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102a41:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  102a44:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            "orb $1, %%al;"
            "3:"
            : "=a" (ret), "=&S" (d0), "=&D" (d1)
            : "1" (s1), "2" (s2)
            : "memory");
    return ret;
  102a47:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
  102a4a:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  102a4b:	83 c4 20             	add    $0x20,%esp
  102a4e:	5e                   	pop    %esi
  102a4f:	5f                   	pop    %edi
  102a50:	5d                   	pop    %ebp
  102a51:	c3                   	ret    

00102a52 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  102a52:	55                   	push   %ebp
  102a53:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102a55:	eb 0c                	jmp    102a63 <strncmp+0x11>
        n --, s1 ++, s2 ++;
  102a57:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  102a5b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102a5f:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102a63:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102a67:	74 1a                	je     102a83 <strncmp+0x31>
  102a69:	8b 45 08             	mov    0x8(%ebp),%eax
  102a6c:	0f b6 00             	movzbl (%eax),%eax
  102a6f:	84 c0                	test   %al,%al
  102a71:	74 10                	je     102a83 <strncmp+0x31>
  102a73:	8b 45 08             	mov    0x8(%ebp),%eax
  102a76:	0f b6 10             	movzbl (%eax),%edx
  102a79:	8b 45 0c             	mov    0xc(%ebp),%eax
  102a7c:	0f b6 00             	movzbl (%eax),%eax
  102a7f:	38 c2                	cmp    %al,%dl
  102a81:	74 d4                	je     102a57 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  102a83:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102a87:	74 18                	je     102aa1 <strncmp+0x4f>
  102a89:	8b 45 08             	mov    0x8(%ebp),%eax
  102a8c:	0f b6 00             	movzbl (%eax),%eax
  102a8f:	0f b6 d0             	movzbl %al,%edx
  102a92:	8b 45 0c             	mov    0xc(%ebp),%eax
  102a95:	0f b6 00             	movzbl (%eax),%eax
  102a98:	0f b6 c0             	movzbl %al,%eax
  102a9b:	29 c2                	sub    %eax,%edx
  102a9d:	89 d0                	mov    %edx,%eax
  102a9f:	eb 05                	jmp    102aa6 <strncmp+0x54>
  102aa1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102aa6:	5d                   	pop    %ebp
  102aa7:	c3                   	ret    

00102aa8 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  102aa8:	55                   	push   %ebp
  102aa9:	89 e5                	mov    %esp,%ebp
  102aab:	83 ec 04             	sub    $0x4,%esp
  102aae:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ab1:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102ab4:	eb 14                	jmp    102aca <strchr+0x22>
        if (*s == c) {
  102ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  102ab9:	0f b6 00             	movzbl (%eax),%eax
  102abc:	3a 45 fc             	cmp    -0x4(%ebp),%al
  102abf:	75 05                	jne    102ac6 <strchr+0x1e>
            return (char *)s;
  102ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  102ac4:	eb 13                	jmp    102ad9 <strchr+0x31>
        }
        s ++;
  102ac6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  102aca:	8b 45 08             	mov    0x8(%ebp),%eax
  102acd:	0f b6 00             	movzbl (%eax),%eax
  102ad0:	84 c0                	test   %al,%al
  102ad2:	75 e2                	jne    102ab6 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  102ad4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102ad9:	c9                   	leave  
  102ada:	c3                   	ret    

00102adb <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  102adb:	55                   	push   %ebp
  102adc:	89 e5                	mov    %esp,%ebp
  102ade:	83 ec 04             	sub    $0x4,%esp
  102ae1:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ae4:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102ae7:	eb 0f                	jmp    102af8 <strfind+0x1d>
        if (*s == c) {
  102ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  102aec:	0f b6 00             	movzbl (%eax),%eax
  102aef:	3a 45 fc             	cmp    -0x4(%ebp),%al
  102af2:	74 10                	je     102b04 <strfind+0x29>
            break;
        }
        s ++;
  102af4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  102af8:	8b 45 08             	mov    0x8(%ebp),%eax
  102afb:	0f b6 00             	movzbl (%eax),%eax
  102afe:	84 c0                	test   %al,%al
  102b00:	75 e7                	jne    102ae9 <strfind+0xe>
  102b02:	eb 01                	jmp    102b05 <strfind+0x2a>
        if (*s == c) {
            break;
  102b04:	90                   	nop
        }
        s ++;
    }
    return (char *)s;
  102b05:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102b08:	c9                   	leave  
  102b09:	c3                   	ret    

00102b0a <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  102b0a:	55                   	push   %ebp
  102b0b:	89 e5                	mov    %esp,%ebp
  102b0d:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  102b10:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  102b17:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  102b1e:	eb 04                	jmp    102b24 <strtol+0x1a>
        s ++;
  102b20:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  102b24:	8b 45 08             	mov    0x8(%ebp),%eax
  102b27:	0f b6 00             	movzbl (%eax),%eax
  102b2a:	3c 20                	cmp    $0x20,%al
  102b2c:	74 f2                	je     102b20 <strtol+0x16>
  102b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  102b31:	0f b6 00             	movzbl (%eax),%eax
  102b34:	3c 09                	cmp    $0x9,%al
  102b36:	74 e8                	je     102b20 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  102b38:	8b 45 08             	mov    0x8(%ebp),%eax
  102b3b:	0f b6 00             	movzbl (%eax),%eax
  102b3e:	3c 2b                	cmp    $0x2b,%al
  102b40:	75 06                	jne    102b48 <strtol+0x3e>
        s ++;
  102b42:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102b46:	eb 15                	jmp    102b5d <strtol+0x53>
    }
    else if (*s == '-') {
  102b48:	8b 45 08             	mov    0x8(%ebp),%eax
  102b4b:	0f b6 00             	movzbl (%eax),%eax
  102b4e:	3c 2d                	cmp    $0x2d,%al
  102b50:	75 0b                	jne    102b5d <strtol+0x53>
        s ++, neg = 1;
  102b52:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102b56:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  102b5d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102b61:	74 06                	je     102b69 <strtol+0x5f>
  102b63:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  102b67:	75 24                	jne    102b8d <strtol+0x83>
  102b69:	8b 45 08             	mov    0x8(%ebp),%eax
  102b6c:	0f b6 00             	movzbl (%eax),%eax
  102b6f:	3c 30                	cmp    $0x30,%al
  102b71:	75 1a                	jne    102b8d <strtol+0x83>
  102b73:	8b 45 08             	mov    0x8(%ebp),%eax
  102b76:	83 c0 01             	add    $0x1,%eax
  102b79:	0f b6 00             	movzbl (%eax),%eax
  102b7c:	3c 78                	cmp    $0x78,%al
  102b7e:	75 0d                	jne    102b8d <strtol+0x83>
        s += 2, base = 16;
  102b80:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  102b84:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  102b8b:	eb 2a                	jmp    102bb7 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  102b8d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102b91:	75 17                	jne    102baa <strtol+0xa0>
  102b93:	8b 45 08             	mov    0x8(%ebp),%eax
  102b96:	0f b6 00             	movzbl (%eax),%eax
  102b99:	3c 30                	cmp    $0x30,%al
  102b9b:	75 0d                	jne    102baa <strtol+0xa0>
        s ++, base = 8;
  102b9d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102ba1:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  102ba8:	eb 0d                	jmp    102bb7 <strtol+0xad>
    }
    else if (base == 0) {
  102baa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102bae:	75 07                	jne    102bb7 <strtol+0xad>
        base = 10;
  102bb0:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  102bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  102bba:	0f b6 00             	movzbl (%eax),%eax
  102bbd:	3c 2f                	cmp    $0x2f,%al
  102bbf:	7e 1b                	jle    102bdc <strtol+0xd2>
  102bc1:	8b 45 08             	mov    0x8(%ebp),%eax
  102bc4:	0f b6 00             	movzbl (%eax),%eax
  102bc7:	3c 39                	cmp    $0x39,%al
  102bc9:	7f 11                	jg     102bdc <strtol+0xd2>
            dig = *s - '0';
  102bcb:	8b 45 08             	mov    0x8(%ebp),%eax
  102bce:	0f b6 00             	movzbl (%eax),%eax
  102bd1:	0f be c0             	movsbl %al,%eax
  102bd4:	83 e8 30             	sub    $0x30,%eax
  102bd7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102bda:	eb 48                	jmp    102c24 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  102bdc:	8b 45 08             	mov    0x8(%ebp),%eax
  102bdf:	0f b6 00             	movzbl (%eax),%eax
  102be2:	3c 60                	cmp    $0x60,%al
  102be4:	7e 1b                	jle    102c01 <strtol+0xf7>
  102be6:	8b 45 08             	mov    0x8(%ebp),%eax
  102be9:	0f b6 00             	movzbl (%eax),%eax
  102bec:	3c 7a                	cmp    $0x7a,%al
  102bee:	7f 11                	jg     102c01 <strtol+0xf7>
            dig = *s - 'a' + 10;
  102bf0:	8b 45 08             	mov    0x8(%ebp),%eax
  102bf3:	0f b6 00             	movzbl (%eax),%eax
  102bf6:	0f be c0             	movsbl %al,%eax
  102bf9:	83 e8 57             	sub    $0x57,%eax
  102bfc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102bff:	eb 23                	jmp    102c24 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  102c01:	8b 45 08             	mov    0x8(%ebp),%eax
  102c04:	0f b6 00             	movzbl (%eax),%eax
  102c07:	3c 40                	cmp    $0x40,%al
  102c09:	7e 3c                	jle    102c47 <strtol+0x13d>
  102c0b:	8b 45 08             	mov    0x8(%ebp),%eax
  102c0e:	0f b6 00             	movzbl (%eax),%eax
  102c11:	3c 5a                	cmp    $0x5a,%al
  102c13:	7f 32                	jg     102c47 <strtol+0x13d>
            dig = *s - 'A' + 10;
  102c15:	8b 45 08             	mov    0x8(%ebp),%eax
  102c18:	0f b6 00             	movzbl (%eax),%eax
  102c1b:	0f be c0             	movsbl %al,%eax
  102c1e:	83 e8 37             	sub    $0x37,%eax
  102c21:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  102c24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c27:	3b 45 10             	cmp    0x10(%ebp),%eax
  102c2a:	7d 1a                	jge    102c46 <strtol+0x13c>
            break;
        }
        s ++, val = (val * base) + dig;
  102c2c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102c30:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102c33:	0f af 45 10          	imul   0x10(%ebp),%eax
  102c37:	89 c2                	mov    %eax,%edx
  102c39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c3c:	01 d0                	add    %edx,%eax
  102c3e:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  102c41:	e9 71 ff ff ff       	jmp    102bb7 <strtol+0xad>
        }
        else {
            break;
        }
        if (dig >= base) {
            break;
  102c46:	90                   	nop
        }
        s ++, val = (val * base) + dig;
        // we don't properly detect overflow!
    }

    if (endptr) {
  102c47:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102c4b:	74 08                	je     102c55 <strtol+0x14b>
        *endptr = (char *) s;
  102c4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c50:	8b 55 08             	mov    0x8(%ebp),%edx
  102c53:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  102c55:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  102c59:	74 07                	je     102c62 <strtol+0x158>
  102c5b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102c5e:	f7 d8                	neg    %eax
  102c60:	eb 03                	jmp    102c65 <strtol+0x15b>
  102c62:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  102c65:	c9                   	leave  
  102c66:	c3                   	ret    

00102c67 <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  102c67:	55                   	push   %ebp
  102c68:	89 e5                	mov    %esp,%ebp
  102c6a:	57                   	push   %edi
  102c6b:	83 ec 24             	sub    $0x24,%esp
  102c6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c71:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  102c74:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  102c78:	8b 55 08             	mov    0x8(%ebp),%edx
  102c7b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  102c7e:	88 45 f7             	mov    %al,-0x9(%ebp)
  102c81:	8b 45 10             	mov    0x10(%ebp),%eax
  102c84:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  102c87:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  102c8a:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  102c8e:	8b 55 f8             	mov    -0x8(%ebp),%edx
  102c91:	89 d7                	mov    %edx,%edi
  102c93:	f3 aa                	rep stos %al,%es:(%edi)
  102c95:	89 fa                	mov    %edi,%edx
  102c97:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102c9a:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  102c9d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102ca0:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  102ca1:	83 c4 24             	add    $0x24,%esp
  102ca4:	5f                   	pop    %edi
  102ca5:	5d                   	pop    %ebp
  102ca6:	c3                   	ret    

00102ca7 <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  102ca7:	55                   	push   %ebp
  102ca8:	89 e5                	mov    %esp,%ebp
  102caa:	57                   	push   %edi
  102cab:	56                   	push   %esi
  102cac:	53                   	push   %ebx
  102cad:	83 ec 30             	sub    $0x30,%esp
  102cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  102cb3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102cb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  102cb9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102cbc:	8b 45 10             	mov    0x10(%ebp),%eax
  102cbf:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  102cc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102cc5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  102cc8:	73 42                	jae    102d0c <memmove+0x65>
  102cca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ccd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102cd0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102cd3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102cd6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102cd9:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  102cdc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102cdf:	c1 e8 02             	shr    $0x2,%eax
  102ce2:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  102ce4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102ce7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102cea:	89 d7                	mov    %edx,%edi
  102cec:	89 c6                	mov    %eax,%esi
  102cee:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  102cf0:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  102cf3:	83 e1 03             	and    $0x3,%ecx
  102cf6:	74 02                	je     102cfa <memmove+0x53>
  102cf8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102cfa:	89 f0                	mov    %esi,%eax
  102cfc:	89 fa                	mov    %edi,%edx
  102cfe:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  102d01:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102d04:	89 45 d0             	mov    %eax,-0x30(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  102d07:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
  102d0a:	eb 36                	jmp    102d42 <memmove+0x9b>
    asm volatile (
            "std;"
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  102d0c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102d0f:	8d 50 ff             	lea    -0x1(%eax),%edx
  102d12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102d15:	01 c2                	add    %eax,%edx
  102d17:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102d1a:	8d 48 ff             	lea    -0x1(%eax),%ecx
  102d1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d20:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  102d23:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102d26:	89 c1                	mov    %eax,%ecx
  102d28:	89 d8                	mov    %ebx,%eax
  102d2a:	89 d6                	mov    %edx,%esi
  102d2c:	89 c7                	mov    %eax,%edi
  102d2e:	fd                   	std    
  102d2f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102d31:	fc                   	cld    
  102d32:	89 f8                	mov    %edi,%eax
  102d34:	89 f2                	mov    %esi,%edx
  102d36:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  102d39:	89 55 c8             	mov    %edx,-0x38(%ebp)
  102d3c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
            : "memory");
    return dst;
  102d3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  102d42:	83 c4 30             	add    $0x30,%esp
  102d45:	5b                   	pop    %ebx
  102d46:	5e                   	pop    %esi
  102d47:	5f                   	pop    %edi
  102d48:	5d                   	pop    %ebp
  102d49:	c3                   	ret    

00102d4a <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  102d4a:	55                   	push   %ebp
  102d4b:	89 e5                	mov    %esp,%ebp
  102d4d:	57                   	push   %edi
  102d4e:	56                   	push   %esi
  102d4f:	83 ec 20             	sub    $0x20,%esp
  102d52:	8b 45 08             	mov    0x8(%ebp),%eax
  102d55:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102d58:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102d5e:	8b 45 10             	mov    0x10(%ebp),%eax
  102d61:	89 45 ec             	mov    %eax,-0x14(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  102d64:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102d67:	c1 e8 02             	shr    $0x2,%eax
  102d6a:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  102d6c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102d6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d72:	89 d7                	mov    %edx,%edi
  102d74:	89 c6                	mov    %eax,%esi
  102d76:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  102d78:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  102d7b:	83 e1 03             	and    $0x3,%ecx
  102d7e:	74 02                	je     102d82 <memcpy+0x38>
  102d80:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102d82:	89 f0                	mov    %esi,%eax
  102d84:	89 fa                	mov    %edi,%edx
  102d86:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  102d89:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  102d8c:	89 45 e0             	mov    %eax,-0x20(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  102d8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
  102d92:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  102d93:	83 c4 20             	add    $0x20,%esp
  102d96:	5e                   	pop    %esi
  102d97:	5f                   	pop    %edi
  102d98:	5d                   	pop    %ebp
  102d99:	c3                   	ret    

00102d9a <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  102d9a:	55                   	push   %ebp
  102d9b:	89 e5                	mov    %esp,%ebp
  102d9d:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  102da0:	8b 45 08             	mov    0x8(%ebp),%eax
  102da3:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  102da6:	8b 45 0c             	mov    0xc(%ebp),%eax
  102da9:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  102dac:	eb 30                	jmp    102dde <memcmp+0x44>
        if (*s1 != *s2) {
  102dae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102db1:	0f b6 10             	movzbl (%eax),%edx
  102db4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102db7:	0f b6 00             	movzbl (%eax),%eax
  102dba:	38 c2                	cmp    %al,%dl
  102dbc:	74 18                	je     102dd6 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  102dbe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102dc1:	0f b6 00             	movzbl (%eax),%eax
  102dc4:	0f b6 d0             	movzbl %al,%edx
  102dc7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102dca:	0f b6 00             	movzbl (%eax),%eax
  102dcd:	0f b6 c0             	movzbl %al,%eax
  102dd0:	29 c2                	sub    %eax,%edx
  102dd2:	89 d0                	mov    %edx,%eax
  102dd4:	eb 1a                	jmp    102df0 <memcmp+0x56>
        }
        s1 ++, s2 ++;
  102dd6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  102dda:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  102dde:	8b 45 10             	mov    0x10(%ebp),%eax
  102de1:	8d 50 ff             	lea    -0x1(%eax),%edx
  102de4:	89 55 10             	mov    %edx,0x10(%ebp)
  102de7:	85 c0                	test   %eax,%eax
  102de9:	75 c3                	jne    102dae <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  102deb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102df0:	c9                   	leave  
  102df1:	c3                   	ret    

00102df2 <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  102df2:	55                   	push   %ebp
  102df3:	89 e5                	mov    %esp,%ebp
  102df5:	83 ec 38             	sub    $0x38,%esp
  102df8:	8b 45 10             	mov    0x10(%ebp),%eax
  102dfb:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102dfe:	8b 45 14             	mov    0x14(%ebp),%eax
  102e01:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  102e04:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102e07:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102e0a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102e0d:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  102e10:	8b 45 18             	mov    0x18(%ebp),%eax
  102e13:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102e16:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102e19:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102e1c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102e1f:	89 55 f0             	mov    %edx,-0x10(%ebp)
  102e22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e25:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102e28:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102e2c:	74 1c                	je     102e4a <printnum+0x58>
  102e2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e31:	ba 00 00 00 00       	mov    $0x0,%edx
  102e36:	f7 75 e4             	divl   -0x1c(%ebp)
  102e39:	89 55 f4             	mov    %edx,-0xc(%ebp)
  102e3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e3f:	ba 00 00 00 00       	mov    $0x0,%edx
  102e44:	f7 75 e4             	divl   -0x1c(%ebp)
  102e47:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e4a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102e4d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102e50:	f7 75 e4             	divl   -0x1c(%ebp)
  102e53:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102e56:	89 55 dc             	mov    %edx,-0x24(%ebp)
  102e59:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102e5c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102e5f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102e62:	89 55 ec             	mov    %edx,-0x14(%ebp)
  102e65:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102e68:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  102e6b:	8b 45 18             	mov    0x18(%ebp),%eax
  102e6e:	ba 00 00 00 00       	mov    $0x0,%edx
  102e73:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102e76:	77 41                	ja     102eb9 <printnum+0xc7>
  102e78:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102e7b:	72 05                	jb     102e82 <printnum+0x90>
  102e7d:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  102e80:	77 37                	ja     102eb9 <printnum+0xc7>
        printnum(putch, putdat, result, base, width - 1, padc);
  102e82:	8b 45 1c             	mov    0x1c(%ebp),%eax
  102e85:	83 e8 01             	sub    $0x1,%eax
  102e88:	83 ec 04             	sub    $0x4,%esp
  102e8b:	ff 75 20             	pushl  0x20(%ebp)
  102e8e:	50                   	push   %eax
  102e8f:	ff 75 18             	pushl  0x18(%ebp)
  102e92:	ff 75 ec             	pushl  -0x14(%ebp)
  102e95:	ff 75 e8             	pushl  -0x18(%ebp)
  102e98:	ff 75 0c             	pushl  0xc(%ebp)
  102e9b:	ff 75 08             	pushl  0x8(%ebp)
  102e9e:	e8 4f ff ff ff       	call   102df2 <printnum>
  102ea3:	83 c4 20             	add    $0x20,%esp
  102ea6:	eb 1b                	jmp    102ec3 <printnum+0xd1>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  102ea8:	83 ec 08             	sub    $0x8,%esp
  102eab:	ff 75 0c             	pushl  0xc(%ebp)
  102eae:	ff 75 20             	pushl  0x20(%ebp)
  102eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  102eb4:	ff d0                	call   *%eax
  102eb6:	83 c4 10             	add    $0x10,%esp
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  102eb9:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  102ebd:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  102ec1:	7f e5                	jg     102ea8 <printnum+0xb6>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  102ec3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102ec6:	05 90 3b 10 00       	add    $0x103b90,%eax
  102ecb:	0f b6 00             	movzbl (%eax),%eax
  102ece:	0f be c0             	movsbl %al,%eax
  102ed1:	83 ec 08             	sub    $0x8,%esp
  102ed4:	ff 75 0c             	pushl  0xc(%ebp)
  102ed7:	50                   	push   %eax
  102ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  102edb:	ff d0                	call   *%eax
  102edd:	83 c4 10             	add    $0x10,%esp
}
  102ee0:	90                   	nop
  102ee1:	c9                   	leave  
  102ee2:	c3                   	ret    

00102ee3 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  102ee3:	55                   	push   %ebp
  102ee4:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102ee6:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102eea:	7e 14                	jle    102f00 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  102eec:	8b 45 08             	mov    0x8(%ebp),%eax
  102eef:	8b 00                	mov    (%eax),%eax
  102ef1:	8d 48 08             	lea    0x8(%eax),%ecx
  102ef4:	8b 55 08             	mov    0x8(%ebp),%edx
  102ef7:	89 0a                	mov    %ecx,(%edx)
  102ef9:	8b 50 04             	mov    0x4(%eax),%edx
  102efc:	8b 00                	mov    (%eax),%eax
  102efe:	eb 30                	jmp    102f30 <getuint+0x4d>
    }
    else if (lflag) {
  102f00:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102f04:	74 16                	je     102f1c <getuint+0x39>
        return va_arg(*ap, unsigned long);
  102f06:	8b 45 08             	mov    0x8(%ebp),%eax
  102f09:	8b 00                	mov    (%eax),%eax
  102f0b:	8d 48 04             	lea    0x4(%eax),%ecx
  102f0e:	8b 55 08             	mov    0x8(%ebp),%edx
  102f11:	89 0a                	mov    %ecx,(%edx)
  102f13:	8b 00                	mov    (%eax),%eax
  102f15:	ba 00 00 00 00       	mov    $0x0,%edx
  102f1a:	eb 14                	jmp    102f30 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  102f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  102f1f:	8b 00                	mov    (%eax),%eax
  102f21:	8d 48 04             	lea    0x4(%eax),%ecx
  102f24:	8b 55 08             	mov    0x8(%ebp),%edx
  102f27:	89 0a                	mov    %ecx,(%edx)
  102f29:	8b 00                	mov    (%eax),%eax
  102f2b:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  102f30:	5d                   	pop    %ebp
  102f31:	c3                   	ret    

00102f32 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  102f32:	55                   	push   %ebp
  102f33:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102f35:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102f39:	7e 14                	jle    102f4f <getint+0x1d>
        return va_arg(*ap, long long);
  102f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  102f3e:	8b 00                	mov    (%eax),%eax
  102f40:	8d 48 08             	lea    0x8(%eax),%ecx
  102f43:	8b 55 08             	mov    0x8(%ebp),%edx
  102f46:	89 0a                	mov    %ecx,(%edx)
  102f48:	8b 50 04             	mov    0x4(%eax),%edx
  102f4b:	8b 00                	mov    (%eax),%eax
  102f4d:	eb 28                	jmp    102f77 <getint+0x45>
    }
    else if (lflag) {
  102f4f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102f53:	74 12                	je     102f67 <getint+0x35>
        return va_arg(*ap, long);
  102f55:	8b 45 08             	mov    0x8(%ebp),%eax
  102f58:	8b 00                	mov    (%eax),%eax
  102f5a:	8d 48 04             	lea    0x4(%eax),%ecx
  102f5d:	8b 55 08             	mov    0x8(%ebp),%edx
  102f60:	89 0a                	mov    %ecx,(%edx)
  102f62:	8b 00                	mov    (%eax),%eax
  102f64:	99                   	cltd   
  102f65:	eb 10                	jmp    102f77 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  102f67:	8b 45 08             	mov    0x8(%ebp),%eax
  102f6a:	8b 00                	mov    (%eax),%eax
  102f6c:	8d 48 04             	lea    0x4(%eax),%ecx
  102f6f:	8b 55 08             	mov    0x8(%ebp),%edx
  102f72:	89 0a                	mov    %ecx,(%edx)
  102f74:	8b 00                	mov    (%eax),%eax
  102f76:	99                   	cltd   
    }
}
  102f77:	5d                   	pop    %ebp
  102f78:	c3                   	ret    

00102f79 <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  102f79:	55                   	push   %ebp
  102f7a:	89 e5                	mov    %esp,%ebp
  102f7c:	83 ec 18             	sub    $0x18,%esp
    va_list ap;

    va_start(ap, fmt);
  102f7f:	8d 45 14             	lea    0x14(%ebp),%eax
  102f82:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  102f85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f88:	50                   	push   %eax
  102f89:	ff 75 10             	pushl  0x10(%ebp)
  102f8c:	ff 75 0c             	pushl  0xc(%ebp)
  102f8f:	ff 75 08             	pushl  0x8(%ebp)
  102f92:	e8 06 00 00 00       	call   102f9d <vprintfmt>
  102f97:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
  102f9a:	90                   	nop
  102f9b:	c9                   	leave  
  102f9c:	c3                   	ret    

00102f9d <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  102f9d:	55                   	push   %ebp
  102f9e:	89 e5                	mov    %esp,%ebp
  102fa0:	56                   	push   %esi
  102fa1:	53                   	push   %ebx
  102fa2:	83 ec 20             	sub    $0x20,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102fa5:	eb 17                	jmp    102fbe <vprintfmt+0x21>
            if (ch == '\0') {
  102fa7:	85 db                	test   %ebx,%ebx
  102fa9:	0f 84 8e 03 00 00    	je     10333d <vprintfmt+0x3a0>
                return;
            }
            putch(ch, putdat);
  102faf:	83 ec 08             	sub    $0x8,%esp
  102fb2:	ff 75 0c             	pushl  0xc(%ebp)
  102fb5:	53                   	push   %ebx
  102fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  102fb9:	ff d0                	call   *%eax
  102fbb:	83 c4 10             	add    $0x10,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102fbe:	8b 45 10             	mov    0x10(%ebp),%eax
  102fc1:	8d 50 01             	lea    0x1(%eax),%edx
  102fc4:	89 55 10             	mov    %edx,0x10(%ebp)
  102fc7:	0f b6 00             	movzbl (%eax),%eax
  102fca:	0f b6 d8             	movzbl %al,%ebx
  102fcd:	83 fb 25             	cmp    $0x25,%ebx
  102fd0:	75 d5                	jne    102fa7 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  102fd2:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  102fd6:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  102fdd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102fe0:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  102fe3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102fea:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102fed:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  102ff0:	8b 45 10             	mov    0x10(%ebp),%eax
  102ff3:	8d 50 01             	lea    0x1(%eax),%edx
  102ff6:	89 55 10             	mov    %edx,0x10(%ebp)
  102ff9:	0f b6 00             	movzbl (%eax),%eax
  102ffc:	0f b6 d8             	movzbl %al,%ebx
  102fff:	8d 43 dd             	lea    -0x23(%ebx),%eax
  103002:	83 f8 55             	cmp    $0x55,%eax
  103005:	0f 87 05 03 00 00    	ja     103310 <vprintfmt+0x373>
  10300b:	8b 04 85 b4 3b 10 00 	mov    0x103bb4(,%eax,4),%eax
  103012:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  103014:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  103018:	eb d6                	jmp    102ff0 <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  10301a:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  10301e:	eb d0                	jmp    102ff0 <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  103020:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  103027:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10302a:	89 d0                	mov    %edx,%eax
  10302c:	c1 e0 02             	shl    $0x2,%eax
  10302f:	01 d0                	add    %edx,%eax
  103031:	01 c0                	add    %eax,%eax
  103033:	01 d8                	add    %ebx,%eax
  103035:	83 e8 30             	sub    $0x30,%eax
  103038:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  10303b:	8b 45 10             	mov    0x10(%ebp),%eax
  10303e:	0f b6 00             	movzbl (%eax),%eax
  103041:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  103044:	83 fb 2f             	cmp    $0x2f,%ebx
  103047:	7e 39                	jle    103082 <vprintfmt+0xe5>
  103049:	83 fb 39             	cmp    $0x39,%ebx
  10304c:	7f 34                	jg     103082 <vprintfmt+0xe5>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  10304e:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  103052:	eb d3                	jmp    103027 <vprintfmt+0x8a>
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  103054:	8b 45 14             	mov    0x14(%ebp),%eax
  103057:	8d 50 04             	lea    0x4(%eax),%edx
  10305a:	89 55 14             	mov    %edx,0x14(%ebp)
  10305d:	8b 00                	mov    (%eax),%eax
  10305f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  103062:	eb 1f                	jmp    103083 <vprintfmt+0xe6>

        case '.':
            if (width < 0)
  103064:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103068:	79 86                	jns    102ff0 <vprintfmt+0x53>
                width = 0;
  10306a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  103071:	e9 7a ff ff ff       	jmp    102ff0 <vprintfmt+0x53>

        case '#':
            altflag = 1;
  103076:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  10307d:	e9 6e ff ff ff       	jmp    102ff0 <vprintfmt+0x53>
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
            goto process_precision;
  103082:	90                   	nop
        case '#':
            altflag = 1;
            goto reswitch;

        process_precision:
            if (width < 0)
  103083:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103087:	0f 89 63 ff ff ff    	jns    102ff0 <vprintfmt+0x53>
                width = precision, precision = -1;
  10308d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103090:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103093:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  10309a:	e9 51 ff ff ff       	jmp    102ff0 <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  10309f:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  1030a3:	e9 48 ff ff ff       	jmp    102ff0 <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  1030a8:	8b 45 14             	mov    0x14(%ebp),%eax
  1030ab:	8d 50 04             	lea    0x4(%eax),%edx
  1030ae:	89 55 14             	mov    %edx,0x14(%ebp)
  1030b1:	8b 00                	mov    (%eax),%eax
  1030b3:	83 ec 08             	sub    $0x8,%esp
  1030b6:	ff 75 0c             	pushl  0xc(%ebp)
  1030b9:	50                   	push   %eax
  1030ba:	8b 45 08             	mov    0x8(%ebp),%eax
  1030bd:	ff d0                	call   *%eax
  1030bf:	83 c4 10             	add    $0x10,%esp
            break;
  1030c2:	e9 71 02 00 00       	jmp    103338 <vprintfmt+0x39b>

        // error message
        case 'e':
            err = va_arg(ap, int);
  1030c7:	8b 45 14             	mov    0x14(%ebp),%eax
  1030ca:	8d 50 04             	lea    0x4(%eax),%edx
  1030cd:	89 55 14             	mov    %edx,0x14(%ebp)
  1030d0:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  1030d2:	85 db                	test   %ebx,%ebx
  1030d4:	79 02                	jns    1030d8 <vprintfmt+0x13b>
                err = -err;
  1030d6:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  1030d8:	83 fb 06             	cmp    $0x6,%ebx
  1030db:	7f 0b                	jg     1030e8 <vprintfmt+0x14b>
  1030dd:	8b 34 9d 74 3b 10 00 	mov    0x103b74(,%ebx,4),%esi
  1030e4:	85 f6                	test   %esi,%esi
  1030e6:	75 19                	jne    103101 <vprintfmt+0x164>
                printfmt(putch, putdat, "error %d", err);
  1030e8:	53                   	push   %ebx
  1030e9:	68 a1 3b 10 00       	push   $0x103ba1
  1030ee:	ff 75 0c             	pushl  0xc(%ebp)
  1030f1:	ff 75 08             	pushl  0x8(%ebp)
  1030f4:	e8 80 fe ff ff       	call   102f79 <printfmt>
  1030f9:	83 c4 10             	add    $0x10,%esp
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  1030fc:	e9 37 02 00 00       	jmp    103338 <vprintfmt+0x39b>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  103101:	56                   	push   %esi
  103102:	68 aa 3b 10 00       	push   $0x103baa
  103107:	ff 75 0c             	pushl  0xc(%ebp)
  10310a:	ff 75 08             	pushl  0x8(%ebp)
  10310d:	e8 67 fe ff ff       	call   102f79 <printfmt>
  103112:	83 c4 10             	add    $0x10,%esp
            }
            break;
  103115:	e9 1e 02 00 00       	jmp    103338 <vprintfmt+0x39b>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  10311a:	8b 45 14             	mov    0x14(%ebp),%eax
  10311d:	8d 50 04             	lea    0x4(%eax),%edx
  103120:	89 55 14             	mov    %edx,0x14(%ebp)
  103123:	8b 30                	mov    (%eax),%esi
  103125:	85 f6                	test   %esi,%esi
  103127:	75 05                	jne    10312e <vprintfmt+0x191>
                p = "(null)";
  103129:	be ad 3b 10 00       	mov    $0x103bad,%esi
            }
            if (width > 0 && padc != '-') {
  10312e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103132:	7e 76                	jle    1031aa <vprintfmt+0x20d>
  103134:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  103138:	74 70                	je     1031aa <vprintfmt+0x20d>
                for (width -= strnlen(p, precision); width > 0; width --) {
  10313a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10313d:	83 ec 08             	sub    $0x8,%esp
  103140:	50                   	push   %eax
  103141:	56                   	push   %esi
  103142:	e8 17 f8 ff ff       	call   10295e <strnlen>
  103147:	83 c4 10             	add    $0x10,%esp
  10314a:	89 c2                	mov    %eax,%edx
  10314c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10314f:	29 d0                	sub    %edx,%eax
  103151:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103154:	eb 17                	jmp    10316d <vprintfmt+0x1d0>
                    putch(padc, putdat);
  103156:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  10315a:	83 ec 08             	sub    $0x8,%esp
  10315d:	ff 75 0c             	pushl  0xc(%ebp)
  103160:	50                   	push   %eax
  103161:	8b 45 08             	mov    0x8(%ebp),%eax
  103164:	ff d0                	call   *%eax
  103166:	83 c4 10             	add    $0x10,%esp
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  103169:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  10316d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103171:	7f e3                	jg     103156 <vprintfmt+0x1b9>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  103173:	eb 35                	jmp    1031aa <vprintfmt+0x20d>
                if (altflag && (ch < ' ' || ch > '~')) {
  103175:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  103179:	74 1c                	je     103197 <vprintfmt+0x1fa>
  10317b:	83 fb 1f             	cmp    $0x1f,%ebx
  10317e:	7e 05                	jle    103185 <vprintfmt+0x1e8>
  103180:	83 fb 7e             	cmp    $0x7e,%ebx
  103183:	7e 12                	jle    103197 <vprintfmt+0x1fa>
                    putch('?', putdat);
  103185:	83 ec 08             	sub    $0x8,%esp
  103188:	ff 75 0c             	pushl  0xc(%ebp)
  10318b:	6a 3f                	push   $0x3f
  10318d:	8b 45 08             	mov    0x8(%ebp),%eax
  103190:	ff d0                	call   *%eax
  103192:	83 c4 10             	add    $0x10,%esp
  103195:	eb 0f                	jmp    1031a6 <vprintfmt+0x209>
                }
                else {
                    putch(ch, putdat);
  103197:	83 ec 08             	sub    $0x8,%esp
  10319a:	ff 75 0c             	pushl  0xc(%ebp)
  10319d:	53                   	push   %ebx
  10319e:	8b 45 08             	mov    0x8(%ebp),%eax
  1031a1:	ff d0                	call   *%eax
  1031a3:	83 c4 10             	add    $0x10,%esp
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  1031a6:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  1031aa:	89 f0                	mov    %esi,%eax
  1031ac:	8d 70 01             	lea    0x1(%eax),%esi
  1031af:	0f b6 00             	movzbl (%eax),%eax
  1031b2:	0f be d8             	movsbl %al,%ebx
  1031b5:	85 db                	test   %ebx,%ebx
  1031b7:	74 26                	je     1031df <vprintfmt+0x242>
  1031b9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1031bd:	78 b6                	js     103175 <vprintfmt+0x1d8>
  1031bf:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  1031c3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1031c7:	79 ac                	jns    103175 <vprintfmt+0x1d8>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  1031c9:	eb 14                	jmp    1031df <vprintfmt+0x242>
                putch(' ', putdat);
  1031cb:	83 ec 08             	sub    $0x8,%esp
  1031ce:	ff 75 0c             	pushl  0xc(%ebp)
  1031d1:	6a 20                	push   $0x20
  1031d3:	8b 45 08             	mov    0x8(%ebp),%eax
  1031d6:	ff d0                	call   *%eax
  1031d8:	83 c4 10             	add    $0x10,%esp
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  1031db:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  1031df:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1031e3:	7f e6                	jg     1031cb <vprintfmt+0x22e>
                putch(' ', putdat);
            }
            break;
  1031e5:	e9 4e 01 00 00       	jmp    103338 <vprintfmt+0x39b>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  1031ea:	83 ec 08             	sub    $0x8,%esp
  1031ed:	ff 75 e0             	pushl  -0x20(%ebp)
  1031f0:	8d 45 14             	lea    0x14(%ebp),%eax
  1031f3:	50                   	push   %eax
  1031f4:	e8 39 fd ff ff       	call   102f32 <getint>
  1031f9:	83 c4 10             	add    $0x10,%esp
  1031fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1031ff:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  103202:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103205:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103208:	85 d2                	test   %edx,%edx
  10320a:	79 23                	jns    10322f <vprintfmt+0x292>
                putch('-', putdat);
  10320c:	83 ec 08             	sub    $0x8,%esp
  10320f:	ff 75 0c             	pushl  0xc(%ebp)
  103212:	6a 2d                	push   $0x2d
  103214:	8b 45 08             	mov    0x8(%ebp),%eax
  103217:	ff d0                	call   *%eax
  103219:	83 c4 10             	add    $0x10,%esp
                num = -(long long)num;
  10321c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10321f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103222:	f7 d8                	neg    %eax
  103224:	83 d2 00             	adc    $0x0,%edx
  103227:	f7 da                	neg    %edx
  103229:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10322c:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  10322f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  103236:	e9 9f 00 00 00       	jmp    1032da <vprintfmt+0x33d>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  10323b:	83 ec 08             	sub    $0x8,%esp
  10323e:	ff 75 e0             	pushl  -0x20(%ebp)
  103241:	8d 45 14             	lea    0x14(%ebp),%eax
  103244:	50                   	push   %eax
  103245:	e8 99 fc ff ff       	call   102ee3 <getuint>
  10324a:	83 c4 10             	add    $0x10,%esp
  10324d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103250:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  103253:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  10325a:	eb 7e                	jmp    1032da <vprintfmt+0x33d>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  10325c:	83 ec 08             	sub    $0x8,%esp
  10325f:	ff 75 e0             	pushl  -0x20(%ebp)
  103262:	8d 45 14             	lea    0x14(%ebp),%eax
  103265:	50                   	push   %eax
  103266:	e8 78 fc ff ff       	call   102ee3 <getuint>
  10326b:	83 c4 10             	add    $0x10,%esp
  10326e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103271:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  103274:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  10327b:	eb 5d                	jmp    1032da <vprintfmt+0x33d>

        // pointer
        case 'p':
            putch('0', putdat);
  10327d:	83 ec 08             	sub    $0x8,%esp
  103280:	ff 75 0c             	pushl  0xc(%ebp)
  103283:	6a 30                	push   $0x30
  103285:	8b 45 08             	mov    0x8(%ebp),%eax
  103288:	ff d0                	call   *%eax
  10328a:	83 c4 10             	add    $0x10,%esp
            putch('x', putdat);
  10328d:	83 ec 08             	sub    $0x8,%esp
  103290:	ff 75 0c             	pushl  0xc(%ebp)
  103293:	6a 78                	push   $0x78
  103295:	8b 45 08             	mov    0x8(%ebp),%eax
  103298:	ff d0                	call   *%eax
  10329a:	83 c4 10             	add    $0x10,%esp
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  10329d:	8b 45 14             	mov    0x14(%ebp),%eax
  1032a0:	8d 50 04             	lea    0x4(%eax),%edx
  1032a3:	89 55 14             	mov    %edx,0x14(%ebp)
  1032a6:	8b 00                	mov    (%eax),%eax
  1032a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1032ab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  1032b2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  1032b9:	eb 1f                	jmp    1032da <vprintfmt+0x33d>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  1032bb:	83 ec 08             	sub    $0x8,%esp
  1032be:	ff 75 e0             	pushl  -0x20(%ebp)
  1032c1:	8d 45 14             	lea    0x14(%ebp),%eax
  1032c4:	50                   	push   %eax
  1032c5:	e8 19 fc ff ff       	call   102ee3 <getuint>
  1032ca:	83 c4 10             	add    $0x10,%esp
  1032cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1032d0:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  1032d3:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  1032da:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  1032de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1032e1:	83 ec 04             	sub    $0x4,%esp
  1032e4:	52                   	push   %edx
  1032e5:	ff 75 e8             	pushl  -0x18(%ebp)
  1032e8:	50                   	push   %eax
  1032e9:	ff 75 f4             	pushl  -0xc(%ebp)
  1032ec:	ff 75 f0             	pushl  -0x10(%ebp)
  1032ef:	ff 75 0c             	pushl  0xc(%ebp)
  1032f2:	ff 75 08             	pushl  0x8(%ebp)
  1032f5:	e8 f8 fa ff ff       	call   102df2 <printnum>
  1032fa:	83 c4 20             	add    $0x20,%esp
            break;
  1032fd:	eb 39                	jmp    103338 <vprintfmt+0x39b>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  1032ff:	83 ec 08             	sub    $0x8,%esp
  103302:	ff 75 0c             	pushl  0xc(%ebp)
  103305:	53                   	push   %ebx
  103306:	8b 45 08             	mov    0x8(%ebp),%eax
  103309:	ff d0                	call   *%eax
  10330b:	83 c4 10             	add    $0x10,%esp
            break;
  10330e:	eb 28                	jmp    103338 <vprintfmt+0x39b>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  103310:	83 ec 08             	sub    $0x8,%esp
  103313:	ff 75 0c             	pushl  0xc(%ebp)
  103316:	6a 25                	push   $0x25
  103318:	8b 45 08             	mov    0x8(%ebp),%eax
  10331b:	ff d0                	call   *%eax
  10331d:	83 c4 10             	add    $0x10,%esp
            for (fmt --; fmt[-1] != '%'; fmt --)
  103320:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  103324:	eb 04                	jmp    10332a <vprintfmt+0x38d>
  103326:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  10332a:	8b 45 10             	mov    0x10(%ebp),%eax
  10332d:	83 e8 01             	sub    $0x1,%eax
  103330:	0f b6 00             	movzbl (%eax),%eax
  103333:	3c 25                	cmp    $0x25,%al
  103335:	75 ef                	jne    103326 <vprintfmt+0x389>
                /* do nothing */;
            break;
  103337:	90                   	nop
        }
    }
  103338:	e9 68 fc ff ff       	jmp    102fa5 <vprintfmt+0x8>
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
            if (ch == '\0') {
                return;
  10333d:	90                   	nop
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  10333e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  103341:	5b                   	pop    %ebx
  103342:	5e                   	pop    %esi
  103343:	5d                   	pop    %ebp
  103344:	c3                   	ret    

00103345 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  103345:	55                   	push   %ebp
  103346:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  103348:	8b 45 0c             	mov    0xc(%ebp),%eax
  10334b:	8b 40 08             	mov    0x8(%eax),%eax
  10334e:	8d 50 01             	lea    0x1(%eax),%edx
  103351:	8b 45 0c             	mov    0xc(%ebp),%eax
  103354:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  103357:	8b 45 0c             	mov    0xc(%ebp),%eax
  10335a:	8b 10                	mov    (%eax),%edx
  10335c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10335f:	8b 40 04             	mov    0x4(%eax),%eax
  103362:	39 c2                	cmp    %eax,%edx
  103364:	73 12                	jae    103378 <sprintputch+0x33>
        *b->buf ++ = ch;
  103366:	8b 45 0c             	mov    0xc(%ebp),%eax
  103369:	8b 00                	mov    (%eax),%eax
  10336b:	8d 48 01             	lea    0x1(%eax),%ecx
  10336e:	8b 55 0c             	mov    0xc(%ebp),%edx
  103371:	89 0a                	mov    %ecx,(%edx)
  103373:	8b 55 08             	mov    0x8(%ebp),%edx
  103376:	88 10                	mov    %dl,(%eax)
    }
}
  103378:	90                   	nop
  103379:	5d                   	pop    %ebp
  10337a:	c3                   	ret    

0010337b <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  10337b:	55                   	push   %ebp
  10337c:	89 e5                	mov    %esp,%ebp
  10337e:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  103381:	8d 45 14             	lea    0x14(%ebp),%eax
  103384:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  103387:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10338a:	50                   	push   %eax
  10338b:	ff 75 10             	pushl  0x10(%ebp)
  10338e:	ff 75 0c             	pushl  0xc(%ebp)
  103391:	ff 75 08             	pushl  0x8(%ebp)
  103394:	e8 0b 00 00 00       	call   1033a4 <vsnprintf>
  103399:	83 c4 10             	add    $0x10,%esp
  10339c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10339f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1033a2:	c9                   	leave  
  1033a3:	c3                   	ret    

001033a4 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  1033a4:	55                   	push   %ebp
  1033a5:	89 e5                	mov    %esp,%ebp
  1033a7:	83 ec 18             	sub    $0x18,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  1033aa:	8b 45 08             	mov    0x8(%ebp),%eax
  1033ad:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1033b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1033b3:	8d 50 ff             	lea    -0x1(%eax),%edx
  1033b6:	8b 45 08             	mov    0x8(%ebp),%eax
  1033b9:	01 d0                	add    %edx,%eax
  1033bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1033be:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  1033c5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1033c9:	74 0a                	je     1033d5 <vsnprintf+0x31>
  1033cb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1033ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1033d1:	39 c2                	cmp    %eax,%edx
  1033d3:	76 07                	jbe    1033dc <vsnprintf+0x38>
        return -E_INVAL;
  1033d5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  1033da:	eb 20                	jmp    1033fc <vsnprintf+0x58>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  1033dc:	ff 75 14             	pushl  0x14(%ebp)
  1033df:	ff 75 10             	pushl  0x10(%ebp)
  1033e2:	8d 45 ec             	lea    -0x14(%ebp),%eax
  1033e5:	50                   	push   %eax
  1033e6:	68 45 33 10 00       	push   $0x103345
  1033eb:	e8 ad fb ff ff       	call   102f9d <vprintfmt>
  1033f0:	83 c4 10             	add    $0x10,%esp
    // null terminate the buffer
    *b.buf = '\0';
  1033f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1033f6:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  1033f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1033fc:	c9                   	leave  
  1033fd:	c3                   	ret    
