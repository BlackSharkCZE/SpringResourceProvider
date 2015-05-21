package sk.anext.service;

import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import sk.anext.model.Employee;

import java.security.SecureRandom;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Set;

/**
 * <strong>Created with IntelliJ IDEA</strong><br/>
 * User: Jiri Pejsa<br/>
 * Date: 15.5.15<br/>
 * Time: 14:14<br/>
 * <p>To change this template use File | Settings | File Templates.</p>
 */
@Controller
@RequestMapping("/employee")
public class EmployeeService {

	private static Set<Employee> employees;

	static {
		employees = new HashSet();
		Employee foobar = null;
		for (int i = 0; i < 10; i++) {
			double sal = new SecureRandom().nextInt(400)*500;
			foobar = new Employee(i, "Employee " + i, sal );
			employees.add(foobar);
		}
	}

	@RequestMapping(value = "/{employeeId}", method = RequestMethod.GET, headers = "Accept=application/json", produces = {"application/json"})
	@ResponseBody
	public Employee getFoobar(@PathVariable int employeeId) {
		for (Employee e : employees) {
			if (e.getId() == employeeId) {
				return e;
			}
		}
		return null;
	}

	@RequestMapping(value = "/htmllist", method = RequestMethod.GET, headers = "Accept=text/html", produces = {"text/html"})
	@ResponseBody
	public String getFoobarListHTML() {
		String retVal = "<html><body><table border=1>";
		for (Employee f : employees) {
			retVal += "<tr><td>" + f.getId() + "</td><td>" + f.getName() + "</td><td>" + f.getSalary() + "</td></tr>";
		}
		retVal += "</table></body></html>";

		return retVal;
	}

	@RequestMapping(value = "/list", method = RequestMethod.GET, headers = "Accept=application/json", produces = {"application/json"})
	@ResponseBody
	public Set getFoobarList() {

		final SecurityContext context = SecurityContextHolder.getContext();

		return employees;
	}

	@RequestMapping(method = RequestMethod.GET, headers = "Accept=application/json", produces = {"application/json"})
	@ResponseBody
	public Set getFoobars() {
		return employees;
	}

	@RequestMapping(value = "/{employeeId}", method = RequestMethod.PUT, headers = "Accept=application/json", produces = {"application/json"}, consumes = {"application/json"})
	@ResponseBody
	public Employee editFoobar(@RequestBody Employee foobar, @PathVariable int employeeId) {

		for (Employee employee : employees) {
			if (employee.getId() == employeeId) {
				employee.setId(foobar.getId());
				employee.setName(foobar.getName());
				return employee;
			}
		}
		return null;
	}

	@RequestMapping(value = "/{employeeId}", method = RequestMethod.DELETE, headers = "Accept=application/json", produces = {"application/json"})
	@ResponseBody
	public boolean deleteFoobar(@PathVariable int employeeId) {
		System.out.println("Delete call.");
		Iterator fooIterator = employees.iterator();
		while (fooIterator.hasNext()) {
			Employee foobar = (Employee) fooIterator.next();
			System.out.println(foobar);
			if (foobar.getId() == employeeId) {
				fooIterator.remove();
				return true;
			}
		}
		return false;
	}

	@RequestMapping(method = RequestMethod.POST, headers = "Accept=application/json", produces = {"application/json"}, consumes = {"application/json"})
	@ResponseBody
	public boolean createFoobar(@RequestBody Employee employee) {
		return employees.add(employee);
	}

}
